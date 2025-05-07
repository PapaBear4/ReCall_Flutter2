// lib/blocs/contact_list/contact_list_event.dart
part of 'contact_list_bloc.dart';

abstract class ContactListEvent {
  const ContactListEvent();
}

class LoadContactsEvent extends ContactListEvent {
  const LoadContactsEvent();
}

class LoadHomeScreenContactsEvent extends ContactListEvent {
  const LoadHomeScreenContactsEvent();
}

class DeleteContactFromListEvent extends ContactListEvent {
  final int contactId;
  
  const DeleteContactFromListEvent(this.contactId);
}

class UpdateContactFromListEvent extends ContactListEvent {
  final Contact contact;
  
  const UpdateContactFromListEvent(this.contact);
}

class SortContactsEvent extends ContactListEvent {
  final ContactListSortField sortField;
  final bool ascending;
  
  const SortContactsEvent({
    this.sortField = ContactListSortField.dueDate,
    this.ascending = true,
  });
}

class ApplySearchEvent extends ContactListEvent {
  final String searchTerm;
  
  const ApplySearchEvent({required this.searchTerm});
}

// Updated to toggle a specific filter on/off
class ApplyFilterEvent extends ContactListEvent {
  final ContactListFilterType filterType;
  final bool isActive; // true to enable filter, false to disable
  
  const ApplyFilterEvent({
    required this.filterType,
    required this.isActive,
  });
}

// New event to clear all filters
class ClearFiltersEvent extends ContactListEvent {
  const ClearFiltersEvent();
}

class DeleteContactsEvent extends ContactListEvent {
  final List<int> contactIds;
  
  const DeleteContactsEvent({required this.contactIds});
}

// Changed from enum ContactListFilter to enum ContactListFilterType
// to better represent that these are filter types that can be combined
enum ContactListFilterType { overdue, dueSoon }

// Define possible sort fields
enum ContactListSortField {
  lastName,
  birthday,
  contactFrequency,
  lastContacted,
  dueDate
}
