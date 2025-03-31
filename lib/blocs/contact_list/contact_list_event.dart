// lib/blocs/contact_list/contact_list_event.dart
part of 'contact_list_bloc.dart';

@freezed
sealed class ContactListEvent with _$ContactListEvent {
  const factory ContactListEvent.loadContacts() = _LoadContacts;
  const factory ContactListEvent.deleteContactFromList(int contactId) = _DeleteContactFromList;
  const factory ContactListEvent.updateContactFromList(Contact contact) =
      _UpdateContactFromList;
  
  // Use standard Dart default values for factory parameters
  const factory ContactListEvent.sortContacts({
    // Default to dueDate
    @Default(ContactListSortField.dueDate) ContactListSortField sortField,
    // Default to true (ascending: earliest due date first)
    @Default(true) bool ascending,
  }) = _SortContacts;

  // Events for filtering and searching
  const factory ContactListEvent.applySearch({required String searchTerm}) = _ApplySearch;
  const factory ContactListEvent.applyFilter({required ContactListFilter filter}) = _ApplyFilter;
  // No ClearFilter event needed if applying 'none' filter achieves the same

}

//define possible filters
enum ContactListFilter { none, overdue, dueSoon }

// Define possible sort fields
enum ContactListSortField {
  lastName,
  birthday,
  contactFrequency,
  lastContacted,
  dueDate // Add this field
}