// lib/blocs/contact_details/contact_detals_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:logger/logger.dart';
import 'package:recall/services/notification_service.dart';

part 'contact_details_event.dart';
part 'contact_details_state.dart';
part 'contact_details_bloc.freezed.dart';

var contactDetailLogger = Logger();

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
        super(const ContactDetailsState.initial()) {
    // Event handler for loading contact details
    on<ContactDetailsEvent>((event, emit) async {
      await event.map(
        loadContact: (e) async {
          // Handles the LoadContact event
          emit(const ContactDetailsState.loading());
          try {
            final contact = await _contactRepository.getById(e.contactId);
            if (contact != null) {
              // CRUCIAL null check
              emit(ContactDetailsState.loaded(contact));
            } else {
              emit(const ContactDetailsState.error(
                  'Contact not found')); // Handle null case
            }
          } catch (e) {
            emit(ContactDetailsState.error(e.toString()));
          }
        },
        saveContact: (e) async {
          emit(const ContactDetailsState.loading());
          try {
            if (e.contact.id == null) {
              await _contactRepository.add(e.contact);
            } else {
              await _contactRepository.update(e.contact);
            }
            final updatedContact =
                await _contactRepository.getById(e.contact.id!);
            if (updatedContact != null) {
              emit(ContactDetailsState.loaded(updatedContact));
              _notificationService.updateContact(updatedContact);
            } else {
              emit(const ContactDetailsState.error(
                  'Failed to reload updated contact'));
            }
          } catch (error) {
            emit(ContactDetailsState.error(error.toString()));
          }
        },
        updateContactLocally: (e) async {
          // No need to emit loading state if it is not going to the repository
          try {
            emit(ContactDetailsState.loaded(e.contact));
          } catch (error) {
            emit(ContactDetailsState.error(error.toString()));
          }
        },
        addContact: (e) async {
          emit(const ContactDetailsState.loading());
          try {
            final newContact = await _contactRepository.add(e.contact);
            emit(ContactDetailsState.loaded(
                newContact)); // Emit loaded state with the NEW contact
          } catch (error) {
            emit(ContactDetailsState.error(error.toString()));
          }
        },
        deleteContact: (e) async {
          emit(const ContactDetailsState.loading());
          try {
            await _contactRepository.delete(e.contactId);
            emit(const ContactDetailsState
                .cleared()); // Emit cleared state after successful deletion
          } catch (error) {
            emit(ContactDetailsState.error(error.toString()));
          }
        },
        clearContact: (e) async {
          contactDetailLogger.i('Log: Clearing contact details');
          emit(const ContactDetailsState.cleared());
        },
        // ... other event handlers (for updateContact, addContact, etc.)
      );
    });
  }
}
