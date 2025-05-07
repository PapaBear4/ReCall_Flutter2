// lib/blocs/contact_list/contact_list_event.dart
part of 'contact_list_bloc.dart';

abstract class ContactListEvent {
  const ContactListEvent();
}

// LOAD CONTACTS
class LoadContactsEvent extends ContactListEvent {
  final String searchTerm;
  final Set<ContactListFilterType> filters;
  final ContactListSortField sortField;
  final bool ascending;

  const LoadContactsEvent({
    this.searchTerm = '',
    this.filters = const {},
    this.sortField = ContactListSortField.nextContactDate,
    this.ascending = true,
  });
}
// UPDATE single
class UpdateContactFromListEvent extends ContactListEvent {
  final Contact contact;
  
  const UpdateContactFromListEvent(this.contact);
}

// SORT
class SortContactsEvent extends ContactListEvent {
  final ContactListSortField sortField;
  final bool ascending;
  
  const SortContactsEvent({
    this.sortField = ContactListSortField.nextContactDate,
    this.ascending = true,
  });
}

// SEARCH
class ApplySearchEvent extends ContactListEvent {
  final String searchTerm;
  
  const ApplySearchEvent({required this.searchTerm});
}

// FILTER
class ApplyFilterEvent extends ContactListEvent {
  final ContactListFilterType filterType;
  final bool isActive; // true to enable filter, false to disable
  
  const ApplyFilterEvent({
    required this.filterType,
    required this.isActive,
  });
}

// CLEAR FILTERS
class ClearFiltersEvent extends ContactListEvent {
  const ClearFiltersEvent();
}

// DELETE
class DeleteContactsEvent extends ContactListEvent {
  final List<int> contactIds;

  const DeleteContactsEvent({required this.contactIds});

  // Convenience constructor for single contact deletion
  factory DeleteContactsEvent.single(int contactId) {
    return DeleteContactsEvent(contactIds: [contactId]);
  }
}

// TOGGLE STATUS
class ToggleContactsActiveStatusEvent extends ContactListEvent {
  final List<int> contactIds;

  const ToggleContactsActiveStatusEvent({required this.contactIds});
}

// Changed from enum ContactListFilter to enum ContactListFilterType
enum ContactListFilterType { overdue, dueSoon, active, archived }

// Define possible sort fields
enum ContactListSortField {
  lastName,
  birthday,
  contactFrequency,
  lastContacted,
  nextContactDate
}
