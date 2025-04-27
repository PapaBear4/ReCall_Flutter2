// lib/blocs/contact_list/contact_list_event.dart
import 'package:equatable/equatable.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/models/contact_enums.dart';

/// Base class for all events in the contact list bloc.
abstract class ContactListEvent extends Equatable {
  const ContactListEvent();

  @override
  List<Object?> get props => [];
}

/// Event to request loading all contacts from the repository.
///
/// This is typically dispatched when first entering a contacts screen
/// or when refreshing the list.
class LoadContacts extends ContactListEvent {
  const LoadContacts();
}

/// Event to change the sort order of the contact list.
///
/// Allows sorting by different fields and toggling between ascending
/// and descending order.
class SortContacts extends ContactListEvent {
  /// The field to sort contacts by.
  final ContactListSortField sortField;
  
  /// Whether to sort in ascending (true) or descending (false) order.
  final bool ascending;

  const SortContacts({
    required this.sortField, 
    required this.ascending
  });

  @override
  List<Object?> get props => [sortField, ascending];
}

/// Event to filter contacts by a search term.
///
/// The search is typically applied to name fields.
class ApplySearch extends ContactListEvent {
  /// The term to search for in the contact list.
  final String searchTerm;

  const ApplySearch({required this.searchTerm});

  @override
  List<Object?> get props => [searchTerm];
}

/// Event to toggle a specific filter on/off in the contact list.
///
/// This is the primary way to modify filters in the new multi-filter system.
/// For active/archive filters, this will handle the mutual exclusivity.
class ToggleFilter extends ContactListEvent {
  /// The filter to toggle on/off
  final ContactListFilter filter;
  
  /// Whether to add (true) or remove (false) the filter
  final bool enabled;

  const ToggleFilter({required this.filter, required this.enabled});

  @override
  List<Object?> get props => [filter, enabled];
}

/// Event to clear all filters except the specified ones.
///
/// Useful for "Clear Filters" operations while preserving active/archived status.
class ClearFilters extends ContactListEvent {
  /// Optional filters to keep after clearing (e.g., keep active/archived status)
  final Set<ContactListFilter> filtersToKeep;

  const ClearFilters({this.filtersToKeep = const {}});

  @override
  List<Object?> get props => [filtersToKeep];
}

/// Event to delete one or more contacts from the list.
///
/// Can be used for both single deletions and batch operations.
class DeleteContacts extends ContactListEvent {
  /// IDs of the contacts to delete.
  final List<int> contactIds;

  /// Creates a delete event for multiple contacts.
  const DeleteContacts({required this.contactIds});

  /// Creates a delete event for a single contact.
  factory DeleteContacts.single(int contactId) => DeleteContacts(contactIds: [contactId]);

  @override
  List<Object?> get props => [contactIds];
}

/// Event to update one or more contacts in the list.
///
/// Can handle both single contact updates and batch operations like marking
/// multiple contacts as contacted.
/// Event to update one or more contacts in the list.
///
/// Can handle various batch operations including contact data updates,
/// marking as contacted, and toggling archived status.
class UpdateContacts extends ContactListEvent {
  /// The contacts to update, or null if this is a special operation.
  final List<Contact>? contacts;
  
  /// IDs of contacts to update, or null if providing full contacts.
  final List<int>? contactIds;
  
  /// Whether this update should set lastContacted to current time.
  final bool? markAsContacted;
  
  /// Whether to update archive status (null = don't change).
  final bool? setArchived;

  /// Private constructor for flexibility in factory methods.
  const UpdateContacts._({
    this.contacts,
    this.contactIds,
    this.markAsContacted,
    this.setArchived,
  }) : assert(contacts != null || contactIds != null, 'Either contacts or contactIds must be provided');

  /// Creates an event to update specific contacts.
  factory UpdateContacts({required List<Contact> contacts}) => 
      UpdateContacts._(contacts: contacts);
      
  /// Creates an event to update a single contact.
  factory UpdateContacts.single({required Contact contact}) => 
      UpdateContacts._(contacts: [contact]);
      
  /// Creates an event to mark multiple contacts as contacted now.
  factory UpdateContacts.markAsContacted({required List<int> contactIds}) => 
      UpdateContacts._(contactIds: contactIds, markAsContacted: true);
      
  /// Creates an event to mark a single contact as contacted now.
  factory UpdateContacts.markSingleAsContacted({required int contactId}) => 
      UpdateContacts._(contactIds: [contactId], markAsContacted: true);

  /// Creates an event to toggle archive status for multiple contacts.
  factory UpdateContacts.setArchiveStatus({
    required List<int> contactIds,
    required bool archived,
  }) => UpdateContacts._(contactIds: contactIds, setArchived: archived);
  
  /// Creates an event to toggle archive status for a single contact.
  factory UpdateContacts.setArchiveStatusSingle({
    required int contactId,
    required bool archived,
  }) => UpdateContacts._(contactIds: [contactId], setArchived: archived);

  @override
  List<Object?> get props => [contacts, contactIds, markAsContacted, setArchived];
}


/// Event to add sample contacts for testing
class AddSampleContacts extends ContactListEvent {
  /// The number of sample contacts to add
  final int count;
  
  /// Creates an event to add sample contacts
  const AddSampleContacts({this.count = 10});

  @override
  List<Object?> get props => [count];
}
/// Event to clear all app data
class ClearAllData extends ContactListEvent {
  const ClearAllData();
}
