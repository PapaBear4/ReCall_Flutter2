// lib/blocs/contact_list/contact_list_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/models/contact_frequency.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/utils/logger.dart'; // Adjust path if needed
import 'package:recall/services/notification_service.dart';
import 'package:recall/utils/last_contacted_utils.dart';

part 'contact_list_event.dart';
part 'contact_list_state.dart';

class ContactListBloc extends Bloc<ContactListEvent, ContactListState> {
  final ContactRepository _contactRepository;
  final NotificationService _notificationService;

  ContactListBloc({
    required ContactRepository contactRepository,
    required NotificationService notificationService,
  })  : _contactRepository = contactRepository,
        _notificationService = notificationService,
        super(const InitialContactListState()) {
    // BEGIN EVENT HANDLING
    on<ContactListEvent>((event, emit) async {
      // LOAD CONTACTS (FOR ALL CONTACTS SCREEN)
      if (event is LoadContactsEvent) {
        emit(const LoadingContactListState());
        try {
          final allContacts = await _contactRepository.getAll();
          final activeContacts = allContacts.where((c) => c.isActive).toList();

          if (activeContacts.isEmpty) {
            emit(const EmptyContactListState());
          } else {
            final sortedContacts = _sortContacts(
                List.from(activeContacts), ContactListSortField.dueDate, true);
            emit(LoadedContactListState(
              originalContacts: activeContacts,
              displayedContacts: sortedContacts,
              sortField: ContactListSortField.dueDate,
              ascending: true,
              searchTerm: '',
              activeFilters: {}, // No default filters for "All Contacts" view
            ));
          }
        } catch (e) {
          emit(ErrorContactListState(e.toString()));
          logger.e("Error loading contacts: $e");
        }
      // LOAD HOME SCREEN CONTACTS
      } else if (event is LoadHomeScreenContactsEvent) {
        emit(const LoadingContactListState());
        try {
          final allContacts = await _contactRepository.getAll();
          final activeContacts = allContacts.where((c) => c.isActive).toList();

          if (activeContacts.isEmpty) {
            // If no active contacts, home screen will also be empty.
            emit(const EmptyContactListState());
          } else {
            final Set<ContactListFilterType> homeScreenFilters = {
              ContactListFilterType.overdue,
              ContactListFilterType.dueSoon,
            };
            final homeScreenContacts = _applyFilterAndSearch(
                List.from(activeContacts), '', homeScreenFilters);

            final sortedHomeScreenContacts = _sortContacts(
                homeScreenContacts, ContactListSortField.dueDate, true);

            emit(LoadedContactListState(
              originalContacts: activeContacts, // Base list is all active contacts
              displayedContacts: sortedHomeScreenContacts, // Specifically filtered for home
              sortField: ContactListSortField.dueDate,
              ascending: true,
              searchTerm: '',
              activeFilters: homeScreenFilters, // Pre-apply home screen filters
            ));
          }
        } catch (e) {
          emit(ErrorContactListState(e.toString()));
          logger.e("Error loading home screen contacts: $e");
        }
      // DELETE CONTACT FROM LIST
      } else if (event is DeleteContactFromListEvent) {
        // TODO: Maybe for later to provide a way to delete contacts
        // directly from the list
      // UPDATE CONTACT FROM LIST
      } else if (event is UpdateContactFromListEvent) {
        final currentState = state;
        if (currentState is! LoadedContactListState) {
          logger.w("Attempted to update contact from non-loaded state.");
          return;
        }

        emit(const LoadingContactListState());
        try {
          final updatedContact = await _contactRepository.update(event.contact);
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
          logger.i("Successfully updated contact ${updatedContact.id} in list state.");
        } catch (err) {
          emit(ErrorContactListState(err.toString()));
          logger.e("Error updating contact ID ${event.contact.id} from list: $err");
        }
      // SORT CONTACTS
      } else if (event is SortContactsEvent) {
        final currentState = state;
        if (currentState is LoadedContactListState) {
          final sortedContacts = _sortContacts(
              currentState.displayedContacts,
              event.sortField,
              event.ascending);
          emit(currentState.copyWith(
            displayedContacts: sortedContacts,
            sortField: event.sortField,
            ascending: event.ascending,
          ));
        }
      // SEARCH CONTACTS
      } else if (event is ApplySearchEvent) {
        final currentState = state;
        if (currentState is LoadedContactListState) {
          final filteredContacts = _applyFilterAndSearch(
              currentState.originalContacts,
              event.searchTerm,
              currentState.activeFilters);

          final sortedContacts = _sortContacts(filteredContacts,
              currentState.sortField, currentState.ascending);

          emit(currentState.copyWith(
            displayedContacts: sortedContacts,
            searchTerm: event.searchTerm,
          ));
        }
      // APPLY FILTERS
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
              filteredContacts,
              currentState.sortField,
              currentState.ascending);

          emit(currentState.copyWith(
            displayedContacts: sortedContacts,
            activeFilters: updatedFilters,
          ));
        }
      // CLEAR ALL FILTERS
      } else if (event is ClearFiltersEvent) {
        final currentState = state;
        if (currentState is LoadedContactListState) {
          final filteredContacts = _applyFilterAndSearch(
              currentState.originalContacts,
              currentState.searchTerm,
              {});

          final sortedContacts = _sortContacts(
              filteredContacts,
              currentState.sortField,
              currentState.ascending);

          emit(currentState.copyWith(
            displayedContacts: sortedContacts,
            activeFilters: {},
          ));
        }
      // DELETE MULTIPLE CONTACTS
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
      }
    });
  }

  List<Contact> _applyFilterAndSearch(
      List<Contact> originalContacts, // This list is already pre-filtered for active contacts
      String searchTerm,
      Set<ContactListFilterType> activeFilters) {
    List<Contact> filteredList = List.from(originalContacts);

    if (searchTerm.isNotEmpty) {
      final lowerCaseSearchTerm = searchTerm.toLowerCase();
      filteredList = filteredList.where((contact) {
        return contact.firstName.toLowerCase().contains(lowerCaseSearchTerm) ||
            contact.lastName.toLowerCase().contains(lowerCaseSearchTerm);
      }).toList();
    }

    if (activeFilters.isEmpty) {
      return filteredList;
    }

    return filteredList.where((contact) {
      bool matchesFilter = false;

      for (final filter in activeFilters) {
        switch (filter) {
          case ContactListFilterType.overdue:
            if (isOverdue(contact.frequency, contact.lastContacted)) {
              matchesFilter = true;
            }
            break;
          case ContactListFilterType.dueSoon:
            if (contact.frequency != ContactFrequency.never.value) {
              final dueDateDisplay = calculateNextDueDateDisplay(
                  contact.lastContacted, contact.frequency);
              if (dueDateDisplay == 'Today' || dueDateDisplay == 'Tomorrow') {
                matchesFilter = true;
              }
            }
            break;
        }

        if (matchesFilter) break;
      }

      return matchesFilter;
    }).toList();
  }

  List<Contact> _sortContacts(List<Contact> contactsToSort,
      ContactListSortField sortField, bool ascending) {
    const Map<ContactFrequency, int> frequencyOrder = {
      ContactFrequency.daily: 1,
      ContactFrequency.weekly: 2,
      ContactFrequency.biweekly: 3,
      ContactFrequency.monthly: 4,
      ContactFrequency.quarterly: 5,
      ContactFrequency.yearly: 6,
      ContactFrequency.rarely: 7,
      ContactFrequency.never: 8,
    };

    List<Contact> sortedList = List.from(contactsToSort);

    sortedList.sort((a, b) {
      int comparison;
      switch (sortField) {
        case ContactListSortField.dueDate:
          DateTime dueA = calculateNextDueDate(a);
          DateTime dueB = calculateNextDueDate(b);
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
        case ContactListSortField.lastContacted:
          DateTime lastA =
              a.lastContacted ?? (ascending ? DateTime(9999) : DateTime(1900));
          DateTime lastB =
              b.lastContacted ?? (ascending ? DateTime(9999) : DateTime(1900));
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
