// lib/blocs/contact_list/contact_list_state.dart
part of 'contact_list_bloc.dart';

@freezed
sealed class ContactListState with _$ContactListState {
  const factory ContactListState.initial() = _Initial;
  const factory ContactListState.empty() = _Empty;
  const factory ContactListState.loading() = _Loading;

  const factory ContactListState.loaded({
    required List<Contact> originalContacts, // Full list from repository
    required List<Contact> displayedContacts, // Filtered/Searched list for UI
    @Default(ContactListSortField.dueDate) ContactListSortField sortField,
    @Default(true) bool ascending,
    @Default('') String searchTerm, // Current search term
    @Default(ContactListFilter.none) ContactListFilter currentFilter, // Current filter
  }) = _Loaded;
  
  const factory ContactListState.error(String message) = _Error;
}