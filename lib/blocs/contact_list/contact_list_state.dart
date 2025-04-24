// lib/blocs/contact_list/contact_list_state.dart
import 'package:equatable/equatable.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/models/contact_enums.dart';

/// Base state class for the contact list feature.
///
/// All contact list states extend this class.
abstract class ContactListState extends Equatable {
  const ContactListState();

  @override
  List<Object?> get props => [];
}

/// The starting state when the contact list bloc is first created.
class Initial extends ContactListState {
  const Initial();
}

/// Indicates that contacts are being loaded or operations are in progress.
class Loading extends ContactListState {
  const Loading();
}

/// Represents a successfully loaded list of contacts with sort and filter options.
///
/// Contains both the original full list of contacts and the currently displayed
/// contacts after filtering and sorting have been applied.
class Loaded extends ContactListState {
  /// The complete list of contacts from the repository.
  final List<Contact> originalContacts;
  
  /// The filtered and sorted list of contacts currently displayed.
  final List<Contact> displayedContacts;
  
  /// The field currently used to sort the contacts.
  final ContactListSortField sortField;
  
  /// Whether the sort is in ascending (true) or descending (false) order.
  final bool ascending;
  
  /// The current search term applied to filter contacts.
  final String searchTerm;
  
  /// The current filter applied to the contact list.
  final ContactListFilter currentFilter;

  const Loaded({
    required this.originalContacts,
    required this.displayedContacts,
    this.sortField = ContactListSortField.dueDate,
    this.ascending = true,
    this.searchTerm = '',
    this.currentFilter = ContactListFilter.none,
  });

  /// Creates a copy of this state with the specified fields replaced.
  ///
  /// This follows the immutable state pattern for BLoC.
  Loaded copyWith({
    List<Contact>? originalContacts,
    List<Contact>? displayedContacts,
    ContactListSortField? sortField,
    bool? ascending,
    String? searchTerm,
    ContactListFilter? currentFilter,
  }) {
    return Loaded(
      originalContacts: originalContacts ?? this.originalContacts,
      displayedContacts: displayedContacts ?? this.displayedContacts,
      sortField: sortField ?? this.sortField,
      ascending: ascending ?? this.ascending,
      searchTerm: searchTerm ?? this.searchTerm,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }

  @override
  List<Object?> get props => [
        originalContacts,
        displayedContacts,
        sortField,
        ascending,
        searchTerm,
        currentFilter,
      ];
}

/// Indicates that no contacts are available in the system.
class Empty extends ContactListState {
  const Empty();
}

/// Represents an error state when contact operations fail.
class Error extends ContactListState {
  /// The error message describing what went wrong.
  final String message;

  const Error(this.message);

  @override
  List<Object?> get props => [message];
}