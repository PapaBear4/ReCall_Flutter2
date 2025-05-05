// lib/blocs/contact_details/contact_detals_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/utils/logger.dart'; // Adjust path if needed
import 'package:recall/services/notification_service.dart';

part 'contact_details_event.dart';
part 'contact_details_state.dart';

// Bloc responsible for managing the state of Contact Details screen
class ContactDetailsBloc
    extends Bloc<ContactDetailsEvent, ContactDetailsState> {
  // Repository for interacting with contact data
  final ContactRepository _contactRepository;
  final NotificationService _notificationService;

  // Constructor initializes the bloc with the contact repository and initial state
  ContactDetailsBloc({
    required ContactRepository contactRepository,
    required NotificationService notificationService,
  })  : _contactRepository = contactRepository,
        _notificationService = notificationService,
        super(const InitialContactDetailsState()) {
    // Event handler using instanceof checks instead of pattern matching
    on<ContactDetailsEvent>((event, emit) async {
      // LOAD CONTACT DETAILS
      if (event is LoadContactEvent) {
        emit(const LoadingContactDetailsState());
        try {
          // Fetch contact details from the repository using the provided ID
          final contact = await _contactRepository.getById(event.contactId);
          if (contact != null) {
            emit(LoadedContactDetailsState(contact));
          } else {
            emit(const ErrorContactDetailsState('Contact not found'));
          }
        } catch (e) {
          emit(ErrorContactDetailsState(e.toString()));
        }
        // SAVE CONTACT DETAILS
      } else if (event is SaveContactEvent) {
        emit(const LoadingContactDetailsState());
        try {
          // Save the contact details to the repository
          final updatedContact =
              (event.contact.id == null || event.contact.id == 0)
                  ? await _contactRepository.add(event.contact)
                  : await _contactRepository.update(event.contact);
          emit(LoadedContactDetailsState(updatedContact));
          _notificationService.scheduleReminder(updatedContact);
        } catch (error) {
          emit(ErrorContactDetailsState(error.toString()));
        }
        // UPDATE CONTACT LOCALLY
      } else if (event is UpdateContactLocallyEvent) {
        // TODO: I don't think I need this
        try {
          emit(LoadedContactDetailsState(event.contact));
        } catch (error) {
          emit(ErrorContactDetailsState(error.toString()));
        }
      // ADD CONTACT
      } else if (event is AddContactEvent) {
        emit(const LoadingContactDetailsState());
        try {
          final newContact = await _contactRepository.add(event.contact);
          emit(LoadedContactDetailsState(newContact));
          _notificationService.scheduleReminder(newContact);
        } catch (error) {
          emit(ErrorContactDetailsState(error.toString()));
        }
      // DELETE CONTACT
      } else if (event is DeleteContactEvent) {
        emit(const LoadingContactDetailsState());
        try {
          await _contactRepository.delete(event.contactId);
          emit(const ClearedContactDetailsState());
          _notificationService.cancelNotification(event.contactId);
        } catch (error) {
          emit(ErrorContactDetailsState(error.toString()));
        }
      } else if (event is ClearContactEvent) {
        logger.i('Log: Clearing contact details');
        emit(const ClearedContactDetailsState());
      }
    });
  }
}
