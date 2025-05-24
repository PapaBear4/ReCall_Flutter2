// lib/blocs/contact_list/contact_list_event.dart
part of 'contact_list_bloc.dart';

abstract class ContactListEvent {
  const ContactListEvent();
}

// LOAD CONTACTS
// MARK: LOAD
class LoadContactListEvent extends ContactListEvent {
  final String searchTerm;
  final Set<ContactListFilterType> filters;
  final ContactListSortField sortField;
  final bool ascending;

  // default constructor is for all contacts, sorted by last name
  const LoadContactListEvent({
    this.searchTerm = '',
    this.filters = const {},
    this.sortField = ContactListSortField.lastName,
    this.ascending = true,
  });
}
// UPDATE single
// MARK: UPDATE
class UpdateContactFromListEvent extends ContactListEvent {
  final Contact contact;
  
  const UpdateContactFromListEvent(this.contact);
}

class _ContactsUpdatedEvent extends ContactListEvent {
  final List<Contact> contacts;

  const _ContactsUpdatedEvent(this.contacts);
}

// SORT
// MARK: SORT
class SortContactsEvent extends ContactListEvent {
  final ContactListSortField sortField;
  final bool ascending;
  
  const SortContactsEvent({
    this.sortField = ContactListSortField.nextContactDate,
    this.ascending = true,
  });
}

// MARK: SEARCH
class ApplySearchEvent extends ContactListEvent {
  final String searchTerm;
  
  const ApplySearchEvent({required this.searchTerm});
}

// MARK: FILTER
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

// MARK: DELETE
class DeleteContactsEvent extends ContactListEvent {
  final List<int> contactIds;

  const DeleteContactsEvent({required this.contactIds});

  // Convenience constructor for single contact deletion
  factory DeleteContactsEvent.single(int contactId) {
    return DeleteContactsEvent(contactIds: [contactId]);
  }
}

// MARK: MARK CONTACTED
class MarkContactsAsContactedEvent extends ContactListEvent {
  final List<int> contactIds;

  const MarkContactsAsContactedEvent({required this.contactIds});
}

// TOGGLE STATUS
class ToggleContactsActiveStatusEvent extends ContactListEvent {
  final List<int> contactIds;

  const ToggleContactsActiveStatusEvent({required this.contactIds});
}

// SELECTION MODE EVENTS
// MARK: SELECTION
class ToggleSelectionModeEvent extends ContactListEvent {
  const ToggleSelectionModeEvent();
}

class ToggleContactSelectionEvent extends ContactListEvent {
  final int contactId;

  const ToggleContactSelectionEvent({required this.contactId});
}

class ClearSelectionEvent extends ContactListEvent {
  const ClearSelectionEvent();
}

class SelectAllContactsEvent extends ContactListEvent {
  const SelectAllContactsEvent();
}

// Changed from enum ContactListFilter to enum ContactListFilterType
enum ContactListFilterType { overdue, dueSoon, active, archived, homescreen }

// Define possible sort fields
enum ContactListSortField {
  lastName,
  birthday,
  contactFrequency,
  lastContactDate,
  nextContactDate
}
