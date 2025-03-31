// lib/blocs/contact_list/contact_list_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/models/contact_frequency.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:logger/logger.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:recall/services/notification_helper.dart';
import 'package:recall/services/notification_service.dart';
import 'package:recall/utils/last_contacted_utils.dart';

part 'contact_list_event.dart';
part 'contact_list_state.dart';
part 'contact_list_bloc.freezed.dart';

var contactListLogger = Logger();

class ContactListBloc extends Bloc<ContactListEvent, ContactListState> {
  final ContactRepository _contactRepository;
  final NotificationService _notificationService;

  ContactListBloc({
    required ContactRepository contactRepository,
    required NotificationService notificationService,
  })  : _contactRepository = contactRepository,
        _notificationService = notificationService,
        super(const ContactListState.initial()) {
    // BEGIN EVENT HANDLING
    on<ContactListEvent>((event, emit) async {
      // LOAD CONTACTS
      await event.map(loadContacts: (e) async {
        emit(const ContactListState.loading());
        try {
          final allContacts = await _contactRepository.getAll();
          if (allContacts.isEmpty) {
            emit(const ContactListState.empty());
          } else {
            // Sort contacts by due date by default when loading
            final sortedContacts = _sortContacts(
                List.from(allContacts), ContactListSortField.dueDate, true);
            emit(ContactListState.loaded(
              originalContacts: allContacts,
              displayedContacts: sortedContacts,
              sortField:
                  ContactListSortField.dueDate, // Explicitly set default sort
              ascending: true,
              searchTerm: '',
              currentFilter: ContactListFilter.none,
            ));
          }
        } catch (e) {
          emit(ContactListState.error(e.toString()));
          contactListLogger.e("Error loading contacts: $e");
        }

        // DELETE CONTACT FROM LIST
      }, deleteContactFromList: (e) async {
        //TODO: Maybe for later to provide a way to delete contacts
        //directly from the list

        // UPDATE CONTACT FROM LIST
      }, updateContactFromList: (e) async {
        // Get current state details before updating
        final currentState = state;
        if (currentState is! _Loaded) {
          return;
        } // Can only update from loaded state

        emit(
            const ContactListState.loading()); // Indicate loading during update
        try {
          // Update in repository
          final updatedContact = await _contactRepository.update(e.contact);
          // Reschedule notification
          await _notificationService.scheduleReminder(updatedContact);
          notificationLogger
              .i('LOG: Updated contact and rescheduled notification.');

          // Get the full updated list
          // In a real app, ideally the repo update would return the updated list
          // or we'd update the single item in the existing list to avoid a full fetch.
          // For simplicity here, we refetch.
          final allContacts = await _contactRepository.getAll();

          // Re-apply filter, search, and sort using previous state values
          final newDisplayedContacts = _applyFilterAndSearch(
              allContacts, currentState.searchTerm, currentState.currentFilter);
          final newSortedContacts = _sortContacts(newDisplayedContacts,
              currentState.sortField, currentState.ascending);

          emit(currentState.copyWith(
              // Use copyWith on the previous loaded state
              originalContacts: allContacts,
              displayedContacts: newSortedContacts
              // Keep sortField, ascending, searchTerm, currentFilter from previous state
              ));
        } catch (e) {
          emit(ContactListState.error(e.toString()));
          contactListLogger.e("Error updating contact from list: $e");
          // Optionally, emit the previous state back on error: emit(currentState);
        }

        // SORT CONTACTS
      }, sortContacts: (e) async {
        final currentState = state;
        if (currentState is _Loaded) {
          final sortedContacts = _sortContacts(
              currentState
                  .displayedContacts, // Sort the ALREADY filtered/searched list
              e.sortField,
              e.ascending);
          emit(currentState.copyWith(
            // Use copyWith to update only relevant fields
            displayedContacts: sortedContacts,
            sortField: e.sortField,
            ascending: e.ascending,
          ));
        }

        // APPLY SEARCH
      }, applySearch: (e) async {
        final currentState = state;
        if (currentState is _Loaded) {
          final filteredContacts = _applyFilterAndSearch(
              currentState.originalContacts,
              e.searchTerm, // Use new search term
              currentState.currentFilter); // Keep current filter

          final sortedContacts = _sortContacts(
              filteredContacts, currentState.sortField, currentState.ascending);

          emit(currentState.copyWith(
            displayedContacts: sortedContacts,
            searchTerm: e.searchTerm, // Update search term in state
          ));
        }
        // APPLY FILTER
      }, applyFilter: (e) async {
        final currentState = state;
        if (currentState is _Loaded) {
          final filteredContacts = _applyFilterAndSearch(
              currentState.originalContacts,
              currentState.searchTerm, // Keep current search term
              e.filter); // Use new filter

          final sortedContacts = _sortContacts(
              filteredContacts, currentState.sortField, currentState.ascending);

          emit(currentState.copyWith(
            displayedContacts: sortedContacts,
            currentFilter: e.filter, // Update filter in state
          ));
        }
      }
          //other event handlers if needed
          );
    });
  }

//HELPER FUNCTIONS
  List<Contact> _applyFilterAndSearch(List<Contact> originalContacts,
      String searchTerm, ContactListFilter filter) {
    List<Contact> filteredList = List.from(originalContacts);

    // Apply Search Filter
    if (searchTerm.isNotEmpty) {
      final lowerCaseSearchTerm = searchTerm.toLowerCase();
      filteredList = filteredList.where((contact) {
        return contact.firstName.toLowerCase().contains(lowerCaseSearchTerm) ||
            contact.lastName.toLowerCase().contains(lowerCaseSearchTerm);
      }).toList();
    }

    // Apply Type Filter
    switch (filter) {
      case ContactListFilter.overdue:
        filteredList = filteredList
            .where((c) => isOverdue(c.frequency, c.lastContacted))
            .toList();
        break;
      case ContactListFilter.dueSoon:
        // Define "due soon" (e.g., Today or Tomorrow)
        filteredList = filteredList.where((c) {
          if (c.frequency == ContactFrequency.never.value) {
            return false; // Skip 'never'
          }
          final dueDateDisplay =
              calculateNextDueDateDisplay(c.lastContacted, c.frequency);
          return dueDateDisplay == 'Today' || dueDateDisplay == 'Tomorrow';
        }).toList();
        break;
      case ContactListFilter.none:
        // No additional filtering needed
        break;
    }

    return filteredList;
  }

// Helper function for sorting
  List<Contact> _sortContacts(List<Contact> contactsToSort,
      ContactListSortField sortField, bool ascending) {
    // Define the logical order for frequencies - Ensure keys match the enum values
    const Map<ContactFrequency, int> frequencyOrder = {
      ContactFrequency.daily: 1,
      ContactFrequency.weekly: 2,
      ContactFrequency.biweekly: 3,
      ContactFrequency.monthly: 4,
      ContactFrequency.quarterly: 5,
      ContactFrequency.yearly: 6,
      ContactFrequency.rarely: 7,
      ContactFrequency.never: 8, // 'never' comes last
    };

    List<Contact> sortedList =
        List.from(contactsToSort); // Create a modifiable copy

    sortedList.sort((a, b) {
      int comparison;
      switch (sortField) {
        case ContactListSortField.dueDate:
          DateTime dueA = calculateNextDueDate(a);
          DateTime dueB = calculateNextDueDate(b);
          // Handle 'never' frequency - push them to the end regardless of sort order
          bool aIsNever = a.frequency == ContactFrequency.never.value;
          bool bIsNever = b.frequency == ContactFrequency.never.value;
          if (aIsNever && bIsNever) {
            comparison = 0;
          } else if (aIsNever) {
            comparison = 1;
          } // a goes after b
          else if (bIsNever) {
            comparison = -1;
          } // b goes after a
          else {
            comparison = dueA.compareTo(dueB);
          } // Normal comparison
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
          // Handle nulls: Never contacted go last when ascending.
          DateTime now = DateTime.now();
          // Treat null as very far in the past for descending, future for ascending
          DateTime lastA =
              a.lastContacted ?? (ascending ? DateTime(9999) : DateTime(1900));
          DateTime lastB =
              b.lastContacted ?? (ascending ? DateTime(9999) : DateTime(1900));
          comparison = lastA.compareTo(lastB);
          break;
        case ContactListSortField.birthday:
          // Handle nulls: No birthday goes last when ascending.
          DateTime? bdayA = a.birthday;
          DateTime? bdayB = b.birthday;
          if (bdayA == null && bdayB == null) {
            comparison = 0; // Both null, treat as equal
          } else if (bdayA == null) {
            comparison = ascending ? 1 : -1; // a (null) goes after b
          } else if (bdayB == null) {
            comparison = ascending ? -1 : 1; // b (null) goes after a
          } else {
            // Compare month and day, ignore year for typical birthday sorting
            int monthComparison = bdayA.month.compareTo(bdayB.month);
            if (monthComparison == 0) {
              comparison = bdayA.day.compareTo(bdayB.day);
            } else {
              comparison = monthComparison;
            }
          }
          break;
        case ContactListSortField.contactFrequency:
          // Get the enum value from the string
          ContactFrequency freqA = ContactFrequency.fromString(a.frequency);
          ContactFrequency freqB = ContactFrequency.fromString(b.frequency);

          // Look up the order using the enum value as the key
          // Provide a default comparison value (e.g., 99) if somehow the enum isn't in the map
          int orderA = frequencyOrder[freqA] ?? 99;
          int orderB = frequencyOrder[freqB] ?? 99;

          comparison = orderA.compareTo(orderB);
          break;
      }
      // Apply ascending/descending ONLY if comparison is not 0
      // Or simply return based on 'ascending' flag
      return ascending ? comparison : -comparison;
    });
    return sortedList;
  }
}
