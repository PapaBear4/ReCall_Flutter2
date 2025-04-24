// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_list_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContactListEvent {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ContactListEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ContactListEvent()';
  }
}

/// @nodoc
class $ContactListEventCopyWith<$Res> {
  $ContactListEventCopyWith(
      ContactListEvent _, $Res Function(ContactListEvent) __);
}

/// @nodoc

class _LoadContacts implements ContactListEvent {
  const _LoadContacts();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _LoadContacts);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ContactListEvent.loadContacts()';
  }
}

/// @nodoc

class _DeleteContactFromList implements ContactListEvent {
  const _DeleteContactFromList(this.contactId);

  final int contactId;

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DeleteContactFromListCopyWith<_DeleteContactFromList> get copyWith =>
      __$DeleteContactFromListCopyWithImpl<_DeleteContactFromList>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DeleteContactFromList &&
            (identical(other.contactId, contactId) ||
                other.contactId == contactId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, contactId);

  @override
  String toString() {
    return 'ContactListEvent.deleteContactFromList(contactId: $contactId)';
  }
}

/// @nodoc
abstract mixin class _$DeleteContactFromListCopyWith<$Res>
    implements $ContactListEventCopyWith<$Res> {
  factory _$DeleteContactFromListCopyWith(_DeleteContactFromList value,
          $Res Function(_DeleteContactFromList) _then) =
      __$DeleteContactFromListCopyWithImpl;
  @useResult
  $Res call({int contactId});
}

/// @nodoc
class __$DeleteContactFromListCopyWithImpl<$Res>
    implements _$DeleteContactFromListCopyWith<$Res> {
  __$DeleteContactFromListCopyWithImpl(this._self, this._then);

  final _DeleteContactFromList _self;
  final $Res Function(_DeleteContactFromList) _then;

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? contactId = null,
  }) {
    return _then(_DeleteContactFromList(
      null == contactId
          ? _self.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _UpdateContactFromList implements ContactListEvent {
  const _UpdateContactFromList(this.contact);

  final Contact contact;

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UpdateContactFromListCopyWith<_UpdateContactFromList> get copyWith =>
      __$UpdateContactFromListCopyWithImpl<_UpdateContactFromList>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UpdateContactFromList &&
            (identical(other.contact, contact) || other.contact == contact));
  }

  @override
  int get hashCode => Object.hash(runtimeType, contact);

  @override
  String toString() {
    return 'ContactListEvent.updateContactFromList(contact: $contact)';
  }
}

/// @nodoc
abstract mixin class _$UpdateContactFromListCopyWith<$Res>
    implements $ContactListEventCopyWith<$Res> {
  factory _$UpdateContactFromListCopyWith(_UpdateContactFromList value,
          $Res Function(_UpdateContactFromList) _then) =
      __$UpdateContactFromListCopyWithImpl;
  @useResult
  $Res call({Contact contact});

  $ContactCopyWith<$Res> get contact;
}

/// @nodoc
class __$UpdateContactFromListCopyWithImpl<$Res>
    implements _$UpdateContactFromListCopyWith<$Res> {
  __$UpdateContactFromListCopyWithImpl(this._self, this._then);

  final _UpdateContactFromList _self;
  final $Res Function(_UpdateContactFromList) _then;

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? contact = null,
  }) {
    return _then(_UpdateContactFromList(
      null == contact
          ? _self.contact
          : contact // ignore: cast_nullable_to_non_nullable
              as Contact,
    ));
  }

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContactCopyWith<$Res> get contact {
    return $ContactCopyWith<$Res>(_self.contact, (value) {
      return _then(_self.copyWith(contact: value));
    });
  }
}

/// @nodoc

class _SortContacts implements ContactListEvent {
  const _SortContacts(
      {this.sortField = ContactListSortField.dueDate, this.ascending = true});

// Default to dueDate
  @JsonKey()
  final ContactListSortField sortField;
// Default to true (ascending: earliest due date first)
  @JsonKey()
  final bool ascending;

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SortContactsCopyWith<_SortContacts> get copyWith =>
      __$SortContactsCopyWithImpl<_SortContacts>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SortContacts &&
            (identical(other.sortField, sortField) ||
                other.sortField == sortField) &&
            (identical(other.ascending, ascending) ||
                other.ascending == ascending));
  }

  @override
  int get hashCode => Object.hash(runtimeType, sortField, ascending);

  @override
  String toString() {
    return 'ContactListEvent.sortContacts(sortField: $sortField, ascending: $ascending)';
  }
}

/// @nodoc
abstract mixin class _$SortContactsCopyWith<$Res>
    implements $ContactListEventCopyWith<$Res> {
  factory _$SortContactsCopyWith(
          _SortContacts value, $Res Function(_SortContacts) _then) =
      __$SortContactsCopyWithImpl;
  @useResult
  $Res call({ContactListSortField sortField, bool ascending});
}

/// @nodoc
class __$SortContactsCopyWithImpl<$Res>
    implements _$SortContactsCopyWith<$Res> {
  __$SortContactsCopyWithImpl(this._self, this._then);

  final _SortContacts _self;
  final $Res Function(_SortContacts) _then;

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sortField = null,
    Object? ascending = null,
  }) {
    return _then(_SortContacts(
      sortField: null == sortField
          ? _self.sortField
          : sortField // ignore: cast_nullable_to_non_nullable
              as ContactListSortField,
      ascending: null == ascending
          ? _self.ascending
          : ascending // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _ApplySearch implements ContactListEvent {
  const _ApplySearch({required this.searchTerm});

  final String searchTerm;

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ApplySearchCopyWith<_ApplySearch> get copyWith =>
      __$ApplySearchCopyWithImpl<_ApplySearch>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ApplySearch &&
            (identical(other.searchTerm, searchTerm) ||
                other.searchTerm == searchTerm));
  }

  @override
  int get hashCode => Object.hash(runtimeType, searchTerm);

  @override
  String toString() {
    return 'ContactListEvent.applySearch(searchTerm: $searchTerm)';
  }
}

/// @nodoc
abstract mixin class _$ApplySearchCopyWith<$Res>
    implements $ContactListEventCopyWith<$Res> {
  factory _$ApplySearchCopyWith(
          _ApplySearch value, $Res Function(_ApplySearch) _then) =
      __$ApplySearchCopyWithImpl;
  @useResult
  $Res call({String searchTerm});
}

/// @nodoc
class __$ApplySearchCopyWithImpl<$Res> implements _$ApplySearchCopyWith<$Res> {
  __$ApplySearchCopyWithImpl(this._self, this._then);

  final _ApplySearch _self;
  final $Res Function(_ApplySearch) _then;

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? searchTerm = null,
  }) {
    return _then(_ApplySearch(
      searchTerm: null == searchTerm
          ? _self.searchTerm
          : searchTerm // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _ApplyFilter implements ContactListEvent {
  const _ApplyFilter({required this.filter});

  final ContactListFilter filter;

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ApplyFilterCopyWith<_ApplyFilter> get copyWith =>
      __$ApplyFilterCopyWithImpl<_ApplyFilter>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ApplyFilter &&
            (identical(other.filter, filter) || other.filter == filter));
  }

  @override
  int get hashCode => Object.hash(runtimeType, filter);

  @override
  String toString() {
    return 'ContactListEvent.applyFilter(filter: $filter)';
  }
}

/// @nodoc
abstract mixin class _$ApplyFilterCopyWith<$Res>
    implements $ContactListEventCopyWith<$Res> {
  factory _$ApplyFilterCopyWith(
          _ApplyFilter value, $Res Function(_ApplyFilter) _then) =
      __$ApplyFilterCopyWithImpl;
  @useResult
  $Res call({ContactListFilter filter});
}

/// @nodoc
class __$ApplyFilterCopyWithImpl<$Res> implements _$ApplyFilterCopyWith<$Res> {
  __$ApplyFilterCopyWithImpl(this._self, this._then);

  final _ApplyFilter _self;
  final $Res Function(_ApplyFilter) _then;

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? filter = null,
  }) {
    return _then(_ApplyFilter(
      filter: null == filter
          ? _self.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as ContactListFilter,
    ));
  }
}

/// @nodoc

class _DeleteContacts implements ContactListEvent {
  const _DeleteContacts({required final List<int> contactIds})
      : _contactIds = contactIds;

  final List<int> _contactIds;
  List<int> get contactIds {
    if (_contactIds is EqualUnmodifiableListView) return _contactIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contactIds);
  }

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DeleteContactsCopyWith<_DeleteContacts> get copyWith =>
      __$DeleteContactsCopyWithImpl<_DeleteContacts>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DeleteContacts &&
            const DeepCollectionEquality()
                .equals(other._contactIds, _contactIds));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_contactIds));

  @override
  String toString() {
    return 'ContactListEvent.deleteContacts(contactIds: $contactIds)';
  }
}

/// @nodoc
abstract mixin class _$DeleteContactsCopyWith<$Res>
    implements $ContactListEventCopyWith<$Res> {
  factory _$DeleteContactsCopyWith(
          _DeleteContacts value, $Res Function(_DeleteContacts) _then) =
      __$DeleteContactsCopyWithImpl;
  @useResult
  $Res call({List<int> contactIds});
}

/// @nodoc
class __$DeleteContactsCopyWithImpl<$Res>
    implements _$DeleteContactsCopyWith<$Res> {
  __$DeleteContactsCopyWithImpl(this._self, this._then);

  final _DeleteContacts _self;
  final $Res Function(_DeleteContacts) _then;

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? contactIds = null,
  }) {
    return _then(_DeleteContacts(
      contactIds: null == contactIds
          ? _self._contactIds
          : contactIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc

class _MarkContactsAsContacted implements ContactListEvent {
  const _MarkContactsAsContacted({required final List<int> contactIds})
      : _contactIds = contactIds;

  final List<int> _contactIds;
  List<int> get contactIds {
    if (_contactIds is EqualUnmodifiableListView) return _contactIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contactIds);
  }

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MarkContactsAsContactedCopyWith<_MarkContactsAsContacted> get copyWith =>
      __$MarkContactsAsContactedCopyWithImpl<_MarkContactsAsContacted>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MarkContactsAsContacted &&
            const DeepCollectionEquality()
                .equals(other._contactIds, _contactIds));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_contactIds));

  @override
  String toString() {
    return 'ContactListEvent.markContactsAsContacted(contactIds: $contactIds)';
  }
}

/// @nodoc
abstract mixin class _$MarkContactsAsContactedCopyWith<$Res>
    implements $ContactListEventCopyWith<$Res> {
  factory _$MarkContactsAsContactedCopyWith(_MarkContactsAsContacted value,
          $Res Function(_MarkContactsAsContacted) _then) =
      __$MarkContactsAsContactedCopyWithImpl;
  @useResult
  $Res call({List<int> contactIds});
}

/// @nodoc
class __$MarkContactsAsContactedCopyWithImpl<$Res>
    implements _$MarkContactsAsContactedCopyWith<$Res> {
  __$MarkContactsAsContactedCopyWithImpl(this._self, this._then);

  final _MarkContactsAsContacted _self;
  final $Res Function(_MarkContactsAsContacted) _then;

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? contactIds = null,
  }) {
    return _then(_MarkContactsAsContacted(
      contactIds: null == contactIds
          ? _self._contactIds
          : contactIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc
mixin _$ContactListState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ContactListState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ContactListState()';
  }
}

/// @nodoc
class $ContactListStateCopyWith<$Res> {
  $ContactListStateCopyWith(
      ContactListState _, $Res Function(ContactListState) __);
}

/// @nodoc

class _Initial implements ContactListState {
  const _Initial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Initial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ContactListState.initial()';
  }
}

/// @nodoc

class _Empty implements ContactListState {
  const _Empty();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Empty);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ContactListState.empty()';
  }
}

/// @nodoc

class _Loading implements ContactListState {
  const _Loading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Loading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ContactListState.loading()';
  }
}

/// @nodoc

class _Loaded implements ContactListState {
  const _Loaded(
      {required final List<Contact> originalContacts,
      required final List<Contact> displayedContacts,
      this.sortField = ContactListSortField.dueDate,
      this.ascending = true,
      this.searchTerm = '',
      this.currentFilter = ContactListFilter.none})
      : _originalContacts = originalContacts,
        _displayedContacts = displayedContacts;

  final List<Contact> _originalContacts;
  List<Contact> get originalContacts {
    if (_originalContacts is EqualUnmodifiableListView)
      return _originalContacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_originalContacts);
  }

// Full list from repository
  final List<Contact> _displayedContacts;
// Full list from repository
  List<Contact> get displayedContacts {
    if (_displayedContacts is EqualUnmodifiableListView)
      return _displayedContacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_displayedContacts);
  }

// Filtered/Searched list for UI
  @JsonKey()
  final ContactListSortField sortField;
  @JsonKey()
  final bool ascending;
  @JsonKey()
  final String searchTerm;
// Current search term
  @JsonKey()
  final ContactListFilter currentFilter;

  /// Create a copy of ContactListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LoadedCopyWith<_Loaded> get copyWith =>
      __$LoadedCopyWithImpl<_Loaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Loaded &&
            const DeepCollectionEquality()
                .equals(other._originalContacts, _originalContacts) &&
            const DeepCollectionEquality()
                .equals(other._displayedContacts, _displayedContacts) &&
            (identical(other.sortField, sortField) ||
                other.sortField == sortField) &&
            (identical(other.ascending, ascending) ||
                other.ascending == ascending) &&
            (identical(other.searchTerm, searchTerm) ||
                other.searchTerm == searchTerm) &&
            (identical(other.currentFilter, currentFilter) ||
                other.currentFilter == currentFilter));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_originalContacts),
      const DeepCollectionEquality().hash(_displayedContacts),
      sortField,
      ascending,
      searchTerm,
      currentFilter);

  @override
  String toString() {
    return 'ContactListState.loaded(originalContacts: $originalContacts, displayedContacts: $displayedContacts, sortField: $sortField, ascending: $ascending, searchTerm: $searchTerm, currentFilter: $currentFilter)';
  }
}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res>
    implements $ContactListStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) =
      __$LoadedCopyWithImpl;
  @useResult
  $Res call(
      {List<Contact> originalContacts,
      List<Contact> displayedContacts,
      ContactListSortField sortField,
      bool ascending,
      String searchTerm,
      ContactListFilter currentFilter});
}

/// @nodoc
class __$LoadedCopyWithImpl<$Res> implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

  /// Create a copy of ContactListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? originalContacts = null,
    Object? displayedContacts = null,
    Object? sortField = null,
    Object? ascending = null,
    Object? searchTerm = null,
    Object? currentFilter = null,
  }) {
    return _then(_Loaded(
      originalContacts: null == originalContacts
          ? _self._originalContacts
          : originalContacts // ignore: cast_nullable_to_non_nullable
              as List<Contact>,
      displayedContacts: null == displayedContacts
          ? _self._displayedContacts
          : displayedContacts // ignore: cast_nullable_to_non_nullable
              as List<Contact>,
      sortField: null == sortField
          ? _self.sortField
          : sortField // ignore: cast_nullable_to_non_nullable
              as ContactListSortField,
      ascending: null == ascending
          ? _self.ascending
          : ascending // ignore: cast_nullable_to_non_nullable
              as bool,
      searchTerm: null == searchTerm
          ? _self.searchTerm
          : searchTerm // ignore: cast_nullable_to_non_nullable
              as String,
      currentFilter: null == currentFilter
          ? _self.currentFilter
          : currentFilter // ignore: cast_nullable_to_non_nullable
              as ContactListFilter,
    ));
  }
}

/// @nodoc

class _Error implements ContactListState {
  const _Error(this.message);

  final String message;

  /// Create a copy of ContactListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ErrorCopyWith<_Error> get copyWith =>
      __$ErrorCopyWithImpl<_Error>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Error &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'ContactListState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res>
    implements $ContactListStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) =
      __$ErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$ErrorCopyWithImpl<$Res> implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

  /// Create a copy of ContactListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(_Error(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
