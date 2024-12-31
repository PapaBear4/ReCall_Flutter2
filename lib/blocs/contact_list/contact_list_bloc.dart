import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/repositories/contact_repository.dart';

part 'contact_list_event.dart';
part 'contact_list_state.dart';

class ContactListBloc extends Bloc<ContactListEvent, ContactListState> {
  final ContactRepository _contactRepository;

  ContactListBloc({required ContactRepository contactRepository})
      : _contactRepository = contactRepository,
        super(ContactListInitial()) {
    on<LoadContacts>((event, emit) async {
      emit(ContactListLoading());
      try {
        final contacts = await _contactRepository.loadContacts();
        emit(ContactListLoaded(contacts: contacts));
      } catch (e) {
        emit(ContactListError(e.toString()));
      }
    });

    on<AddContact>((event, emit) async {
      if (state is ContactListLoaded) {
        final currentState = state as ContactListLoaded;
        try {
          await _contactRepository.addContact(event.contact);
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

    on<DeleteContact>((event, emit) async {
      if (state is ContactListLoaded) {
        final currentState = state as ContactListLoaded;
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

    on<UpdateContact>((event, emit) async {
      if (state is ContactListLoaded) {
        final currentState = state as ContactListLoaded;
        try {
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
  }

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
