// lib/blocs/contact_list/contact_list_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/models/contact_frequency.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/utils/logger.dart'; // Adjust path if needed
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:recall/services/notification_service.dart';
import 'package:recall/utils/last_contacted_utils.dart';

part 'contact_list_event.dart';
part 'contact_list_state.dart';
part 'contact_list_bloc.freezed.dart';

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
      switch (event) {
        case _LoadContacts e:
          final currentState = state;
          List<Contact> originalContacts = [];
          ContactListSortField sortField = ContactListSortField.dueDate;
          bool ascending = true;
          String searchTerm = '';
          ContactListFilter currentFilter = ContactListFilter.none;

          if (currentState is _Loaded) {
            sortField = currentState.sortField;
            ascending = currentState.ascending;
            searchTerm = currentState.searchTerm;
            currentFilter = currentState.currentFilter;
          }

          emit(const ContactListState.loading());
          try {
            originalContacts = await _contactRepository.getAll();
            if (originalContacts.isEmpty) {
              emit(const ContactListState.empty());
            } else {
              final filteredContacts = _applyFilterAndSearch(
                  originalContacts, searchTerm, currentFilter);
              final sortedContacts =
                  _sortContacts(filteredContacts, sortField, ascending);
              emit(ContactListState.loaded(
                originalContacts: originalContacts,
                displayedContacts: sortedContacts,
                sortField: sortField,
                ascending: ascending,
                searchTerm: searchTerm,
                currentFilter: currentFilter,
              ));
            }
          } catch (e) {
            emit(ContactListState.error(e.toString()));
          }
          break;

        case _DeleteContactFromList e:
          final currentState = state;
          if (currentState is _Loaded) {
            final updatedOriginals = List<Contact>.from(
                currentState.originalContacts)
              ..removeWhere((c) => c.id == e.contactId);

            final filtered = _applyFilterAndSearch(updatedOriginals,
                currentState.searchTerm, currentState.currentFilter);
            final sorted = _sortContacts(
                filtered, currentState.sortField, currentState.ascending);

            if (updatedOriginals.isEmpty) {
              emit(const ContactListState.empty());
            } else {
              emit(currentState.copyWith(
                originalContacts: updatedOriginals,
                displayedContacts: sorted,
              ));
            }
          }
          break;

        case _UpdateContactFromList e:
          final currentState = state;
          if (currentState is _Loaded) {
            final index = currentState.originalContacts
                .indexWhere((c) => c.id == e.contact.id);
            if (index != -1) {
              final updatedOriginals =
                  List<Contact>.from(currentState.originalContacts);
              updatedOriginals[index] = e.contact;

              final filtered = _applyFilterAndSearch(updatedOriginals,
                  currentState.searchTerm, currentState.currentFilter);
              final sorted = _sortContacts(
                  filtered, currentState.sortField, currentState.ascending);

              emit(currentState.copyWith(
                originalContacts: updatedOriginals,
                displayedContacts: sorted,
              ));
            }
          }
          break;

        case _SortContacts e:
          final currentState = state;
          if (currentState is _Loaded) {
            final sortedContacts = _sortContacts(
                List.from(currentState.displayedContacts),
                e.sortField,
                e.ascending);
            emit(currentState.copyWith(
              displayedContacts: sortedContacts,
              sortField: e.sortField,
              ascending: e.ascending,
            ));
          }
          break;

        case _ApplySearch e:
          final currentState = state;
          if (currentState is _Loaded) {
            final filteredContacts = _applyFilterAndSearch(
                currentState.originalContacts,
                e.searchTerm,
                currentState.currentFilter);
            final sortedContacts = _sortContacts(filteredContacts,
                currentState.sortField, currentState.ascending);
            emit(currentState.copyWith(
              displayedContacts: sortedContacts,
              searchTerm: e.searchTerm,
            ));
          }
          break;

        case _ApplyFilter e:
          final currentState = state;
          if (currentState is _Loaded) {
            final filteredContacts = _applyFilterAndSearch(
                currentState.originalContacts,
                currentState.searchTerm,
                e.filter);
            final sortedContacts = _sortContacts(filteredContacts,
                currentState.sortField, currentState.ascending);
            emit(currentState.copyWith(
              displayedContacts: sortedContacts,
              currentFilter: e.filter,
            ));
          }
          break;

        case _DeleteContacts e:
          final currentState = state;
          if (currentState is _Loaded) {
            try {
              await _contactRepository.deleteMany(e.contactIds);
              for (final id in e.contactIds) {
                await _notificationService.cancelNotification(id);
              }

              final updatedOriginals = List<Contact>.from(
                  currentState.originalContacts)
                ..removeWhere((c) => e.contactIds.contains(c.id));

              if (updatedOriginals.isEmpty) {
                emit(const ContactListState.empty());
              } else {
                final filtered = _applyFilterAndSearch(updatedOriginals,
                    currentState.searchTerm, currentState.currentFilter);
                final sorted = _sortContacts(
                    filtered, currentState.sortField, currentState.ascending);
                emit(currentState.copyWith(
                  originalContacts: updatedOriginals,
                  displayedContacts: sorted,
                ));
              }
            } catch (err, stackTrace) {
              logger.e('BLoC: Error deleting multiple contacts',
                  error: err, stackTrace: stackTrace);
              emit(currentState);
            }
          }
          break;

        case _MarkContactsAsContacted e:
          final currentState = state;
          if (currentState is _Loaded) {
            logger.d(
                "BLoC: Handling MarkContactsAsContacted for IDs: ${e.contactIds}");
            try {
              final now = DateTime.now();
              List<Contact> updatedOriginals =
                  List.from(currentState.originalContacts);

              for (final id in e.contactIds) {
                final contactIndex =
                    updatedOriginals.indexWhere((c) => c.id == id);
                if (contactIndex != -1) {
                  final originalContact = updatedOriginals[contactIndex];
                  final updatedContact =
                      originalContact.copyWith(lastContacted: now);

                  await _contactRepository.update(updatedContact);
                  updatedOriginals[contactIndex] = updatedContact;
                  await _notificationService.scheduleReminder(updatedContact);
                } else {
                  logger.w(
                      "BLoC: Could not find contact with ID $id in original list to mark as contacted.");
                }
              }

              if (updatedOriginals.isEmpty) {
                emit(const ContactListState.empty());
              } else {
                final newlyFilteredContacts = _applyFilterAndSearch(
                    updatedOriginals,
                    currentState.searchTerm,
                    currentState.currentFilter);
                final newlySortedContacts = _sortContacts(
                    newlyFilteredContacts,
                    currentState.sortField,
                    currentState.ascending);

                emit(currentState.copyWith(
                  originalContacts: updatedOriginals,
                  displayedContacts: newlySortedContacts,
                ));
                logger.i(
                    "BLoC: Successfully marked ${e.contactIds.length} contacts as contacted in state.");
              }
            } catch (err, stackTrace) {
              logger.e('BLoC: Error marking contacts as contacted',
                  error: err, stackTrace: stackTrace);
              emit(ContactListState.error(err.toString()));
            }
          }
          break;
      }
    });
  }

  List<Contact> _applyFilterAndSearch(List<Contact> originalContacts,
      String searchTerm, ContactListFilter filter) {
    List<Contact> filteredList = List.from(originalContacts);

    if (searchTerm.isNotEmpty) {
      final lowerCaseSearchTerm = searchTerm.toLowerCase();
      filteredList = filteredList.where((contact) {
        return contact.firstName.toLowerCase().contains(lowerCaseSearchTerm) ||
            contact.lastName.toLowerCase().contains(lowerCaseSearchTerm);
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
        break;
    }

    return filteredList;
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
