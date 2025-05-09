// lib/blocs/contact_details/contact_detals_bloc.dart
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:recall/models/contact.dart';
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
  late final StreamSubscription<Contact> _contactSubscription;

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
            // Subscribe to updates for this specific contact
            _contactSubscription = _contactRepository.contactStream
                .map((contacts) => contacts.firstWhere(
                      (c) => c.id == event.contactId,
                      orElse: () => throw Exception('Contact not found'),
                    ))
                .listen((updatedContact) {
              add(UpdateContactLocallyEvent(contact: updatedContact));
            });
          } else {
            emit(const ErrorContactDetailsState('Contact not found'));
          }
        } catch (e) {
          emit(ErrorContactDetailsState(e.toString()));
        }

        // SAVE CONTACT DETAILS
        // MARK: SAVE
      } else if (event is SaveContactEvent) {
        emit(const LoadingContactDetailsState());
        try {
          // Calculate the next contact date before saving
          final contactWithNextDate = event.contact.copyWith(
            nextContact: calculateNextContactDate(event.contact),
          );

          // Save the contact details to the repository
          final updatedContact =
              (contactWithNextDate.id == null || contactWithNextDate.id == 0)
                  ? await _contactRepository.add(contactWithNextDate)
                  : await _contactRepository.update(contactWithNextDate);

          // Emit the updated state
          emit(LoadedContactDetailsState(updatedContact));

          // Schedule a reminder for the updated contact
          _notificationService.scheduleReminder(updatedContact);
        } catch (error) {
          emit(ErrorContactDetailsState(error.toString()));
        }

        // UPDATE CONTACT LOCALLY for stream updates
      } else if (event is UpdateContactLocallyEvent) {
        try {
          emit(LoadedContactDetailsState(event.contact));
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

      @override
      Future<void> close() {
        _contactSubscription
            .cancel(); // Cancel the subscription when the bloc is closed
        return super.close();
      }
    });
  }
}
