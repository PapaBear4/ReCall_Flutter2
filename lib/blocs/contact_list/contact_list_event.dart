// lib/blocs/contact_list/contact_list_event.dart
part of 'contact_list_bloc.dart';

@freezed
class ContactListEvent with _$ContactListEvent {
  const factory ContactListEvent.loadContacts() = _LoadContacts;
  const factory ContactListEvent.deleteContactFromList(int contactId) = _DeleteContactFromList;
  const factory ContactListEvent.updateContactFromList(Contact contact) =
      _UpdateContactFromList;
  const factory ContactListEvent.sortContacts(
      ContactListSortField sortField, bool ascending) = _SortContacts;
}

enum ContactListSortField {
  lastName,
  birthday,
  contactFrequency,
  lastContacted
}
