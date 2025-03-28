// lib/blocs/contact_list/contact_list_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:recall/models/contact.dart';
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
    on<ContactListEvent>((event, emit) async {
      await event.map(
        loadContacts: (e) async {
          emit(const ContactListState.loading());
          try {
            final contacts = await _contactRepository.getAll();
            if (contacts.isEmpty) {
              emit(const ContactListState.empty());
            } else {
              // Sort contacts by due date by default when loading
              final sortedContacts =
                  _sortContacts(contacts, ContactListSortField.dueDate, true);
              emit(ContactListState.loaded(
                  contacts: sortedContacts,
                  sortField: ContactListSortField
                      .dueDate, // Explicitly set default sort
                  ascending: true));
            }
          } catch (e) {
            emit(ContactListState.error(e.toString()));
          }
        },
        deleteContactFromList: (e) async {
          //TODO: Maybe for later to provide a way to delete contacts
          //directly from the list
        },
        updateContactFromList: (e) async {
          // Keep track of current sort state before loading
          ContactListSortField currentSortField = ContactListSortField.dueDate;
          bool currentAscending = true;
          if (state is _Loaded) {
            final currentState = state as _Loaded;
            currentSortField = currentState.sortField;
            currentAscending = currentState.ascending;
          }

          emit(const ContactListState.loading());
          try {
            final newContact = await _contactRepository.update(e.contact);
            final updatedContacts = await _contactRepository.getAll();
            // Re-apply the sort after updating
            final sortedContacts = _sortContacts(
                updatedContacts, currentSortField, currentAscending);
            emit(ContactListState.loaded(
                contacts: sortedContacts,
                sortField: currentSortField,
                ascending: currentAscending));
            _notificationService.scheduleReminder(newContact);
            notificationLogger.i('LOG: Calling notification service');
          } catch (e) {
            emit(ContactListState.error(e.toString()));
          }
        },
        sortContacts: (e) async {
          if (state is! _Loaded) return;
          final currentState = state as _Loaded;
          final sortedContacts =
              _sortContacts(currentState.contacts, e.sortField, e.ascending);
          emit(ContactListState.loaded(
              contacts: sortedContacts,
              sortField: e.sortField,
              ascending: e.ascending));
        },
        //other event handlers if needed
      );
    });
  }
// Helper function for sorting
  List<Contact> _sortContacts(
      List<Contact> contacts, ContactListSortField sortField, bool ascending) {
    List<Contact> sortedList = List.from(contacts); // Create a modifiable copy

    sortedList.sort((a, b) {
      int comparison;
      switch (sortField) {
        case ContactListSortField.dueDate:
          // Calculate due dates for comparison
          DateTime dueA = calculateNextDueDate(a);
          DateTime dueB = calculateNextDueDate(b);
          comparison = dueA.compareTo(dueB);
          break;
        case ContactListSortField.lastName:
          comparison = a.lastName.compareTo(b.lastName);
          if (comparison == 0) {
            comparison = a.firstName.compareTo(b.firstName);
          }
          break;
        case ContactListSortField.lastContacted:
          // Handle nulls: contacts never contacted might go last or first depending on preference
          // Here, nulls (never contacted) go last when ascending.
          DateTime lastA = a.lastContacted ??
              DateTime(9999); // Treat null as very far in the future
          DateTime lastB = b.lastContacted ?? DateTime(9999);
          comparison = lastA.compareTo(lastB);
          break;
        // Add cases for other sort fields if needed
        default:
          comparison = 0;
      }
      return ascending ? comparison : -comparison; // Apply ascending/descending
    });
    return sortedList;
  }
}
