// lib/blocs/contact_list/contact_list_state.dart
part of 'contact_list_bloc.dart';

@freezed
sealed class ContactListState with _$ContactListState {
  const factory ContactListState.initial() = _Initial;
  const factory ContactListState.loading() = _Loading;
  const factory ContactListState.loaded({
    required List<Contact> originalContacts, // Keep the full list
    required List<Contact> displayedContacts, // List after filtering/sorting
    required ContactListSortField sortField,
    required bool ascending,
    required String searchTerm,
    required ContactListFilter currentFilter,
  }) = _Loaded;
  const factory ContactListState.empty() = _Empty;
  const factory ContactListState.error(String message) = _Error;
}