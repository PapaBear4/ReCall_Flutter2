part of 'contact_list_bloc.dart';

@freezed
class ContactListState with _$ContactListState {
  const factory ContactListState.initial() = ContactListInitial;
  const factory ContactListState.empty() = ContactListEmpty;
  const factory ContactListState.loading() = ContactListLoading;
  const factory ContactListState.loaded({
    required List<Contact> contacts,
    @Default(ContactListSortField.lastName) ContactListSortField sortField,
    @Default(true) bool ascending,
  }) = ContactListLoaded;
  const factory ContactListState.error(String message) = ContactListError;
}