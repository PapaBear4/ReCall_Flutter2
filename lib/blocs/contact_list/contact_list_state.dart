// lib/blocs/contact_list/contact_list_state.dart
part of 'contact_list_bloc.dart';

@freezed
class ContactListState with _$ContactListState {
  const factory ContactListState.initial() = _Initial;
  const factory ContactListState.empty() = _Empty;
  const factory ContactListState.loading() = _Loading;
  const factory ContactListState.loaded({
    required List<Contact> contacts,
    @Default(ContactListSortField.dueDate) ContactListSortField sortField,
    @Default(true) bool ascending,
  }) = _Loaded;
  const factory ContactListState.error(String message) = _Error;
}