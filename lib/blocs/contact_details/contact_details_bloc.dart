// lib/blocs/contact_details/contact_detals_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/utils/logger.dart'; // Adjust path if needed
import 'package:recall/services/notification_service.dart';

part 'contact_details_event.dart';
part 'contact_details_state.dart';
part 'contact_details_bloc.freezed.dart';

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
      switch (event) {
        case _LoadContact e:
          emit(const ContactDetailsState.loading());
          try {
            final contact = await _contactRepository.getById(e.contactId);
            if (contact != null) {
              emit(ContactDetailsState.loaded(contact));
            } else {
              emit(const ContactDetailsState.error('Contact not found'));
            }
          } catch (err) {
            emit(ContactDetailsState.error(err.toString()));
          }
          break;

        case _SaveContact e:
          emit(const ContactDetailsState.loading());
          try {
            Contact savedContact;
            if (e.contact.id == null) {
              savedContact = await _contactRepository.add(e.contact);
            } else {
              await _contactRepository.update(e.contact);
              savedContact = (await _contactRepository.getById(e.contact.id!))!;
            }
            emit(ContactDetailsState.loaded(savedContact));
            await _notificationService.scheduleReminder(savedContact);
          } catch (error) {
            emit(ContactDetailsState.error(error.toString()));
          }
          break;

        case _UpdateContactLocally e:
          try {
            emit(ContactDetailsState.loaded(e.contact));
          } catch (error) {
            emit(ContactDetailsState.error(error.toString()));
          }
          break;

        case _AddContact e:
          emit(const ContactDetailsState.loading());
          try {
            final newContact = await _contactRepository.add(e.contact);
            emit(ContactDetailsState.loaded(newContact));
            await _notificationService.scheduleReminder(newContact);
          } catch (error) {
            emit(ContactDetailsState.error(error.toString()));
          }
          break;

        case _DeleteContact e:
          emit(const ContactDetailsState.loading());
          try {
            await _notificationService.cancelNotification(e.contactId);
            await _contactRepository.delete(e.contactId);
            emit(const ContactDetailsState.cleared());
          } catch (error) {
            emit(ContactDetailsState.error(error.toString()));
          }
          break;

        case _ClearContact e:
          logger.i('Log: Clearing contact details');
          emit(const ContactDetailsState.cleared());
          break;

        // Add this case within the switch (event) { ... } block
        case _PrepareNewContact e:
          emit(const ContactDetailsState.loading()); // Show loading briefly
          try {
            // Create a new, empty contact with the default frequency
            final newContact = Contact(
              id: 0, // Use 0 to signify a new contact
              firstName: '',
              lastName: '',
              frequency: e.defaultFrequency, // Use the passed default
              // Initialize other fields as needed (null or default)
              emails: [],
            );
            emit(ContactDetailsState.loaded(
                newContact)); // Emit loaded with the blank contact
            logger.i(
                'Prepared BLoC for new contact with default frequency: ${e.defaultFrequency}');
          } catch (error) {
            emit(ContactDetailsState.error(
                'Error preparing new contact: ${error.toString()}'));
          }
          break;
      }
    });
  }
}
