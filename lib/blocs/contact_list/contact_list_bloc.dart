import 'package:bloc/bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:logger/logger.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_list_event.dart';
part 'contact_list_state.dart';
part 'contact_list_bloc.freezed.dart';

var contactListLogger = Logger();

class ContactListBloc extends Bloc<ContactListEvent, ContactListState> {
  late final ContactRepository _contactRepository;

  ContactListBloc({required ContactRepository contactRepository})
      : _contactRepository = contactRepository,
        super(const ContactListState.initial()) {
    on<LoadContacts>((event, emit) async {
      emit(const ContactListState.loading());
      try {
        final contacts = await _contactRepository.loadContacts();
        if (contacts.isEmpty) {
          emit(const ContactListState.empty());
        } else {
          emit(ContactListState.loaded(contacts: contacts));
        }
      } catch (e) {
        emit(ContactListState.error(e.toString()));
      }
    });

    on<DeleteContact>((event, emit) async {
      if (state is ContactListLoaded) {
        final currentState = state as ContactListLoaded;
        emit(const ContactListState.loading());
        try {
          await _contactRepository.deleteContact(event.contactId);
          final updatedContacts = await _contactRepository.loadContacts();
          emit(ContactListState.loaded(
              contacts: updatedContacts,
              sortField: currentState.sortField,
              ascending: currentState.ascending));
        } catch (e) {
          emit(ContactListState.error(e.toString()));
        }
      }
    });

    on<UpdateContact>((event, emit) async {
      if (state is ContactListLoaded) {
        final currentState = state as ContactListLoaded;
        emit(const ContactListState.loading());
        try {
          contactListLogger.i("LOG:attempting to update contact");
          await _contactRepository.updateContact(event.updatedContact);
          final updatedContacts = await _contactRepository.loadContacts();
          emit(ContactListState.loaded(
              contacts: updatedContacts,
              sortField: currentState.sortField,
              ascending: currentState.ascending));
        } catch (e) {
          emit(ContactListState.error(e.toString()));
        }
      }
    });

    on<ContactUpdated>((event, emit) async {
      add(const ContactListEvent.loadContacts()); 
    });

    on<AddContact>((event, emit) async {
      if (state is ContactListLoaded) {
        final currentState = state as ContactListLoaded;
        emit(const ContactListState.loading());
        try {
          contactListLogger.i("LOG:Attempting to add contact");
          await _contactRepository.addContact(event.contact);
          contactListLogger.i("LOG:Contact added");
          final updatedContacts = await _contactRepository.loadContacts();
          emit(ContactListState.loaded(
              contacts: updatedContacts,
              sortField: currentState.sortField,
              ascending: currentState.ascending));
        } catch (e) {
          emit(ContactListState.error(e.toString()));
          contactListLogger.i("LOG:Error adding contact: $e");
        }
      }
    });

    on<SortContacts>((event, emit) async {
      if (state is ContactListLoaded) {
        final currentState = state as ContactListLoaded;
        final currentContacts =
            List<Contact>.from(currentState.contacts); 

        currentContacts.sort((a, b) {
          final sortValueA = _getSortValue(a, event.sortField);
          final sortValueB = _getSortValue(b, event.sortField);
          if (sortValueA == null || sortValueB == null) {
            return 0; 
          } else if (sortValueA is Comparable && sortValueB is Comparable) {
            return event.ascending
                ? Comparable.compare(sortValueA, sortValueB)
                : Comparable.compare(sortValueB, sortValueA);
          } else {
            return 0;
          }
        });

        emit(ContactListState.loaded(
            contacts: currentContacts,
            sortField: event.sortField,
            ascending: event.ascending));
      }
    });

    on<UpdateLastContacted>((event, emit) async {
      if (state is ContactListLoaded) {
        final currentState = state as ContactListLoaded;
        emit(const ContactListState.loading());
        try {
          await _contactRepository.updateLastContacted(event.contactId);
          final updatedContacts = await _contactRepository.loadContacts();
          emit(ContactListState.loaded(
              contacts: updatedContacts,
              sortField: currentState.sortField,
              ascending: currentState.ascending));
        } catch (e) {
          emit(ContactListState.error(e.toString()));
        }
      }
    });
  }

  dynamic _getSortValue(Contact contact, ContactListSortField sortField) {
    // ... (same as before)
  }
}