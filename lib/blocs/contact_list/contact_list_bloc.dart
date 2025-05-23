// lib/blocs/contact_list/contact_list_bloc.dart
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/models/enums.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/utils/logger.dart'; // Adjust path if needed
import 'package:recall/services/notification_service.dart';
import 'package:recall/utils/contact_utils.dart';

part 'contact_list_event.dart';
part 'contact_list_state.dart';

class ContactListBloc extends Bloc<ContactListEvent, ContactListState> {
  final ContactRepository _contactRepository;
  final NotificationService _notificationService;
  late final StreamSubscription<List<Contact>> _contactStreamSubscription;

  ContactListBloc({
    required ContactRepository contactRepository,
    required NotificationService notificationService,
  })  : _contactRepository = contactRepository,
        _notificationService = notificationService,
        super(const InitialContactListState()) {
    _contactStreamSubscription =
        _contactRepository.contactStream.listen((contacts) {
      add(_ContactsUpdatedEvent(contacts)); // Dispatch an internal event
    });
// BEGIN EVENT HANDLING
    on<ContactListEvent>((event, emit) async {
      // LOAD CONTACTS (FOR ALL CONTACTS SCREEN)
      // MARK: LOAD
      if (event is LoadContactListEvent) {
        logger.i('LoadContactListEvent triggered with parameters: '
            'searchTerm=${event.searchTerm}, '
            'filters=${event.filters}, '
            'sortField=${event.sortField}, '
            'ascending=${event.ascending}');
        emit(const LoadingContactListState());
        try {
          // Load all contacts from the repository
          final allContacts = await _contactRepository.getAll();

          // Create a base state with parameters from the event
          final baseStateForLoad = LoadedContactListState(
            originalContacts: allContacts, // Will be used as newOriginalContacts
            displayedContacts: [], // Placeholder, will be determined by the helper
            sortField: event.sortField,
            ascending: event.ascending,
            searchTerm: event.searchTerm,
            activeFilters: event.filters,
          );

          _emitFilteredAndSortedState(
            newOriginalContacts: allContacts,
            currentState: baseStateForLoad,
            emit: emit,
          );
          // Logger message for successful load will be implicitly covered by helper's logic or can be added if needed
          // logger.i('Loaded ... contacts.'); // This was based on sortedContacts.length
        } catch (e) {
          logger.e('Error in LoadContactListEvent: $e');
          emit(ErrorContactListState(e.toString()));
        }
        // UPDATE CONTACT FROM LIST
        // MARK: UPDATE
      } else if (event is UpdateContactFromListEvent) {
        final currentState = state;
        if (currentState is! LoadedContactListState) {
          logger.w("Attempted to update contact from non-loaded state.");
          return;
        }

        logger.i(
            'UpdateContactFromListEvent: Received contact: ${event.contact}');
        emit(const LoadingContactListState()); // Indicate loading before processing
        try {
          final updatedContact = await _contactRepository.update(event.contact);
          logger.i(
              'UpdateContactFromListEvent: Updated contact in repository: $updatedContact');
          await _notificationService.scheduleReminder(updatedContact);

          final newOriginalContacts = currentState.originalContacts.map((c) {
            return c.id == updatedContact.id ? updatedContact : c;
          }).toList();

          _emitFilteredAndSortedState(
            newOriginalContacts: newOriginalContacts,
            currentState: currentState,
            emit: emit,
          );
          logger.i(
              "Successfully updated contact ${updatedContact.id} in list state.");
        } catch (err) {
          emit(ErrorContactListState(err.toString()));
          logger.e(
              "Error updating contact ID ${event.contact.id} from list: $err");
        }
        // SORT CONTACTS
        // MARK: SORT
      } else if (event is SortContactsEvent) {
        final currentState = state;
        if (currentState is LoadedContactListState) {
          final sortedContacts = _sortContacts(
              currentState.displayedContacts, event.sortField, event.ascending);
          emit(currentState.copyWith(
            displayedContacts: sortedContacts,
            sortField: event.sortField,
            ascending: event.ascending,
          ));
        }
        // SEARCH CONTACTS
        // MARK: SEARCH
      } else if (event is ApplySearchEvent) {
        final currentState = state;
        if (currentState is LoadedContactListState) {
          final filteredContacts = _applyFilterAndSearch(
              currentState.originalContacts,
              event.searchTerm,
              currentState.activeFilters);

          final sortedContacts = _sortContacts(
              filteredContacts, currentState.sortField, currentState.ascending);

          emit(currentState.copyWith(
            displayedContacts: sortedContacts,
            searchTerm: event.searchTerm,
          ));
        }
        // APPLY FILTERS
        // MARK: FILTER
      } else if (event is ApplyFilterEvent) {
        final currentState = state;
        if (currentState is LoadedContactListState) {
          final Set<ContactListFilterType> updatedFilters =
              Set.from(currentState.activeFilters);

          if (event.isActive) {
            updatedFilters.add(event.filterType);
          } else {
            updatedFilters.remove(event.filterType);
          }

          final filteredContacts = _applyFilterAndSearch(
              currentState.originalContacts,
              currentState.searchTerm,
              updatedFilters);

          final sortedContacts = _sortContacts(
              filteredContacts, currentState.sortField, currentState.ascending);

          emit(currentState.copyWith(
            displayedContacts: sortedContacts,
            activeFilters: updatedFilters,
          ));
        }
        // CLEAR ALL FILTERS
        // MARK: UN FILTER
      } else if (event is ClearFiltersEvent) {
        final currentState = state;
        if (currentState is LoadedContactListState) {
          final filteredContacts = _applyFilterAndSearch(
              currentState.originalContacts, currentState.searchTerm, {});

          final sortedContacts = _sortContacts(
              filteredContacts, currentState.sortField, currentState.ascending);

          emit(currentState.copyWith(
            displayedContacts: sortedContacts,
            activeFilters: {},
          ));
        }
        // DELETE MULTIPLE CONTACTS
        // MARK: DELETE
      } else if (event is DeleteContactsEvent) {
        final currentState = state;
        if (currentState is! LoadedContactListState) {
          logger.w("Attempted to delete contacts from non-loaded state.");
          return;
        }

        emit(const LoadingContactListState());
        try {
          await _contactRepository.deleteMany(event.contactIds);

          for (final contactId in event.contactIds) {
            await _notificationService.cancelNotification(contactId);
          }
          logger.i(
              'LOG: Deleted ${event.contactIds.length} contacts and cancelled notifications.');

          final newOriginalContacts = currentState.originalContacts
              .where((c) => !event.contactIds.contains(c.id))
              .toList();

          _emitFilteredAndSortedState(
            newOriginalContacts: newOriginalContacts,
            currentState: currentState,
            emit: emit,
          );
          // The helper handles EmptyContactListState if newOriginalContacts (and thus sorted) is empty.
          if (newOriginalContacts.isNotEmpty) {
             logger.i(
                "Successfully removed ${event.contactIds.length} contacts from list state.");
          } else {
            logger.i("All contacts removed, list is now empty.");
          }
        } catch (err) {
          emit(ErrorContactListState(err.toString()));
          logger.e("Error deleting contacts ${event.contactIds}: $err");
        }
        // TOGGLE ACTIVE STATUS FOR MULTIPLE CONTACTS
        // MARK: TOG Status
      } else if (event is ToggleContactsActiveStatusEvent) {
        final currentState = state;
        if (currentState is! LoadedContactListState) {
          logger.w("Attempted to toggle active status from non-loaded state.");
          return;
        }

        emit(const LoadingContactListState());
        try {
          for (int contactId in event.contactIds) {
            Contact? contact = await _contactRepository.getById(contactId);
            if (contact == null) {
              logger.w(
                  "Contact with ID $contactId not found for toggling active status.");
              continue;
            }
            final newActiveStatus = !contact.isActive;
            final updatedContact = contact.copyWith(isActive: newActiveStatus);
            await _contactRepository.update(updatedContact);

            if (newActiveStatus) {
              await _notificationService.scheduleReminder(updatedContact);
            } else {
              await _notificationService.cancelNotification(updatedContact.id!);
            }
          }

          logger.i(
              'Toggled active status for ${event.contactIds.length} contacts.');

          bool isHomeScreenView = currentState.activeFilters
                  .contains(ContactListFilterType.overdue) ||
              currentState.activeFilters
                  .contains(ContactListFilterType.dueSoon);

          List<Contact> newBaseContacts;
          if (isHomeScreenView) {
            final allRepoContacts = await _contactRepository.getAll();
            newBaseContacts = allRepoContacts.where((c) => c.isActive).toList();
          } else {
            newBaseContacts = await _contactRepository.getAll();
          }
          
          _emitFilteredAndSortedState(
            newOriginalContacts: newBaseContacts,
            currentState: currentState,
            emit: emit,
          );

        } catch (err) {
          emit(ErrorContactListState(err.toString()));
          logger.e(
              "Error toggling active status for contacts ${event.contactIds}: $err");
          // Consider re-emitting current loaded state if error occurs after some operations
           if (state is LoadingContactListState) { // If still loading, revert to previous loaded state
            emit(currentState);
          }
        }
        // MARK: MARK CONTACTS AS CONTACTED
      } else if (event is MarkContactsAsContactedEvent) {
        final currentState = state;
        if (currentState is! LoadedContactListState) {
          logger.w(
              "Attempted to mark contacts as contacted from non-loaded state.");
          return;
        }
        emit(const LoadingContactListState());
        try {
          final now = DateTime.now();
          List<Contact> updatedContactObjects = []; // Renamed to avoid conflict
          for (int contactId in event.contactIds) {
            final contact = await _contactRepository.getById(contactId);
            if (contact != null) {
              final contactWithJustUpdatedLastContactDate =
                  contact.copyWith(lastContactDate: now);
              final updatedContact =
                  contactWithJustUpdatedLastContactDate.copyWith(
                      nextContactDate: calculateNextContactDate(
                          contactWithJustUpdatedLastContactDate));
              await _contactRepository.update(updatedContact);
              await _notificationService.scheduleReminder(updatedContact);
              updatedContactObjects.add(updatedContact);
            }
          }

          final newOriginalContacts = currentState.originalContacts.map((c) {
            final updatedVersion = updatedContactObjects // Use renamed variable
                .firstWhere((uc) => uc.id == c.id, orElse: () => c);
            return updatedVersion;
          }).toList();

          _emitFilteredAndSortedState(
            newOriginalContacts: newOriginalContacts,
            currentState: currentState,
            emit: emit,
          );
          logger.i(
              "Successfully marked ${event.contactIds.length} contacts as contacted.");
        } catch (err) {
          emit(ErrorContactListState(err.toString()));
          logger.e("Error marking contacts as contacted: $err");
        }
      } else if (event is _ContactsUpdatedEvent) {
        // This event is triggered by the stream subscription
        final currentBlocState = state; // Renamed to avoid conflict with helper's currentState
        if (currentBlocState is LoadedContactListState) {
          _emitFilteredAndSortedState(
            newOriginalContacts: event.contacts,
            currentState: currentBlocState,
            emit: emit,
          );
        } else if (event.contacts.isEmpty) {
          emit(const EmptyContactListState());
        } else {
          // currentBlocState is not LoadedContactListState (e.g., Initial, Loading, Empty, Error)
          // Establish a baseline for sort/filter parameters.
          final defaultSortField = ContactListSortField.nextContactDate;
          final defaultAscending = true;
          final defaultSearchTerm = '';
          final defaultActiveFilters = <ContactListFilterType>{};

          final baseStateForUpdate = LoadedContactListState(
            originalContacts: event.contacts, 
            displayedContacts: [], // Placeholder, will be set by helper
            sortField: defaultSortField,
            ascending: defaultAscending,
            searchTerm: defaultSearchTerm,
            activeFilters: defaultActiveFilters,
          );

          _emitFilteredAndSortedState(
            newOriginalContacts: event.contacts,
            currentState: baseStateForUpdate,
            emit: emit,
          );
        }
      }
    });
  }
  @override
  Future<void> close() {
    _contactStreamSubscription.cancel(); // Cancel the subscription
    return super.close();
  }

  final Map<ContactListFilterType, bool Function(Contact)> filterFunctions = {
    ContactListFilterType.overdue: (contact) => isOverdue(contact),
    ContactListFilterType.dueSoon: (contact) => isDueSoon(contact),
    ContactListFilterType.active: (contact) => contact.isActive,
    ContactListFilterType.archived: (contact) => !contact.isActive,
    ContactListFilterType.homescreen: (contact) =>
        contact.isActive && (isOverdue(contact) || isDueSoon(contact)),
  };

  // MARK: FILTER
  List<Contact> _applyFilterAndSearch(List<Contact> originalContacts,
      String searchTerm, Set<ContactListFilterType> activeFilters) {
    List<Contact> filteredList = List.from(originalContacts);

    // Apply search term filtering
    if (searchTerm.isNotEmpty) {
      final lowerCaseSearchTerm = searchTerm.toLowerCase();
      filteredList = filteredList.where((contact) {
        return contact.firstName.toLowerCase().contains(lowerCaseSearchTerm) ||
            contact.lastName.toLowerCase().contains(lowerCaseSearchTerm) ||
            (contact.nickname?.toLowerCase().contains(lowerCaseSearchTerm) ??
                false);
      }).toList();
    }

    // If no filters are active, return the filtered list
    if (activeFilters.isEmpty) {
      return filteredList;
    }

    // Apply active filters dynamically
    return filteredList.where((contact) {
      for (final filter in activeFilters) {
        final filterFunction = filterFunctions[filter];
        if (filterFunction != null && !filterFunction(contact)) {
          return false; // If the contact doesn't match the filter, exclude it
        }
      }
      return true; // Include the contact if it matches all active filters
    }).toList();
  }

  // MARK: SORT
  List<Contact> _sortContacts(List<Contact> contactsToSort,
      ContactListSortField sortField, bool ascending) {
    const Map<ContactFrequency, int> frequencyOrder = {
      ContactFrequency.daily: 1,
      ContactFrequency.weekly: 2,
      ContactFrequency.biweekly: 3,
      ContactFrequency.monthly: 4,
      //ContactFrequency.quarterly: 5,
      //ContactFrequency.yearly: 6,
      //ContactFrequency.rarely: 7,
      ContactFrequency.never: 8,
    };

    List<Contact> sortedList = List.from(contactsToSort);

    sortedList.sort((a, b) {
      int comparison;
      switch (sortField) {
        case ContactListSortField.nextContactDate:
          DateTime dueA = calculateNextContactDate(a);
          DateTime dueB = calculateNextContactDate(b);
          bool aIsNever = a.frequency == ContactFrequency.never.value;
          bool bIsNever = b.frequency == ContactFrequency.never.value;
          if (aIsNever && bIsNever) {
            comparison = 0;
          } else if (aIsNever) {
            comparison = 1;
          } else if (bIsNever) {
            comparison = -1;
          } else {
            comparison = dueA.compareTo(dueB);
          }
          break;
        case ContactListSortField.lastName:
          comparison =
              a.lastName.toLowerCase().compareTo(b.lastName.toLowerCase());
          if (comparison == 0) {
            comparison =
                a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase());
          }
          break;
        case ContactListSortField.lastContactDate:
          DateTime lastA = a.lastContactDate ??
              (ascending ? DateTime(9999) : DateTime(1900));
          DateTime lastB = b.lastContactDate ??
              (ascending ? DateTime(9999) : DateTime(1900));
          comparison = lastA.compareTo(lastB);
          break;
        case ContactListSortField.birthday:
          DateTime? bdayA = a.birthday;
          DateTime? bdayB = b.birthday;
          if (bdayA == null && bdayB == null) {
            comparison = 0;
          } else if (bdayA == null) {
            comparison = ascending ? 1 : -1;
          } else if (bdayB == null) {
            comparison = ascending ? -1 : 1;
          } else {
            int monthComparison = bdayA.month.compareTo(bdayB.month);
            if (monthComparison == 0) {
              comparison = bdayA.day.compareTo(bdayB.day);
            } else {
              comparison = monthComparison;
            }
          }
          break;
        case ContactListSortField.contactFrequency:
          ContactFrequency freqA = ContactFrequency.fromString(a.frequency);
          ContactFrequency freqB = ContactFrequency.fromString(b.frequency);

          int orderA = frequencyOrder[freqA] ?? 99;
          int orderB = frequencyOrder[freqB] ?? 99;

          comparison = orderA.compareTo(orderB);
          break;
      }
      return ascending ? comparison : -comparison;
    });
    return sortedList;
  }

  void _emitFilteredAndSortedState({
    required List<Contact> newOriginalContacts,
    required LoadedContactListState currentState, // Provides filter/sort params and base for copyWith
    required Emitter<ContactListState> emit,
  }) {
    final newlyFilteredContacts = _applyFilterAndSearch(
      newOriginalContacts,
      currentState.searchTerm,
      currentState.activeFilters,
    );

    final newlySortedContacts = _sortContacts(
      newlyFilteredContacts,
      currentState.sortField,
      currentState.ascending,
    );

    if (newlySortedContacts.isEmpty) {
      // If the final list to be displayed is empty (either due to no original contacts or filters)
      // logger.i is typically called by the event handler after this.
      emit(const EmptyContactListState());
    } else {
      // Use copyWith on the passed currentState to preserve its properties like searchTerm,
      // activeFilters, sortField, ascending, and then override originalContacts and displayedContacts.
      emit(currentState.copyWith(
        originalContacts: newOriginalContacts,
        displayedContacts: newlySortedContacts,
      ));
      // logger.i can be called by the specific event handler if needed, e.g. "Loaded X contacts"
    }
  }
}
