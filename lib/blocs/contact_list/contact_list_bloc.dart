// lib/blocs/contact_list/contact_list_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:logger/logger.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:recall/services/notification_helper.dart';
import 'package:recall/services/notification_service.dart';

part 'contact_list_event.dart';
part 'contact_list_state.dart';
part 'contact_list_bloc.freezed.dart';

var contactListLogger = Logger();

class ContactListBloc extends Bloc<ContactListEvent, ContactListState> {
  final ContactRepository _contactRepository;
  final NotificationService _notificationService;

  ContactListBloc({
    required ContactRepository contactRepository,
    required NotificationService notificationService,
  })  : _contactRepository = contactRepository,
        _notificationService = notificationService,
        super(const ContactListState.initial()) {
    on<ContactListEvent>((event, emit) async {
      await event.map(
        loadContacts: (e) async {
          emit(const ContactListState.loading());
          try {
            final contacts = await _contactRepository.getAll();
            if (contacts.isEmpty) {
              emit(const ContactListState.empty());
            } else {
              emit(ContactListState.loaded(contacts: contacts));
            }
          } catch (e) {
            emit(ContactListState.error(e.toString()));
          }
        },
        deleteContactFromList: (e) async {
          //TODO: Maybe for later to provide a way to delete contacts
          //directly from the list
        },
        updateContactFromList: (e) async {
          if (state is! _Loaded) return;
          final currentState = state as _Loaded;
          emit(const ContactListState.loading());
          try {
            final newContact = await _contactRepository.update(e.contact);
            final updatedContacts = await _contactRepository.getAll();
            emit(ContactListState.loaded(
                contacts: updatedContacts,
                sortField: currentState.sortField,
                ascending: currentState.ascending));
            _notificationService.scheduleReminder(newContact);
            notificationLogger.i('LOG: Calling notification service');
          } catch (e) {
            emit(ContactListState.error(e.toString()));
          }
        },
        sortContacts: (e) async {
          //TODO: fill this in later
        },
        //other event handlers if needed
      );
    });
  }
}
