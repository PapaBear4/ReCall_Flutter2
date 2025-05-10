// lib/blocs/contact_details/contact_detals_bloc.dart
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/models/enums.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/utils/contact_utils.dart';
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
      if (event is LoadContactEvent) {
        // LOAD CONTACT DETAILS
        // MARK: LOAD
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
      } else if (event is SaveContactEvent) {
        // SAVE CONTACT DETAILS
        // MARK: SAVE
        // makes sure that the contact date fields are set correctly
        emit(const LoadingContactDetailsState());
        try {
          // ensure there's a last contact date
          Contact contactToSave = event.contact;
          if (event.contact.lastContactDate == null) {
            // if null, set to now
            contactToSave = event.contact.copyWith(
              lastContactDate: DateTime.now(),
            );
          }
          // if isActive, set the next contact date
          if (event.contact.isActive) {
            contactToSave = contactToSave.copyWith(
              nextContactDate: calculateNextContactDate(event.contact),
            );
          }

          // Save the contact details to the repository
          final updatedContact =
              (contactToSave.id == null || contactToSave.id == 0)
                  ? await _contactRepository.add(contactToSave)
                  : await _contactRepository.update(contactToSave);

          // Emit the updated state
          emit(LoadedContactDetailsState(updatedContact));

          // Schedule a reminder for the updated contact
          _notificationService.scheduleReminder(updatedContact);
        } catch (error) {
          emit(ErrorContactDetailsState(error.toString()));
        }
      } else if (event is AddContactEvent) {
        // ADD CONTACT
        // MARK: ADD
        // TODO: I don't think I need this, dulicate of save
        /*emit(const LoadingContactDetailsState());
        try {
          final newContact = await _contactRepository.add(event.contact);
          emit(LoadedContactDetailsState(newContact));
          _notificationService.scheduleReminder(newContact);
        } catch (error) {
          emit(ErrorContactDetailsState(error.toString()));
        }*/
      } else if (event is DeleteContactEvent) {
        // DELETE CONTACT
        // MARK: DELETE
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
      } else if (event is UpdateContactLocallyEvent){
        emit(LoadedContactDetailsState(event.contact)); //TODO: left off here, need to try it
      }
    });
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
