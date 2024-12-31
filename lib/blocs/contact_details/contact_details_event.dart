part of 'contact_details_bloc.dart';

abstract class ContactDetailsEvent extends Equatable {
  const ContactDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadContact extends ContactDetailsEvent {
  final int contactId;

  const LoadContact(this.contactId);

  @override
  List<Object> get props => [contactId];
}

class UpdateContactDetails extends ContactDetailsEvent {
  final Contact updatedContact;

  const UpdateContactDetails(this.updatedContact);

  @override
  List<Object> get props => [updatedContact];
}
