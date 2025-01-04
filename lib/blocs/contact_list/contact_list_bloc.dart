import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:logger/logger.dart';

part 'contact_list_event.dart';
part 'contact_list_state.dart';

var contactListLogger = Logger();

// Bloc responsible for managing the state of the contact list.
class ContactListBloc extends Bloc<ContactListEvent, ContactListState> {
  late final ContactRepository _contactRepository;

  // Constructor, injecting the contact repository.
  ContactListBloc({required ContactRepository contactRepository})
      : _contactRepository = contactRepository,
        super(ContactListInitial()) {
    // Event handler for loading contacts.
    // Emits ContactListLoading while fetching data,
    // then ContactListLoaded with the contacts if successful,
    // or ContactListError if an error occurs.
    on<LoadContacts>((event, emit) async {
      emit(ContactListLoading());
      try {
        final contacts = await _contactRepository.loadContacts();
        if (contacts.isEmpty) {
          emit(ContactListEmpty());
        } else {
          emit(ContactListLoaded(contacts: contacts));
        }
      } catch (e) {
        emit(ContactListError(e.toString()));
      }
    });

    // Event handler for deleting a contact.
    // Updates the contact list after a successful deletion
    // and emits ContactListLoaded with the updated list.
    on<DeleteContact>((event, emit) async {
      if (state is ContactListLoaded) {
        final currentState = state as ContactListLoaded;
        emit(ContactListLoading());
        try {
          await _contactRepository.deleteContact(event.contactId);
          final updatedContacts = await _contactRepository.loadContacts();
          emit(ContactListLoaded(
              contacts: updatedContacts,
              sortField: currentState.sortField,
              ascending: currentState.ascending));
        } catch (e) {
          emit(ContactListError(e.toString()));
        }
      }
    });

    // Event handler for updating an existing contact.
    // Updates the contact list after a successful update
    // and emits ContactListLoaded with the updated list.
    on<UpdateContact>((event, emit) async {
      if (state is ContactListLoaded) {
        final currentState = state as ContactListLoaded;
        emit(ContactListLoading());
        try {
          contactListLogger.i("LOG:attempting to update contact");
          await _contactRepository.updateContact(event.updatedContact);
          final updatedContacts = await _contactRepository.loadContacts();
          emit(ContactListLoaded(
              contacts: updatedContacts,
              sortField: currentState.sortField,
              ascending: currentState.ascending));
        } catch (e) {
          emit(ContactListError(e.toString()));
        }
      }
    });

    // contact_list_bloc.dart
    on<ContactUpdated>((event, emit) async {
      add(LoadContacts()); // Call LoadContacts again to refresh the data
    });

    // Event handler for adding a new contact.
    // Updates the contact list after a successful addition
    // and emits ContactListLoaded with the updated list.
    on<AddContact>((event, emit) async {
      if (state is ContactListLoaded) {
        final currentState = state as ContactListLoaded;
        emit(ContactListLoading());
        try {
          contactListLogger.i("LOG:Attempting to add contact");
          await _contactRepository.addContact(event.contact);
          contactListLogger.i("LOG:Contact added");
          final updatedContacts = await _contactRepository.loadContacts();
          emit(ContactListLoaded(
              contacts: updatedContacts,
              sortField: currentState.sortField,
              ascending: currentState.ascending));
        } catch (e) {
          emit(ContactListError(e.toString()));
          contactListLogger.i("LOG:Error adding contact: $e");
        }
      }
    });

    // Event handler for sorting the contact list.
    // Sorts the list based on the provided sort field and direction.
    on<SortContacts>((event, emit) async {
      if (state is ContactListLoaded) {
        final currentState = state as ContactListLoaded;
        final currentContacts =
            List<Contact>.from(currentState.contacts); // Create a copy

        currentContacts.sort((a, b) {
          final sortValueA = _getSortValue(a, event.sortField);
          final sortValueB = _getSortValue(b, event.sortField);
          if (sortValueA == null || sortValueB == null) {
            return 0; // Handle null values as needed
          } else if (sortValueA is Comparable && sortValueB is Comparable) {
            return event.ascending
                ? Comparable.compare(sortValueA, sortValueB)
                : Comparable.compare(sortValueB, sortValueA);
          } else {
            return 0;
          }
        });

        emit(ContactListLoaded(
            contacts: currentContacts,
            sortField: event.sortField,
            ascending: event.ascending));
      }
    });

    on<UpdateLastContacted>((event, emit) async {
      if (state is ContactListLoaded) {
        final currentState = state as ContactListLoaded;
        emit(ContactListLoading());
        try {
          await _contactRepository.updateLastContacted(event.contactId);
          final updatedContacts = await _contactRepository.loadContacts();
          emit(ContactListLoaded(
              contacts: updatedContacts,
              sortField: currentState.sortField,
              ascending: currentState.ascending));
        } catch (e) {
          emit(ContactListError(e.toString()));
        }
      }    });
  }

  // Helper function to get the value of a contact property
  // based on the specified sort field.
  dynamic _getSortValue(Contact contact, ContactListSortField sortField) {
    switch (sortField) {
      case ContactListSortField.lastName:
        return contact.lastName;
      case ContactListSortField.birthday:
        return contact.birthday;
      case ContactListSortField.contactFrequency:
        return contact.frequency;
      case ContactListSortField.lastContacted:
        return contact.lastContacted;
    }
  }
}
