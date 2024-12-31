part of 'contact_list_bloc.dart';

abstract class ContactListEvent extends Equatable {
  const ContactListEvent();

  @override
  List<Object> get props => [];
}

class LoadContacts extends ContactListEvent {}

class AddContact extends ContactListEvent {
  final Contact contact;

  const AddContact(this.contact);

  @override
  List<Object> get props => [contact];
}

class DeleteContact extends ContactListEvent {
  final int contactId;

  const DeleteContact(this.contactId);

  @override
  List<Object> get props => [contactId];
}

class UpdateContact extends ContactListEvent {
  final Contact updatedContact;

  const UpdateContact(this.updatedContact);

  @override
  List<Object> get props => [updatedContact];
}

class SortContacts extends ContactListEvent {
  final ContactListSortField sortField;
  final bool ascending;

  const SortContacts(this.sortField, this.ascending);

  @override
  List<Object> get props => [sortField, ascending];
}

enum ContactListSortField { lastName, birthday, contactFrequency, lastContacted }
