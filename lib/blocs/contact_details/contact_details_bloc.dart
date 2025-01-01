import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:logger/logger.dart';

part 'contact_details_event.dart';
part 'contact_details_state.dart';

var contactDetailLogger = Logger();

class ContactDetailsBloc
    extends Bloc<ContactDetailsEvent, ContactDetailsState> {
  final ContactRepository _contactRepository;

  ContactDetailsBloc({required ContactRepository contactRepository})
      : _contactRepository = contactRepository,
        super(ContactDetailsInitial()) {
    on<LoadContact>((event, emit) async {
      contactDetailLogger.i(
          "Loading contact with ID: ${event.contactId} in ContactDetailsBloc"); // <-- Add this
      emit(ContactDetailsLoading());
      try {
        final contact = await _contactRepository
            .getContactById(event.contactId); //call getContactById
        emit(ContactDetailsLoaded(contact));
      } catch (e) {
        emit(ContactDetailsError(e.toString()));
      }
    });

    on<UpdateContactDetails>((event, emit) async {
      if (state is ContactDetailsLoaded) {
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
