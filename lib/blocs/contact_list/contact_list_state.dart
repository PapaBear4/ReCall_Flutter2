part of 'contact_list_bloc.dart';

abstract class ContactListState extends Equatable {
  const ContactListState();

  @override
  List<Object> get props => [];
}

class ContactListInitial extends ContactListState {}

class ContactListEmpty extends ContactListState {}

class ContactListLoading extends ContactListState {}

class ContactListLoaded extends ContactListState {
  final List<Contact> contacts;
  final ContactListSortField sortField;
  final bool ascending;

  const ContactListLoaded({
    required this.contacts,
    this.sortField = ContactListSortField.lastName,
    this.ascending = true,
  });

  @override
  List<Object> get props => [contacts, sortField, ascending];
}

class ContactListError extends ContactListState {
  final String message;

  const ContactListError(this.message);

  @override
  List<Object> get props => [message];
}
