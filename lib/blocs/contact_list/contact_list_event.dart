part of 'contact_list_bloc.dart';

@freezed
class ContactListEvent with _$ContactListEvent {
  const factory ContactListEvent.loadContacts() = LoadContacts;
  const factory ContactListEvent.addContact(Contact contact) = AddContact;
  const factory ContactListEvent.deleteContact(int contactId) = DeleteContact;
  const factory ContactListEvent.updateContact(Contact updatedContact) = UpdateContact;
  const factory ContactListEvent.contactUpdated() = ContactUpdated; 
  const factory ContactListEvent.sortContacts(ContactListSortField sortField, bool ascending) = SortContacts;
  const factory ContactListEvent.updateLastContacted({required int contactId}) = UpdateLastContacted;
}

enum ContactListSortField {
  lastName,
  birthday,
  contactFrequency,
  lastContacted
}