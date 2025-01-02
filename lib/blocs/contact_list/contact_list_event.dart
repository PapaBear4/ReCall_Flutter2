part of 'contact_list_bloc.dart';

// Abstract base class for all ContactList events.
// Events are used to trigger state changes in the ContactListBloc.
abstract class ContactListEvent extends Equatable {
  const ContactListEvent();

  @override
  List<Object> get props => [];
}


// Event to load the initial list of contacts.
class LoadContacts extends ContactListEvent {}

// Event to add a new contact to the list.
class AddContact extends ContactListEvent {
  final Contact contact;

  const AddContact(this.contact);

  @override
  // The contact object is used for equality comparison.
  List<Object> get props => [contact];
}

// Event to delete a contact from the list.
class DeleteContact extends ContactListEvent {
  final int contactId;

  const DeleteContact(this.contactId);

  @override
  // The contactId is used for equality comparison.
  List<Object> get props => [contactId];
}

// Event to update an existing contact in the list.
class UpdateContact extends ContactListEvent {
  final Contact updatedContact;

  const UpdateContact(this.updatedContact);

  @override
  // The updatedContact object is used for equality comparison.
  List<Object> get props => [updatedContact];
}

// Event to sort the contact list by a specific field.
class SortContacts extends ContactListEvent {
  final ContactListSortField sortField;
  final bool ascending;

  const SortContacts(this.sortField, this.ascending);

  @override
  // The sortField and ascending values are used for equality comparison.
  List<Object> get props => [sortField, ascending];
}

// Enum representing the different fields that can be used for sorting.
enum ContactListSortField {
  lastName,
  birthday,
  contactFrequency,
  lastContacted
}
