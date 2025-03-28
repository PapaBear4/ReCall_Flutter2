// lib/blocs/contact_list/contact_list_event.dart
part of 'contact_list_bloc.dart';

@freezed
class ContactListEvent with _$ContactListEvent {
  const factory ContactListEvent.loadContacts() = _LoadContacts;
  const factory ContactListEvent.deleteContactFromList(int contactId) = _DeleteContactFromList;
  const factory ContactListEvent.updateContactFromList(Contact contact) =
      _UpdateContactFromList;
  // Use standard Dart default values for factory parameters
  const factory ContactListEvent.sortContacts({
    // Default to dueDate
    @Default(ContactListSortField.dueDate) ContactListSortField sortField,
    // Default to true (ascending: earliest due date first)
    @Default(true) bool ascending,
  }) = _SortContacts;
}

enum ContactListSortField {
  lastName,
  birthday,
  contactFrequency,
  lastContacted,
  dueDate // Add this field
}