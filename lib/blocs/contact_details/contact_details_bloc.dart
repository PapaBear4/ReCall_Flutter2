import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:logger/logger.dart';
import 'package:recall/models/contact_frequency.dart';

part 'contact_details_event.dart';
part 'contact_details_state.dart';
part 'contact_details_bloc.freezed.dart';

var contactDetailLogger = Logger();

// Bloc responsible for managing the state of Contact Details screen
class ContactDetailsBloc
    extends Bloc<ContactDetailsEvent, ContactDetailsState> {
  // Repository for interacting with contact data
  final ContactRepository _contactRepository;

  // Constructor initializes the bloc with the contact repository and initial state
  ContactDetailsBloc({required ContactRepository contactRepository})
      : _contactRepository = contactRepository,
        super(const ContactDetailsState.initial()) {
    // Event handler for loading contact details
    on<LoadContact>((event, emit) async {
      emit(ContactDetailsState.loading());
      contactDetailLogger.i("LOG: Before calling getContactById");
      try {
        final contact = await _contactRepository
            .getContactById(event.contactId); // call getContactById
        contactDetailLogger.i("LOG: After calling getContactById");
        emit(ContactDetailsState.loaded(contact));
      } catch (e) {
        emit(ContactDetailsState.error(e.toString()));
      }
    });

    // Event handler for saving contact details to memory
    on<SaveContactDetails>((event, emit) async {
      if (state is ContactDetailsLoaded) {
        emit(ContactDetailsState.loading());
        try {
          //contactDetailLogger.i("LOG:try and update details");
          await _contactRepository.updateContact(event.updatedContact);
          //contactDetailLogger.i("LOG:update successful");
          emit(ContactDetailsState.loaded(
              event.updatedContact)); // Emit the updated state
        } catch (e) {
          emit(ContactDetailsError(e.toString()));
        }
      }
    });

    on<UpdateContactDetails>((event, emit) async {
      if (state is ContactDetailsLoaded) {
        emit(ContactDetailsState.loading());
        emit(ContactDetailsState.loaded(event.updatedContact));
      }
    });

    // Event handler for updating birthday specifically
    on<UpdateBirthday>((event, emit) async {
      if (state is ContactDetailsLoaded) {
        final currentState = state as ContactDetailsLoaded;
        emit(ContactDetailsState.loading());
        final updatedContact =
            currentState.contact.copyWith(birthday: event.birthday);
        emit(ContactDetailsState.loaded(
            updatedContact)); // Emit the updated state
      }
    });

    on<StartNewContact>((event, emit) async {
      if (state is ContactDetailsLoaded) {
        emit(ContactDetailsState.loading());
        emit(ContactDetailsState.loaded(Contact(
          id: 0,
          firstName: '',
          lastName: '',
          birthday: null,
          frequency: ContactFrequency.never.value,
          lastContacted: null,
        )));
      }
    });

    on<AddNewContact>((event, emit) async {
      if (state is ContactDetailsLoaded) {
        emit(ContactDetailsState.loading());
        final newContact =
            await _contactRepository.addContact(event.newContact);
        emit(ContactDetailsState.loaded(newContact));
      }
    });
  }
}
