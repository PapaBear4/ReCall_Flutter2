// lib/blocs/contact_list/contact_list_event.dart
part of 'contact_list_bloc.dart';

@freezed
sealed class ContactListEvent with _$ContactListEvent {
  const factory ContactListEvent.loadContacts() = _LoadContacts;
  const factory ContactListEvent.deleteContactFromList({
    required int contactId,
  }) = _DeleteContactFromList;
  const factory ContactListEvent.updateContactFromList({
    required Contact contact,
  }) = _UpdateContactFromList;
  const factory ContactListEvent.sortContacts({
    required ContactListSortField sortField,
    required bool ascending,
  }) = _SortContacts;
  const factory ContactListEvent.applySearch({
    required String searchTerm,
  }) = _ApplySearch;
  const factory ContactListEvent.applyFilter({
    required ContactListFilter filter,
  }) = _ApplyFilter;
  const factory ContactListEvent.deleteContacts({
    required List<int> contactIds,
  }) = _DeleteContacts;
  const factory ContactListEvent.markContactsAsContacted({
    required List<int> contactIds,
  }) = _MarkContactsAsContacted;
}

//define possible filters
enum ContactListFilter { none, overdue, dueSoon }

//define possible sort fields
enum ContactListSortField { dueDate, lastName, lastContacted, birthday, contactFrequency}
