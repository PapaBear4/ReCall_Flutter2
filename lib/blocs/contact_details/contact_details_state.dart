// lib/blocs/contact_details/contact_details_state.dart
import 'package:equatable/equatable.dart';
import 'package:recall/models/contact.dart';

/// Base class for all states in the contact details feature.
///
/// All contact details states extend this class.
abstract class ContactDetailsState extends Equatable {
  const ContactDetailsState();
  
  @override
  List<Object?> get props => [];
}

/// The starting state when the contact details bloc is first created.
///
/// This state indicates no contact has been loaded yet.
class Initial extends ContactDetailsState {
  const Initial();
}

/// Indicates that contact details are being loaded or operations are in progress.
///
/// This state is emitted during asynchronous operations like loading, saving or deleting.
class Loading extends ContactDetailsState {
  const Loading();
}

/// Represents a successfully loaded contact ready for display or editing.
///
/// This state contains the current contact being viewed or edited.
class Loaded extends ContactDetailsState {
  /// The contact being displayed or edited.
  final Contact contact;
  
  const Loaded(this.contact);
  
  @override
  List<Object?> get props => [contact];
}

/// Indicates that the current contact has been cleared.
///
/// This state is emitted after a successful deletion or when
/// navigating away from a contact's details.
class Cleared extends ContactDetailsState {
  const Cleared();
}

/// Represents an error state when contact operations fail.
///
/// Contains an error message that can be displayed to the user.
class Error extends ContactDetailsState {
  /// The error message describing what went wrong.
  final String message;
  
  const Error(this.message);
  
  @override
  List<Object?> get props => [message];
}
