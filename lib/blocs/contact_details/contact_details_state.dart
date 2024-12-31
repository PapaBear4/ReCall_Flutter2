part of 'contact_details_bloc.dart';

abstract class ContactDetailsState extends Equatable {
  const ContactDetailsState();

  @override
  List<Object> get props => [];
}

class ContactDetailsInitial extends ContactDetailsState {}

class ContactDetailsLoading extends ContactDetailsState {}

class ContactDetailsLoaded extends ContactDetailsState {
  final Contact contact;

  const ContactDetailsLoaded(this.contact);

  @override
  List<Object> get props => [contact];
}

class ContactDetailsError extends ContactDetailsState {
  final String message;
  const ContactDetailsError(this.message);

  @override
  List<Object> get props => [message];
}
