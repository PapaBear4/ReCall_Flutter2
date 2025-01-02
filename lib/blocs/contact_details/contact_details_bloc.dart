import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:logger/logger.dart';

part 'contact_details_event.dart';
part 'contact_details_state.dart';

var contactDetailLogger = Logger();
// Bloc responsible for managing the state of Contact Details screen
class ContactDetailsBloc
    extends Bloc<ContactDetailsEvent, ContactDetailsState> {
  // Repository for interacting with contact data
  final ContactRepository _contactRepository;

  // Constructor initializes the bloc with the contact repository and initial state
  ContactDetailsBloc({required ContactRepository contactRepository})
      : _contactRepository = contactRepository,
        super(ContactDetailsInitial()) {
          
    // Event handler for loading contact details
    on<LoadContact>((event, emit) async {
      contactDetailLogger.i(
          "LOG: Loading contact with ID: ${event.contactId} in ContactDetailsBloc"); // <-- Add this
      emit(ContactDetailsLoading());
      try {
        final contact = await _contactRepository
            .getContactById(event.contactId); //call getContactById
        emit(ContactDetailsLoaded(contact));
      } catch (e) {
        emit(ContactDetailsError(e.toString()));
      }
    });

    // Event handler for updating contact details
    on<UpdateContactDetails>((event, emit) async {
      if (state is ContactDetailsLoaded) {
        emit(ContactDetailsLoading());
        try {
          contactDetailLogger.i("LOG:try and update details");
          await _contactRepository.updateContact(event.updatedContact);
          contactDetailLogger.i("LOG:update successful");
          emit(ContactDetailsLoaded(
              event.updatedContact)); // Emit the updated state
        } catch (e) {
          contactDetailLogger.i("LOG:update failed");
          emit(ContactDetailsError(e.toString()));
        }
      }
    });

    // Event handler for updating birthday specifically
    on<UpdateBirthday>((event, emit) async {
      if (state is ContactDetailsLoaded) {
        final currentState = state as ContactDetailsLoaded;
        final updatedContact =
            currentState.contact.copyWith(birthday: event.birthday);
        emit(ContactDetailsLoaded(updatedContact)); // Emit the updated state
      }
    });
  }
}
