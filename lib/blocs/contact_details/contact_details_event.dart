// lib/blocs/contact_details/contact_details_event.dart
part of 'contact_details_bloc.dart';

@freezed
sealed class ContactDetailsEvent with _$ContactDetailsEvent {
  const factory ContactDetailsEvent.loadContact({required int contactId}) =
      _LoadContact;
  const factory ContactDetailsEvent.saveContact({required Contact contact}) =
      _SaveContact;
  const factory ContactDetailsEvent.updateContactLocally(
      {required Contact contact}) = _UpdateContactLocally;
  const factory ContactDetailsEvent.addContact({required Contact contact}) =
      _AddContact;
  const factory ContactDetailsEvent.clearContact() = _ClearContact;
  const factory ContactDetailsEvent.deleteContact({required int contactId}) =
      _DeleteContact;
  const factory ContactDetailsEvent.prepareNewContact(
      {required String defaultFrequency}) = _PrepareNewContact; // Add this line
}
