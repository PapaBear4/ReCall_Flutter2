// lib/blocs/contact_details/contact_details_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/utils/logger.dart';
import 'package:recall/services/service_locator.dart';

import 'contact_details_event.dart';
import 'contact_details_state.dart';

/// BLoC for managing the state of a single contact's details.
///
/// Handles operations like loading, creating, updating, and deleting
/// individual contacts.
class ContactDetailsBloc extends Bloc<ContactDetailsEvent, ContactDetailsState> {
  final ContactRepository _contactRepository;

  /// Creates a new ContactDetailsBloc.
  ///
  /// Uses GetIt to resolve dependencies for [ContactRepository].
  ContactDetailsBloc()
      : _contactRepository = getIt<ContactRepository>(),
        super(const Initial()) {
    on<LoadContact>(_onLoadContact);
    on<SaveContact>(_onSaveContact);
    on<UpdateContactLocally>(_onUpdateContactLocally);
    on<AddContact>(_onAddContact);
    on<ClearContact>(_onClearContact);
    on<DeleteContact>(_onDeleteContact);
    on<PrepareNewContact>(_onPrepareNewContact);
  }

  /// Handles the LoadContact event by fetching a contact from the repository.
  ///
  /// Emits a Loading state first, then either a Loaded state with the contact 
  /// or an Error state if the contact can't be found.
  Future<void> _onLoadContact(
      LoadContact event, Emitter<ContactDetailsState> emit) async {
    emit(const Loading());
    try {
      final contact = await _contactRepository.getById(event.contactId);
      if (contact != null) {
        emit(Loaded(contact));
      } else {
        emit(const Error("Contact not found"));
      }
    } catch (e) {
      logger.e('Error loading contact: $e');
      emit(Error(e.toString()));
    }
  }

  /// Handles the SaveContact event by updating an existing contact.
  ///
  /// Saves the updated contact to the repository and emits a Loaded state
  /// with the saved contact, or an Error state if the update fails.
  Future<void> _onSaveContact(
      SaveContact event, Emitter<ContactDetailsState> emit) async {
    // First emit a loading state to indicate we're processing
    emit(const Loading());
    
    try {
      final updatedContact = await _contactRepository.update(event.contact);
      emit(Loaded(updatedContact));
    } catch (e) {
      logger.e('Error saving contact: $e');
      emit(Error(e.toString()));
      
      // If there's an error, we should re-emit the previous state with the contact
      // so that the UI can maintain its state
      final currentState = state;
      if (currentState is Loaded) {
        emit(Loaded(currentState.contact));
      }
    }
  }

  /// Handles the UpdateContactLocally event by updating the contact in the UI without saving.
  ///
  /// This is used for temporary UI updates during editing before committing changes.
  void _onUpdateContactLocally(
      UpdateContactLocally event, Emitter<ContactDetailsState> emit) {
    // Just update the in-memory contact without saving to repository
    emit(Loaded(event.contact));
  }

  /// Handles the AddContact event by saving a new contact to the repository.
  ///
  /// Emits a Loading state first, then either a Loaded state with the saved
  /// contact or an Error state if the save fails.
  Future<void> _onAddContact(
      AddContact event, Emitter<ContactDetailsState> emit) async {
    // First emit a loading state to indicate we're processing
    emit(const Loading());
    
    try {
      final savedContact = await _contactRepository.add(event.contact);
      emit(Loaded(savedContact));
    } catch (e) {
      logger.e('Error adding contact: $e');
      emit(Error(e.toString()));
    }
  }

  /// Handles the ClearContact event by resetting the state.
  ///
  /// This is typically used when navigating away from the contact details screen.
  void _onClearContact(ClearContact event, Emitter<ContactDetailsState> emit) {
    emit(const Cleared());
  }

  /// Handles the DeleteContact event by removing a contact from the repository.
  ///
  /// Emits a Loading state first, then either a Cleared state on success
  /// or an Error state if the deletion fails.
  Future<void> _onDeleteContact(
      DeleteContact event, Emitter<ContactDetailsState> emit) async {
    // First emit a loading state to indicate we're processing
    emit(const Loading());
    
    try {
      await _contactRepository.delete(event.contactId);
      // If delete succeeds without throwing an exception, emit Cleared state
      emit(const Cleared());
    } catch (e) {
      logger.e('Error deleting contact: $e');
      emit(Error(e.toString()));
    }
  }

  /// Handles the PrepareNewContact event by creating an empty contact template.
  ///
  /// Initializes a new contact with default values and emits a Loaded state.
  /// This is used when the user starts creating a new contact.
  void _onPrepareNewContact(
      PrepareNewContact event, Emitter<ContactDetailsState> emit) {
    // Create a new empty contact with the default frequency
    final newContact = Contact(
      id: 0, // Use 0 to indicate a new contact (not saved yet)
      firstName: '',
      lastName: '',
      frequency: event.defaultFrequency,
      emails: [], // Initialize with empty list rather than null
    );
    
    emit(Loaded(newContact));
  }
}
