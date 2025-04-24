// lib/blocs/contact_details/contact_details_event.dart
import 'package:equatable/equatable.dart';
import 'package:recall/models/contact.dart';

/// Base class for all events in the contact details bloc.
abstract class ContactDetailsEvent extends Equatable {
  const ContactDetailsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to request loading a specific contact by ID.
///
/// This is typically dispatched when viewing an existing contact.
class LoadContact extends ContactDetailsEvent {
  /// The ID of the contact to load.
  final int contactId;
  
  const LoadContact({required this.contactId});
  
  @override
  List<Object?> get props => [contactId];
}

/// Event to save changes to an existing contact.
///
/// This is dispatched when the user confirms edits to a contact.
class SaveContact extends ContactDetailsEvent {
  /// The updated contact with changes to save.
  final Contact contact;
  
  const SaveContact({required this.contact});
  
  @override
  List<Object?> get props => [contact];
}

/// Event to update contact data locally without persisting to storage.
///
/// This is used during editing to update the UI state without committing changes.
class UpdateContactLocally extends ContactDetailsEvent {
  /// The temporarily updated contact.
  final Contact contact;
  
  const UpdateContactLocally({required this.contact});
  
  @override
  List<Object?> get props => [contact];
}

/// Event to create a new contact.
///
/// This is dispatched when the user confirms the creation of a new contact.
class AddContact extends ContactDetailsEvent {
  /// The new contact to be added.
  final Contact contact;
  
  const AddContact({required this.contact});
  
  @override
  List<Object?> get props => [contact];
}

/// Event to clear the current contact from state.
///
/// This is typically used when navigating away from contact details.
class ClearContact extends ContactDetailsEvent {
  const ClearContact();
}

/// Event to delete an existing contact.
///
/// This is dispatched when the user confirms deletion of a contact.
class DeleteContact extends ContactDetailsEvent {
  /// The ID of the contact to delete.
  final int contactId;
  
  const DeleteContact({required this.contactId});
  
  @override
  List<Object?> get props => [contactId];
}

/// Event to prepare the UI for creating a new contact.
///
/// This initializes a blank contact with default settings.
class PrepareNewContact extends ContactDetailsEvent {
  /// The default communication frequency to use for the new contact.
  final String defaultFrequency;
  
  const PrepareNewContact({required this.defaultFrequency});
  
  @override
  List<Object?> get props => [defaultFrequency];
}
