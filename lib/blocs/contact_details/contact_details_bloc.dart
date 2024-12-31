import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ReCall/models/contact.dart';
import 'package:ReCall/repositories/contact_repository.dart';

part 'contact_details_event.dart';
part 'contact_details_state.dart';

class ContactDetailsBloc
    extends Bloc<ContactDetailsEvent, ContactDetailsState> {
  final ContactRepository _contactRepository;

  ContactDetailsBloc({required ContactRepository contactRepository})
      : _contactRepository = contactRepository,
        super(ContactDetailsInitial()) {
    on<LoadContact>((event, emit) async {
      print(
          'Loading contact with ID: ${event.contactId} in ContactDetailsBloc'); // <-- Add this
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
          await _contactRepository.updateContact(event.updatedContact);
          emit(ContactDetailsLoaded(
              event.updatedContact)); // Emit the updated state
        } catch (e) {
          emit(ContactDetailsError(e.toString()));
        }
      }
    });
  }
}
