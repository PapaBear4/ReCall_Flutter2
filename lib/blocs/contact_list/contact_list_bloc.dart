// lib/blocs/contact_list/contact_list_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/models/contact_enums.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/utils/logger.dart';
import 'package:recall/services/notification_service.dart';
import 'package:recall/utils/last_contacted_utils.dart';
import 'package:recall/services/service_locator.dart';

import 'contact_list_event.dart';
import 'contact_list_state.dart';

/// BLoC that manages the state of the contact list screen.
///
/// Handles loading, filtering, sorting, and operations on contacts.
class ContactListBloc extends Bloc<ContactListEvent, ContactListState> {
  final ContactRepository _contactRepository;
  final NotificationService _notificationService;

  /// Creates a new ContactListBloc.
  ///
  /// Uses GetIt to resolve dependencies for [ContactRepository] and [NotificationService].
  ContactListBloc()
      : _contactRepository = getIt<ContactRepository>(),
        _notificationService = getIt<NotificationService>(),
        super(const Initial()) {
    on<LoadContacts>(_onLoadContacts);
    on<SortContacts>(_onSortContacts);
    on<ApplySearch>(_onApplySearch);
    on<DeleteContacts>(_onDeleteContacts);
    on<UpdateContacts>(_onUpdateContacts);
    on<AddSampleContacts>(_onAddSampleContacts);
    on<ClearAllData>(_onClearAllData);
    on<ToggleFilter>(_onToggleFilter);
    on<ClearFilters>(_onClearFilters);
  }
  // MARK: - LOAD
  /// Handles the LoadContacts event by fetching contacts from the repository.
  ///
  /// Maintains current sorting and filtering preferences if available.
  Future<void> _onLoadContacts(
      LoadContacts event, Emitter<ContactListState> emit) async {
    final currentState = state;
    List<Contact> originalContacts = [];
    ContactListSortField sortField = ContactListSortField.dueDate;
    bool ascending = true;
    String searchTerm = '';
    Set<ContactListFilter> appliedFilters = {ContactListFilter.active};

    if (currentState is Loaded) {
      sortField = currentState.sortField;
      ascending = currentState.ascending;
      searchTerm = currentState.searchTerm;
      appliedFilters = currentState.appliedFilters;
    }

    emit(const Loading());
    try {
      originalContacts = await _contactRepository.getAll();
      if (originalContacts.isEmpty) {
        emit(const Empty());
      } else {
        final filteredContacts =
            _applyFilterAndSearch(originalContacts, searchTerm, appliedFilters);
        final sortedContacts =
            _sortContacts(filteredContacts, sortField, ascending);
        emit(Loaded(
          originalContacts: originalContacts,
          displayedContacts: sortedContacts,
          sortField: sortField,
          ascending: ascending,
          searchTerm: searchTerm,
          appliedFilters: appliedFilters,
        ));
      }
    } catch (e) {
      logger.e('Error loading contacts: $e');
      emit(Error(e.toString()));
    }
  }

  // MARK: - FILTER TOG
  /// Handles toggling a filter on or off
  void _onToggleFilter(ToggleFilter event, Emitter<ContactListState> emit) {
    final currentState = state;
    if (currentState is Loaded) {
      Set<ContactListFilter> newFilters = Set<ContactListFilter>.from(currentState.appliedFilters);

      if (event.filter == ContactListFilter.active && event.enabled) {
        newFilters.remove(ContactListFilter.archived);
        newFilters.add(ContactListFilter.active);
      } else if (event.filter == ContactListFilter.archived && event.enabled) {
        newFilters.remove(ContactListFilter.active);
        newFilters.add(ContactListFilter.archived);
      } else if (event.enabled) {
        newFilters.add(event.filter);
      } else {
        newFilters.remove(event.filter);
      }

      if (!newFilters.contains(ContactListFilter.active) &&
          !newFilters.contains(ContactListFilter.archived)) {
        newFilters.add(ContactListFilter.active);
      }

      final filteredContacts = _applyFilterAndSearch(
        currentState.originalContacts,
        currentState.searchTerm,
        newFilters,
      );

      final sortedContacts = _sortContacts(
        filteredContacts,
        currentState.sortField,
        currentState.ascending,
      );

      emit(currentState.copyWith(
        displayedContacts: sortedContacts,
        appliedFilters: newFilters,
      ));
    }
  }

  // MARK: - FILTER CLR
  /// Handles the ClearFilters event by removing all filters except specified ones
  void _onClearFilters(ClearFilters event, Emitter<ContactListState> emit) {
    final currentState = state;
    if (currentState is Loaded) {
      Set<ContactListFilter> newFilters = Set<ContactListFilter>.from(event.filtersToKeep);

      if (newFilters.isEmpty) {
        newFilters.add(ContactListFilter.active);
      }

      final filteredContacts = _applyFilterAndSearch(
        currentState.originalContacts,
        currentState.searchTerm,
        newFilters,
      );

      final sortedContacts = _sortContacts(
        filteredContacts,
        currentState.sortField,
        currentState.ascending,
      );

      emit(currentState.copyWith(
        displayedContacts: sortedContacts,
        appliedFilters: newFilters,
      ));
    }
  }

  // MARK: - SORT
  /// Handles the SortContacts event by resorting the displayed contacts.
  void _onSortContacts(SortContacts event, Emitter<ContactListState> emit) {
    final currentState = state;
    if (currentState is Loaded) {
      final sortedContacts = _sortContacts(
          currentState.displayedContacts, event.sortField, event.ascending);
      emit(currentState.copyWith(
        displayedContacts: sortedContacts,
        sortField: event.sortField,
        ascending: event.ascending,
      ));
    }
  }

  // MARK: - SEARCH
  /// Handles the ApplySearch event by filtering contacts based on a search term.
  void _onApplySearch(ApplySearch event, Emitter<ContactListState> emit) {
    final currentState = state;
    if (currentState is Loaded) {
      final filteredContacts = _applyFilterAndSearch(
          currentState.originalContacts,
          event.searchTerm,
          currentState.appliedFilters);
      final sortedContacts = _sortContacts(
          filteredContacts, currentState.sortField, currentState.ascending);
      emit(currentState.copyWith(
        displayedContacts: sortedContacts,
        searchTerm: event.searchTerm,
      ));
    }
  }

  // MARK: - DELETE
  /// Handles the DeleteContacts event by removing one or more contacts.
  Future<void> _onDeleteContacts(
      DeleteContacts event, Emitter<ContactListState> emit) async {
    final currentState = state;
    if (currentState is Loaded) {
      emit(const Loading());
      try {
        List<int> deletedIds = [];
        bool anyFailed = false;

        for (final id in event.contactIds) {
          try {
            await _contactRepository.delete(id);
            deletedIds.add(id);
          } catch (e) {
            logger.w('Failed to delete contact with id $id: $e');
            anyFailed = true;
          }
        }

        if (deletedIds.isNotEmpty) {
          final updatedContacts = currentState.originalContacts
              .where((c) => !deletedIds.contains(c.id))
              .toList();

          if (updatedContacts.isEmpty) {
            emit(const Empty());
          } else {
            final filteredContacts = _applyFilterAndSearch(updatedContacts,
                currentState.searchTerm, currentState.appliedFilters);
            final sortedContacts = _sortContacts(filteredContacts,
                currentState.sortField, currentState.ascending);
            emit(currentState.copyWith(
              originalContacts: updatedContacts,
              displayedContacts: sortedContacts,
            ));
          }
        } else {
          emit(currentState);
        }

        if (anyFailed) {
          logger.w('Some contacts could not be deleted');
        }
      } catch (e) {
        logger.e('Error deleting contacts: $e');
        emit(Error(e.toString()));
        emit(currentState);
      }
    }
  }

  // MARK: - UPDATE
  /// Handles the UpdateContacts event by updating contacts or marking them as contacted.
  Future<void> _onUpdateContacts(
      UpdateContacts event, Emitter<ContactListState> emit) async {
    // Get the current state, return if it's not Loaded
    final currentState = state;
    if (currentState is! Loaded) return;

    // Emit Loading state to indicate processing
    emit(const Loading());

    try {
      // Get the current time for 'lastContacted' updates
      final now = DateTime.now();
      // List to hold successfully updated contacts
      List<Contact> updatedContacts = [];

      // Scenario 1: Full contact objects are provided for update
      if (event.contacts != null) {
        // Iterate through each contact provided in the event
        for (final contact in event.contacts!) {
          try {
            // Update the contact in the repository
            final updatedContact = await _contactRepository.update(contact);
            // Add the successfully updated contact to our list
            updatedContacts.add(updatedContact);

            // Reschedule notifications for the updated contact
            await _notificationService.scheduleReminder(updatedContact);
          } catch (e) {
            // Log error if a specific contact update fails, but continue with others
            logger.e('Error updating contact: $e');
          }
        }
      
      // Scenario 2: Contact IDs are provided to mark them as contacted
      } else if (event.contactIds != null && event.markAsContacted == true) { // Explicitly check for true
        // Iterate through each contact ID provided
        for (final id in event.contactIds!) {
          try {
            // Find the original contact in the current state's list
            // Throws if not found, caught by the outer catch block
            final contact = currentState.originalContacts.firstWhere(
                (c) => c.id == id,
                // Provide a more specific error message if contact not found in state
                orElse: () => throw Exception('Contact with ID $id not found in current state'));
            // Create an updated contact with the 'lastContacted' field set to now
            final updatedContact = contact.copyWith(lastContacted: now);
            // Update the contact in the repository
            final savedContact =
                await _contactRepository.update(updatedContact);
            // Add the successfully updated contact to our list
            updatedContacts.add(savedContact);

            // Reschedule notifications for the updated contact
            await _notificationService.scheduleReminder(savedContact);
          } catch (e) {
            // Log error if marking a specific contact fails, but continue
            logger.e('Error marking contact $id as contacted: $e');
          }
        }
      }
      
      // Scenario 3: Contact IDs are provided to toggle archive status
      else if (event.contactIds != null && event.setArchived != null) {
        // Iterate through each contact ID provided
        for (final id in event.contactIds!) {
          try {
            // Find the original contact in the current state's list
            final contact = currentState.originalContacts.firstWhere(
                (c) => c.id == id,
                orElse: () => throw Exception('Contact with ID $id not found in current state'));
            // Create an updated contact with the 'isActive' field toggled
            final updatedContact = contact.copyWith(
                isActive: !event.setArchived!); // Toggle archived status
            // Update the contact in the repository
            final savedContact =
                await _contactRepository.update(updatedContact);
            // Add the successfully updated contact to our list
            updatedContacts.add(savedContact);

            // Reschedule notifications for the updated contact
            await _notificationService.scheduleReminder(savedContact);
          } catch (e) {
            // Log error if toggling archive status fails, but continue
            logger.e('Error updating archive status for contact $id: $e');
          }
        }
      }
      // Add other scenarios like setArchived here if needed in the future

      // If any contacts were successfully updated
      if (updatedContacts.isNotEmpty) {
        // Create a mutable copy of the original contacts list from the state
        final newOriginalContacts =
            List<Contact>.from(currentState.originalContacts);
        // Replace the old contact objects with the updated ones in the list
        for (var updatedContact in updatedContacts) {
          final index =
              newOriginalContacts.indexWhere((c) => c.id == updatedContact.id);
          // Ensure the contact still exists in the list before replacing
          if (index >= 0) {
            newOriginalContacts[index] = updatedContact;
          }
        }

        // Re-apply the current filters and search term to the updated list
        final filteredContacts = _applyFilterAndSearch(newOriginalContacts,
            currentState.searchTerm, currentState.appliedFilters);
        // Re-apply the current sorting to the filtered list
        final sortedContacts = _sortContacts(
            filteredContacts, currentState.sortField, currentState.ascending);

        // Emit the new Loaded state with updated original and displayed lists
        emit(currentState.copyWith(
          originalContacts: newOriginalContacts,
          displayedContacts: sortedContacts,
        ));
      } else {
        // If no contacts were updated (e.g., all updates failed),
        // re-emit the previous state to avoid staying in Loading state.
        emit(currentState);
      }
    } catch (e) {
      // Catch any unexpected errors during the process
      logger.e('Error updating contacts: $e');
      // Emit an Error state
      emit(Error(e.toString()));
      // IMPORTANT: Re-emit the original state after an error to allow the UI
      // to recover and potentially show the error message without losing data.
      emit(currentState);
    }
  }

  // MARK: - ADD SAMPLE
  /// Handles the AddSampleContacts event by adding sample contacts.
  Future<void> _onAddSampleContacts(
      AddSampleContacts event, Emitter<ContactListState> emit) async {
    emit(const Loading());
    try {
      // Use the repository method instead of calling debug utils directly
      final contacts = await _contactRepository.addSampleAppContacts(
        count: event.count, // Add count parameter to event
      );
      
      emit(Loaded(
        originalContacts: contacts,
        displayedContacts: contacts,
        sortField: ContactListSortField.dueDate,
        ascending: true,
        searchTerm: '',
        appliedFilters: {ContactListFilter.active},
      ));
    } catch (e) {
      logger.e('Error adding sample contacts: $e');
      emit(Error(e.toString()));
    }
  }
  // MARK: - CLEAR ALL
  /// Handles the ClearAllData event by clearing all data.
  Future<void> _onClearAllData(
      ClearAllData event, Emitter<ContactListState> emit) async {
    emit(const Loading());
    try {
      await _contactRepository.deleteAll();
      emit(const Empty());
    } catch (e) {
      logger.e('Error clearing data: $e');
      emit(Error(e.toString()));
    }
  }

  // MARK: - HELP MTHDS

  /// Checks if the active contact limit has been reached
  Future<bool> isActiveContactLimitReached() async {
    return _contactRepository.isActiveContactLimitReached();
  }
  
  /// Gets the number of remaining active contact slots
  Future<int> getRemainingActiveContactSlots() async {
    return _contactRepository.getRemainingActiveContactSlots();
  }
  
  /// Gets the active contact count stream for UI updates
  Stream<int> getActiveContactCountStream() {
    return _contactRepository.getActiveContactCountStream();
  }
  
  /// Gets the maximum number of allowed active contacts
  int get maxActiveContacts => ContactRepository.maxActiveContacts;

  // MARK: - FLTR/SRCH
  /// Applies both search term and multiple filters to a list of contacts.
  List<Contact> _applyFilterAndSearch(
      List<Contact> originalContacts,
      String searchTerm,
      Set<ContactListFilter> filters) {
    List<Contact> filteredList = List.from(originalContacts);

    // First apply active/archived filter (these are mutually exclusive)
    if (filters.contains(ContactListFilter.active)) {
      filteredList = filteredList.where((c) => c.isActive).toList();
    } else if (filters.contains(ContactListFilter.archived)) {
      filteredList = filteredList.where((c) => !c.isActive).toList();
    }

    // Then apply search term if provided
    if (searchTerm.isNotEmpty) {
      final lowerCaseSearchTerm = searchTerm.toLowerCase();
      filteredList = filteredList.where((contact) {
        final nicknameMatch = contact.nickname != null &&
            contact.nickname!.toLowerCase().contains(lowerCaseSearchTerm);

        return contact.firstName.toLowerCase().contains(lowerCaseSearchTerm) ||
            contact.lastName.toLowerCase().contains(lowerCaseSearchTerm) ||
            nicknameMatch;
      }).toList();
    }

    // Apply functional filters
    bool hasOverdueFilter = filters.contains(ContactListFilter.overdue);
    bool hasDueSoonFilter = filters.contains(ContactListFilter.dueSoon);
    
    // Only apply additional filters if they exist
    if (hasOverdueFilter || hasDueSoonFilter) {
      // Create a temporary list to store contacts matching ANY of the filters
      List<Contact> tempList = [];
      
      // Add contacts matching overdue filter
      if (hasOverdueFilter) {
        tempList.addAll(
          filteredList.where((c) => isOverdue(c.frequency, c.lastContacted))
        );
      }
      
      // Add contacts matching due soon filter
      if (hasDueSoonFilter) {
        tempList.addAll(
          filteredList.where((c) {
            if (c.frequency == ContactFrequency.never.value) {
              return false;
            }
            final dueDateDisplay = calculateNextDueDateDisplay(c.lastContacted, c.frequency);
            return dueDateDisplay == 'Today' || dueDateDisplay == 'Tomorrow';
          })
        );
      }
      
      // Remove duplicates (in case a contact matches multiple filters)
      final contactIds = tempList.map((c) => c.id).toSet();
      filteredList = tempList.where((c) => contactIds.remove(c.id)).toList();
    }

    return filteredList;
  }

  // MARK: - SORT
  /// Sorts a list of contacts by the specified field and direction.
  List<Contact> _sortContacts(List<Contact> contactsToSort,
      ContactListSortField sortField, bool ascending) {
    List<Contact> sortedList = List.from(contactsToSort);

    sortedList.sort((a, b) {
      int comparison;
      switch (sortField) {
        case ContactListSortField.dueDate:
          DateTime dueA = calculateNextContact(a);
          DateTime dueB = calculateNextContact(b);
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

        case ContactListSortField.nextContact:
          final aDate = a.nextContact;
          final bDate = b.nextContact;

          if (aDate == null && bDate == null) {
            comparison = 0;
          } else if (aDate == null) {
            comparison = 1;
          } else if (bDate == null) {
            comparison = -1;
          } else {
            comparison = aDate.compareTo(bDate);
          }
          break;

        case ContactListSortField.lastName:
          comparison = a.lastName.compareTo(b.lastName);
          if (comparison == 0) {
            comparison = a.firstName.compareTo(b.firstName);
          }
          break;

        case ContactListSortField.lastContacted:
          final aDate = a.lastContacted;
          final bDate = b.lastContacted;

          if (aDate == null && bDate == null) {
            comparison = 0;
          } else if (aDate == null) {
            comparison = 1;
          } else if (bDate == null) {
            comparison = -1;
          } else {
            comparison = aDate.compareTo(bDate);
          }
          break;

        default:
          comparison = 0;
          break;
      }
      return ascending ? comparison : -comparison;
    });
    return sortedList;
  }
}
