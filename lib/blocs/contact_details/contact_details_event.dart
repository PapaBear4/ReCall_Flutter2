// lib/blocs/contact_details/contact_detals_event.dart
part of 'contact_details_bloc.dart';

abstract class ContactDetailsEvent {
  const ContactDetailsEvent();
}

class LoadContactEvent extends ContactDetailsEvent {
  final int contactId;
  
  const LoadContactEvent({required this.contactId});
}

class SaveContactEvent extends ContactDetailsEvent {
  final Contact contact;
  
  const SaveContactEvent({required this.contact});
}

class UpdateContactLocallyEvent extends ContactDetailsEvent {
  final Contact contact;
  
  const UpdateContactLocallyEvent({required this.contact});
}

class AddContactEvent extends ContactDetailsEvent {
  final Contact contact;
  
  const AddContactEvent({required this.contact});
}

class ClearContactEvent extends ContactDetailsEvent {
  const ClearContactEvent();
}

class DeleteContactEvent extends ContactDetailsEvent {
  final int contactId;
  
  const DeleteContactEvent({required this.contactId});
}
