// lib/blocs/contact_details/contact_detals_state.dart
part of 'contact_details_bloc.dart';

abstract class ContactDetailsState {
  const ContactDetailsState();
}

class InitialContactDetailsState extends ContactDetailsState {
  const InitialContactDetailsState();
}

class LoadingContactDetailsState extends ContactDetailsState {
  const LoadingContactDetailsState();
}

class LoadedContactDetailsState extends ContactDetailsState {
  final Contact contact;

  const LoadedContactDetailsState(this.contact);
}

class ClearedContactDetailsState extends ContactDetailsState {
  const ClearedContactDetailsState();
}

class ErrorContactDetailsState extends ContactDetailsState {
  final String message;

  const ErrorContactDetailsState(this.message);
}
