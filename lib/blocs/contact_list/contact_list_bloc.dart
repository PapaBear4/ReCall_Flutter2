// lib/blocs/contact_list/contact_list_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/models/contact_enums.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/utils/logger.dart';
import 'package:recall/services/notification_service.dart';
import 'package:recall/utils/last_contacted_utils.dart';

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
  /// Requires a [contactRepository] for data access and a
  /// [notificationService] for scheduling reminders.
  ContactListBloc({
    required ContactRepository contactRepository,
    required NotificationService notificationService,
  })  : _contactRepository = contactRepository,
        _notificationService = notificationService,
        super(const Initial()) {
    on<LoadContacts>(_onLoadContacts);
    on<SortContacts>(_onSortContacts);
    on<ApplySearch>(_onApplySearch);
    on<ApplyFilter>(_onApplyFilter);
    on<DeleteContacts>(_onDeleteContacts);
    on<UpdateContacts>(_onUpdateContacts);
    on<AddSampleContacts>(_onAddSampleContacts);
    on<ClearAllData>(_onClearAllData);
  }

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
    ContactListFilter currentFilter = ContactListFilter.none;

    if (currentState is Loaded) {
      sortField = currentState.sortField;
      ascending = currentState.ascending;
      searchTerm = currentState.searchTerm;
      currentFilter = currentState.currentFilter;
    }

    emit(const Loading());
    try {
      originalContacts = await _contactRepository.getAll();
      if (originalContacts.isEmpty) {
        emit(const Empty());
      } else {
        final filteredContacts =
            _applyFilterAndSearch(originalContacts, searchTerm, currentFilter);
        final sortedContacts =
            _sortContacts(filteredContacts, sortField, ascending);
        emit(Loaded(
          originalContacts: originalContacts,
          displayedContacts: sortedContacts,
          sortField: sortField,
          ascending: ascending,
          searchTerm: searchTerm,
          currentFilter: currentFilter,
        ));
      }
    } catch (e) {
      logger.e('Error loading contacts: $e');
      emit(Error(e.toString()));
    }
  }

  /// Handles the SortContacts event by resorting the displayed contacts.
  ///
  /// Does not fetch new data from the repository.
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

  /// Handles the ApplySearch event by filtering contacts based on a search term.
  ///
  /// Applies the search to the original contact list.
  void _onApplySearch(ApplySearch event, Emitter<ContactListState> emit) {
    final currentState = state;
    if (currentState is Loaded) {
      final filteredContacts = _applyFilterAndSearch(
          currentState.originalContacts,
          event.searchTerm,
          currentState.currentFilter);
      final sortedContacts = _sortContacts(
          filteredContacts, currentState.sortField, currentState.ascending);
      emit(currentState.copyWith(
        displayedContacts: sortedContacts,
        searchTerm: event.searchTerm,
      ));
    }
  }

  /// Handles the ApplyFilter event by applying a preset filter to contacts.
  ///
  /// Applies the filter to the original contact list.
  void _onApplyFilter(ApplyFilter event, Emitter<ContactListState> emit) {
    final currentState = state;
    if (currentState is Loaded) {
      final filteredContacts = _applyFilterAndSearch(
          currentState.originalContacts, currentState.searchTerm, event.filter);
      final sortedContacts = _sortContacts(
          filteredContacts, currentState.sortField, currentState.ascending);
      emit(currentState.copyWith(
        displayedContacts: sortedContacts,
        currentFilter: event.filter,
      ));
    }
  }

  /// Handles the DeleteContacts event by removing one or more contacts.
  ///
  /// Works for both single contact deletion and batch deletions.
  /// Updates the contact list state after attempting to delete specified contacts.
  /// Continues even if some deletions fail.
  Future<void> _onDeleteContacts(
      DeleteContacts event, Emitter<ContactListState> emit) async {
    final currentState = state;
    if (currentState is Loaded) {
      emit(const Loading()); // Indicate operation in progress
      try {
        List<int> deletedIds = [];
        bool anyFailed = false;

        for (final id in event.contactIds) {
          try {
            await _contactRepository.delete(id);
            // If delete succeeds without throwing, add the id
            deletedIds.add(id);
          } catch (e) {
            logger.w('Failed to delete contact with id $id: $e');
            anyFailed = true; // Mark that at least one deletion failed
          }
        }

        // Update state based on successfully deleted contacts
        if (deletedIds.isNotEmpty) {
          final updatedContacts = currentState.originalContacts
              .where((c) => !deletedIds.contains(c.id))
              .toList();

          if (updatedContacts.isEmpty) {
            emit(const Empty());
          } else {
            final filteredContacts = _applyFilterAndSearch(updatedContacts,
                currentState.searchTerm, currentState.currentFilter);
            final sortedContacts = _sortContacts(filteredContacts,
                currentState.sortField, currentState.ascending);
            emit(currentState.copyWith(
              originalContacts: updatedContacts,
              displayedContacts: sortedContacts,
            ));
          }
        } else {
          // If no contacts were deleted, re-emit the current state
          emit(currentState);
        }

        // Log if some contacts couldn't be deleted
        if (anyFailed) {
          logger.w('Some contacts could not be deleted');
          // Optionally emit a specific state or message indicating partial failure
        }
      } catch (e) {
        logger.e('Error deleting contacts: $e');
        emit(Error(e.toString()));
        // Re-emit the previous state
        emit(currentState);
      }
    }
  }

  /// Handles the UpdateContacts event by updating contacts or marking them as contacted.
  ///
  /// This unified handler supports both full contact updates and marking contacts
  /// as contacted with the current time.
  Future<void> _onUpdateContacts(
      UpdateContacts event, Emitter<ContactListState> emit) async {
    final currentState = state;
    if (currentState is! Loaded) return;

    emit(const Loading()); // Indicate operation in progress

    try {
      final now = DateTime.now();
      List<Contact> updatedContacts = [];

      // Case 1: We have full contacts to update
      if (event.contacts != null) {
        for (final contact in event.contacts!) {
          try {
            final updatedContact = await _contactRepository.update(contact);
            updatedContacts.add(updatedContact);

            // Schedule reminder if it's appropriate for this contact
            await _notificationService.scheduleReminder(updatedContact);
          } catch (e) {
            logger.e('Error updating contact: $e');
            // Continue with other contacts rather than failing the whole batch
          }
        }
      }
      // Case 2: We have contact IDs to mark as contacted
      else if (event.contactIds != null && event.markAsContacted) {
        for (final id in event.contactIds!) {
          try {
            final contact = currentState.originalContacts.firstWhere(
                (c) => c.id == id,
                orElse: () => throw Exception('Contact not found'));
            final updatedContact = contact.copyWith(lastContacted: now);
            final savedContact =
                await _contactRepository.update(updatedContact);
            updatedContacts.add(savedContact);

            // Schedule reminder for this contact
            await _notificationService.scheduleReminder(savedContact);
          } catch (e) {
            logger.e('Error marking contact $id as contacted: $e');
            // Continue with other contacts rather than failing the whole batch
          }
        }
      }

      if (updatedContacts.isNotEmpty) {
        // Update the state with the new contacts
        final newOriginalContacts =
            List<Contact>.from(currentState.originalContacts);
        for (var updatedContact in updatedContacts) {
          final index =
              newOriginalContacts.indexWhere((c) => c.id == updatedContact.id);
          if (index >= 0) {
            newOriginalContacts[index] = updatedContact;
          }
        }

        final filteredContacts = _applyFilterAndSearch(newOriginalContacts,
            currentState.searchTerm, currentState.currentFilter);
        final sortedContacts = _sortContacts(
            filteredContacts, currentState.sortField, currentState.ascending);

        emit(currentState.copyWith(
          originalContacts: newOriginalContacts,
          displayedContacts: sortedContacts,
        ));
      } else {
        // If no contacts were updated, re-emit the current state
        emit(currentState);
      }
    } catch (e) {
      logger.e('Error updating contacts: $e');
      emit(Error(e.toString()));
      // Re-emit the previous state to ensure UI stability
      emit(currentState);
    }
  }

  /// Handles the AddSampleContacts event by adding sample contacts.
  Future<void> _onAddSampleContacts(
      AddSampleContacts event, Emitter<ContactListState> emit) async {
    emit(const Loading());
    try {
      await _contactRepository.addSampleContacts();
      final contacts = await _contactRepository.getAll();
      emit(Loaded(
        originalContacts: contacts,
        displayedContacts: contacts,
        sortField: ContactListSortField.dueDate,
        ascending: true,
        searchTerm: '',
        currentFilter: ContactListFilter.none,
      ));
    } catch (e) {
      logger.e('Error adding sample contacts: $e');
      emit(Error(e.toString()));
    }
  }

  /// Handles the ClearAllData event by clearing all data.
  Future<void> _onClearAllData(
      ClearAllData event, Emitter<ContactListState> emit) async {
    emit(const Loading());
    try {
      await _contactRepository.clearAllData();
      emit(const Empty());
    } catch (e) {
      logger.e('Error clearing data: $e');
      emit(Error(e.toString()));
    }
  }

  /// Applies both search term and filter to a list of contacts.
  ///
  /// First filters by search term, then applies the specified filter.
  List<Contact> _applyFilterAndSearch(List<Contact> originalContacts,
      String searchTerm, ContactListFilter filter) {
    List<Contact> filteredList = List.from(originalContacts);

    if (searchTerm.isNotEmpty) {
      final lowerCaseSearchTerm = searchTerm.toLowerCase();
      filteredList = filteredList.where((contact) {
        // Include nickname in search if available
        final nicknameMatch = contact.nickname != null &&
            contact.nickname!.toLowerCase().contains(lowerCaseSearchTerm);

        return contact.firstName.toLowerCase().contains(lowerCaseSearchTerm) ||
            contact.lastName.toLowerCase().contains(lowerCaseSearchTerm) ||
            nicknameMatch;
      }).toList();
    }

    switch (filter) {
      case ContactListFilter.overdue:
        filteredList = filteredList
            .where((c) => isOverdue(c.frequency, c.lastContacted))
            .toList();
        break;
      case ContactListFilter.dueSoon:
        filteredList = filteredList.where((c) {
          if (c.frequency == ContactFrequency.never.value) {
            return false;
          }
          final dueDateDisplay =
              calculateNextDueDateDisplay(c.lastContacted, c.frequency);
          return dueDateDisplay == 'Today' || dueDateDisplay == 'Tomorrow';
        }).toList();
        break;
      case ContactListFilter.none:
        // No filtering, keep the list as is
        break;
    }

    return filteredList;
  }

  /// Sorts a list of contacts by the specified field and direction.
  ///
  /// Handles special cases like null dates and "never" frequency.
  List<Contact> _sortContacts(List<Contact> contactsToSort,
      ContactListSortField sortField, bool ascending) {
    List<Contact> sortedList = List.from(contactsToSort);

    sortedList.sort((a, b) {
      int comparison;
      switch (sortField) {
        case ContactListSortField.dueDate:
          // Replace calculateNextDueDate with direct call to utility function
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
            comparison = 1; // Null values come last when ascending
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
