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
      // LOAD CONTACT DETAILS
      // MARK: LOAD
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
        // MARK: SAVE
        // makes sure that the contact date fields are set correctly
      } else if (event is SaveContactEvent) {
        emit(const LoadingContactDetailsState());
        try {
          // ensure there's a last contact date
          Contact contactToSave = event.contact;
          if (event.contact.lastContactDate == null){ // if null, set to now
            contactToSave = event.contact.copyWith(
              lastContactDate: DateTime.now(),
            );
          }
          // if isActive and frequency is not 'never', set the next contact date
          if (event.contact.isActive && 
          event.contact.frequency != ContactFrequency.never.value) {
            contactToSave = contactToSave.copyWith(
              nextContactDate: calculateNextContactDate(event.contact),
            );
            }

          // Save the contact details to the repository
          final updatedContact = (contactToSave.id == null ||
                  contactToSave.id == 0)
              ? await _contactRepository.add(contactToSave)
              : await _contactRepository.update(contactToSave);

          // Emit the updated state
          emit(LoadedContactDetailsState(updatedContact));

          // Schedule a reminder for the updated contact
          _notificationService.scheduleReminder(updatedContact);
        } catch (error) {
          emit(ErrorContactDetailsState(error.toString()));
        }

        // ADD CONTACT
        // MARK: ADD
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
        // MARK: DELETE
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

  @override
  Future<void> close() {
    return super.close();
  }
}
