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

          // Apply filters
          final filteredContacts = _applyFilterAndSearch(
            allContacts,
            event.searchTerm,
            event.filters,
          );

          // Sort the filtered contacts
          final sortedContacts = _sortContacts(
            filteredContacts,
            event.sortField,
            event.ascending,
          );

          if (sortedContacts.isEmpty) {
            logger.i('No contacts found after applying filters and sorting.');
            emit(const EmptyContactListState());
          } else {
            logger.i('Loaded ${sortedContacts.length} contacts.');
            emit(LoadedContactListState(
              originalContacts: allContacts,
              displayedContacts: sortedContacts,
              sortField: event.sortField,
              ascending: event.ascending,
              searchTerm: event.searchTerm,
              activeFilters: event.filters,
            ));
          }
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
            'UpdateContactFromListEvent: Received contact: ${event.contact}'); // Added logger
        emit(const LoadingContactListState());
        try {
          final updatedContact = await _contactRepository.update(event.contact);
          logger.i(
              'UpdateContactFromListEvent: Updated contact in repository: $updatedContact'); // Added logger
          await _notificationService.scheduleReminder(updatedContact);

          final newOriginalContacts = currentState.originalContacts.map((c) {
            return c.id == updatedContact.id ? updatedContact : c;
          }).toList();

          final newlyFilteredContacts = _applyFilterAndSearch(
              newOriginalContacts,
              currentState.searchTerm,
              currentState.activeFilters);

          final newlySortedContacts = _sortContacts(newlyFilteredContacts,
              currentState.sortField, currentState.ascending);

          emit(currentState.copyWith(
            originalContacts: newOriginalContacts,
            displayedContacts: newlySortedContacts,
          ));
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

          if (newOriginalContacts.isEmpty) {
            emit(const EmptyContactListState());
          } else {
            final newlyFilteredContacts = _applyFilterAndSearch(
                newOriginalContacts,
                currentState.searchTerm,
                currentState.activeFilters);

            final newlySortedContacts = _sortContacts(newlyFilteredContacts,
                currentState.sortField, currentState.ascending);

            emit(currentState.copyWith(
              originalContacts: newOriginalContacts,
              displayedContacts: newlySortedContacts,
            ));
            logger.i(
                "Successfully removed ${event.contactIds.length} contacts from list state.");
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

          // Determine which load event to re-trigger to refresh the list correctly
          // If current state has home screen filters, reload home screen, else reload all contacts.
          // This ensures originalContacts is correctly populated (all active for home, all for all contacts).
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

          if (newBaseContacts.isEmpty && isHomeScreenView) {
            emit(const EmptyContactListState());
          } else if (newBaseContacts.isEmpty && !isHomeScreenView) {
            emit(const EmptyContactListState());
          } else {
            final newlyFilteredContacts = _applyFilterAndSearch(newBaseContacts,
                currentState.searchTerm, currentState.activeFilters);

            final newlySortedContacts = _sortContacts(newlyFilteredContacts,
                currentState.sortField, currentState.ascending);

            emit(currentState.copyWith(
              originalContacts: newBaseContacts,
              displayedContacts: newlySortedContacts,
            ));
          }
        } catch (err) {
          emit(ErrorContactListState(err.toString()));
          logger.e(
              "Error toggling active status for contacts ${event.contactIds}: $err");
          emit(currentState);
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
          List<Contact> updatedContacts = [];
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
              updatedContacts.add(updatedContact);
            }
          }

          final newOriginalContacts = currentState.originalContacts.map((c) {
            final updatedVersion = updatedContacts
                .firstWhere((uc) => uc.id == c.id, orElse: () => c);
            return updatedVersion;
          }).toList();

          final newlyFilteredContacts = _applyFilterAndSearch(
              newOriginalContacts,
              currentState.searchTerm,
              currentState.activeFilters);

          final newlySortedContacts = _sortContacts(newlyFilteredContacts,
              currentState.sortField, currentState.ascending);

          emit(currentState.copyWith(
            originalContacts: newOriginalContacts,
            displayedContacts: newlySortedContacts,
          ));
          logger.i(
              "Successfully marked ${event.contactIds.length} contacts as contacted.");
        } catch (err) {
          emit(ErrorContactListState(err.toString()));
          logger.e("Error marking contacts as contacted: $err");
        }
      } else if (event is _ContactsUpdatedEvent) {
        // This event is triggered by the stream subscription
        final currentState = state;
        if (currentState is LoadedContactListState) {
          final filteredContacts = _applyFilterAndSearch(event.contacts,
              currentState.searchTerm, currentState.activeFilters);

          final sortedContacts = _sortContacts(
              filteredContacts, currentState.sortField, currentState.ascending);

          emit(currentState.copyWith(
            originalContacts: event.contacts,
            displayedContacts: sortedContacts,
          ));
        } else if (event.contacts.isEmpty) {
          emit(const EmptyContactListState());
        } else {
          emit(LoadedContactListState(
            originalContacts: event.contacts,
            displayedContacts: event.contacts,
          ));
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
}
