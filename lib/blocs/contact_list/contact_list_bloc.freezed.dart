// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_list_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ContactListEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadContacts,
    required TResult Function(int contactId) deleteContactFromList,
    required TResult Function(Contact contact) updateContactFromList,
    required TResult Function(ContactListSortField sortField, bool ascending)
        sortContacts,
    required TResult Function(String searchTerm) applySearch,
    required TResult Function(ContactListFilter filter) applyFilter,
    required TResult Function(List<int> contactIds) deleteContacts,
    required TResult Function(List<int> contactIds) markContactsAsContacted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadContacts,
    TResult? Function(int contactId)? deleteContactFromList,
    TResult? Function(Contact contact)? updateContactFromList,
    TResult? Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult? Function(String searchTerm)? applySearch,
    TResult? Function(ContactListFilter filter)? applyFilter,
    TResult? Function(List<int> contactIds)? deleteContacts,
    TResult? Function(List<int> contactIds)? markContactsAsContacted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadContacts,
    TResult Function(int contactId)? deleteContactFromList,
    TResult Function(Contact contact)? updateContactFromList,
    TResult Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult Function(String searchTerm)? applySearch,
    TResult Function(ContactListFilter filter)? applyFilter,
    TResult Function(List<int> contactIds)? deleteContacts,
    TResult Function(List<int> contactIds)? markContactsAsContacted,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadContacts value) loadContacts,
    required TResult Function(_DeleteContactFromList value)
        deleteContactFromList,
    required TResult Function(_UpdateContactFromList value)
        updateContactFromList,
    required TResult Function(_SortContacts value) sortContacts,
    required TResult Function(_ApplySearch value) applySearch,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_DeleteContacts value) deleteContacts,
    required TResult Function(_MarkContactsAsContacted value)
        markContactsAsContacted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadContacts value)? loadContacts,
    TResult? Function(_DeleteContactFromList value)? deleteContactFromList,
    TResult? Function(_UpdateContactFromList value)? updateContactFromList,
    TResult? Function(_SortContacts value)? sortContacts,
    TResult? Function(_ApplySearch value)? applySearch,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_DeleteContacts value)? deleteContacts,
    TResult? Function(_MarkContactsAsContacted value)? markContactsAsContacted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadContacts value)? loadContacts,
    TResult Function(_DeleteContactFromList value)? deleteContactFromList,
    TResult Function(_UpdateContactFromList value)? updateContactFromList,
    TResult Function(_SortContacts value)? sortContacts,
    TResult Function(_ApplySearch value)? applySearch,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_DeleteContacts value)? deleteContacts,
    TResult Function(_MarkContactsAsContacted value)? markContactsAsContacted,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactListEventCopyWith<$Res> {
  factory $ContactListEventCopyWith(
          ContactListEvent value, $Res Function(ContactListEvent) then) =
      _$ContactListEventCopyWithImpl<$Res, ContactListEvent>;
}

/// @nodoc
class _$ContactListEventCopyWithImpl<$Res, $Val extends ContactListEvent>
    implements $ContactListEventCopyWith<$Res> {
  _$ContactListEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoadContactsImplCopyWith<$Res> {
  factory _$$LoadContactsImplCopyWith(
          _$LoadContactsImpl value, $Res Function(_$LoadContactsImpl) then) =
      __$$LoadContactsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadContactsImplCopyWithImpl<$Res>
    extends _$ContactListEventCopyWithImpl<$Res, _$LoadContactsImpl>
    implements _$$LoadContactsImplCopyWith<$Res> {
  __$$LoadContactsImplCopyWithImpl(
      _$LoadContactsImpl _value, $Res Function(_$LoadContactsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadContactsImpl implements _LoadContacts {
  const _$LoadContactsImpl();

  @override
  String toString() {
    return 'ContactListEvent.loadContacts()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadContactsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadContacts,
    required TResult Function(int contactId) deleteContactFromList,
    required TResult Function(Contact contact) updateContactFromList,
    required TResult Function(ContactListSortField sortField, bool ascending)
        sortContacts,
    required TResult Function(String searchTerm) applySearch,
    required TResult Function(ContactListFilter filter) applyFilter,
    required TResult Function(List<int> contactIds) deleteContacts,
    required TResult Function(List<int> contactIds) markContactsAsContacted,
  }) {
    return loadContacts();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadContacts,
    TResult? Function(int contactId)? deleteContactFromList,
    TResult? Function(Contact contact)? updateContactFromList,
    TResult? Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult? Function(String searchTerm)? applySearch,
    TResult? Function(ContactListFilter filter)? applyFilter,
    TResult? Function(List<int> contactIds)? deleteContacts,
    TResult? Function(List<int> contactIds)? markContactsAsContacted,
  }) {
    return loadContacts?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadContacts,
    TResult Function(int contactId)? deleteContactFromList,
    TResult Function(Contact contact)? updateContactFromList,
    TResult Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult Function(String searchTerm)? applySearch,
    TResult Function(ContactListFilter filter)? applyFilter,
    TResult Function(List<int> contactIds)? deleteContacts,
    TResult Function(List<int> contactIds)? markContactsAsContacted,
    required TResult orElse(),
  }) {
    if (loadContacts != null) {
      return loadContacts();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadContacts value) loadContacts,
    required TResult Function(_DeleteContactFromList value)
        deleteContactFromList,
    required TResult Function(_UpdateContactFromList value)
        updateContactFromList,
    required TResult Function(_SortContacts value) sortContacts,
    required TResult Function(_ApplySearch value) applySearch,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_DeleteContacts value) deleteContacts,
    required TResult Function(_MarkContactsAsContacted value)
        markContactsAsContacted,
  }) {
    return loadContacts(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadContacts value)? loadContacts,
    TResult? Function(_DeleteContactFromList value)? deleteContactFromList,
    TResult? Function(_UpdateContactFromList value)? updateContactFromList,
    TResult? Function(_SortContacts value)? sortContacts,
    TResult? Function(_ApplySearch value)? applySearch,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_DeleteContacts value)? deleteContacts,
    TResult? Function(_MarkContactsAsContacted value)? markContactsAsContacted,
  }) {
    return loadContacts?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadContacts value)? loadContacts,
    TResult Function(_DeleteContactFromList value)? deleteContactFromList,
    TResult Function(_UpdateContactFromList value)? updateContactFromList,
    TResult Function(_SortContacts value)? sortContacts,
    TResult Function(_ApplySearch value)? applySearch,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_DeleteContacts value)? deleteContacts,
    TResult Function(_MarkContactsAsContacted value)? markContactsAsContacted,
    required TResult orElse(),
  }) {
    if (loadContacts != null) {
      return loadContacts(this);
    }
    return orElse();
  }
}

abstract class _LoadContacts implements ContactListEvent {
  const factory _LoadContacts() = _$LoadContactsImpl;
}

/// @nodoc
abstract class _$$DeleteContactFromListImplCopyWith<$Res> {
  factory _$$DeleteContactFromListImplCopyWith(
          _$DeleteContactFromListImpl value,
          $Res Function(_$DeleteContactFromListImpl) then) =
      __$$DeleteContactFromListImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int contactId});
}

/// @nodoc
class __$$DeleteContactFromListImplCopyWithImpl<$Res>
    extends _$ContactListEventCopyWithImpl<$Res, _$DeleteContactFromListImpl>
    implements _$$DeleteContactFromListImplCopyWith<$Res> {
  __$$DeleteContactFromListImplCopyWithImpl(_$DeleteContactFromListImpl _value,
      $Res Function(_$DeleteContactFromListImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contactId = null,
  }) {
    return _then(_$DeleteContactFromListImpl(
      contactId: null == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$DeleteContactFromListImpl implements _DeleteContactFromList {
  const _$DeleteContactFromListImpl({required this.contactId});

  @override
  final int contactId;

  @override
  String toString() {
    return 'ContactListEvent.deleteContactFromList(contactId: $contactId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteContactFromListImpl &&
            (identical(other.contactId, contactId) ||
                other.contactId == contactId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, contactId);

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteContactFromListImplCopyWith<_$DeleteContactFromListImpl>
      get copyWith => __$$DeleteContactFromListImplCopyWithImpl<
          _$DeleteContactFromListImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadContacts,
    required TResult Function(int contactId) deleteContactFromList,
    required TResult Function(Contact contact) updateContactFromList,
    required TResult Function(ContactListSortField sortField, bool ascending)
        sortContacts,
    required TResult Function(String searchTerm) applySearch,
    required TResult Function(ContactListFilter filter) applyFilter,
    required TResult Function(List<int> contactIds) deleteContacts,
    required TResult Function(List<int> contactIds) markContactsAsContacted,
  }) {
    return deleteContactFromList(contactId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadContacts,
    TResult? Function(int contactId)? deleteContactFromList,
    TResult? Function(Contact contact)? updateContactFromList,
    TResult? Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult? Function(String searchTerm)? applySearch,
    TResult? Function(ContactListFilter filter)? applyFilter,
    TResult? Function(List<int> contactIds)? deleteContacts,
    TResult? Function(List<int> contactIds)? markContactsAsContacted,
  }) {
    return deleteContactFromList?.call(contactId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadContacts,
    TResult Function(int contactId)? deleteContactFromList,
    TResult Function(Contact contact)? updateContactFromList,
    TResult Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult Function(String searchTerm)? applySearch,
    TResult Function(ContactListFilter filter)? applyFilter,
    TResult Function(List<int> contactIds)? deleteContacts,
    TResult Function(List<int> contactIds)? markContactsAsContacted,
    required TResult orElse(),
  }) {
    if (deleteContactFromList != null) {
      return deleteContactFromList(contactId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadContacts value) loadContacts,
    required TResult Function(_DeleteContactFromList value)
        deleteContactFromList,
    required TResult Function(_UpdateContactFromList value)
        updateContactFromList,
    required TResult Function(_SortContacts value) sortContacts,
    required TResult Function(_ApplySearch value) applySearch,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_DeleteContacts value) deleteContacts,
    required TResult Function(_MarkContactsAsContacted value)
        markContactsAsContacted,
  }) {
    return deleteContactFromList(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadContacts value)? loadContacts,
    TResult? Function(_DeleteContactFromList value)? deleteContactFromList,
    TResult? Function(_UpdateContactFromList value)? updateContactFromList,
    TResult? Function(_SortContacts value)? sortContacts,
    TResult? Function(_ApplySearch value)? applySearch,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_DeleteContacts value)? deleteContacts,
    TResult? Function(_MarkContactsAsContacted value)? markContactsAsContacted,
  }) {
    return deleteContactFromList?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadContacts value)? loadContacts,
    TResult Function(_DeleteContactFromList value)? deleteContactFromList,
    TResult Function(_UpdateContactFromList value)? updateContactFromList,
    TResult Function(_SortContacts value)? sortContacts,
    TResult Function(_ApplySearch value)? applySearch,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_DeleteContacts value)? deleteContacts,
    TResult Function(_MarkContactsAsContacted value)? markContactsAsContacted,
    required TResult orElse(),
  }) {
    if (deleteContactFromList != null) {
      return deleteContactFromList(this);
    }
    return orElse();
  }
}

abstract class _DeleteContactFromList implements ContactListEvent {
  const factory _DeleteContactFromList({required final int contactId}) =
      _$DeleteContactFromListImpl;

  int get contactId;

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteContactFromListImplCopyWith<_$DeleteContactFromListImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateContactFromListImplCopyWith<$Res> {
  factory _$$UpdateContactFromListImplCopyWith(
          _$UpdateContactFromListImpl value,
          $Res Function(_$UpdateContactFromListImpl) then) =
      __$$UpdateContactFromListImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Contact contact});

  $ContactCopyWith<$Res> get contact;
}

/// @nodoc
class __$$UpdateContactFromListImplCopyWithImpl<$Res>
    extends _$ContactListEventCopyWithImpl<$Res, _$UpdateContactFromListImpl>
    implements _$$UpdateContactFromListImplCopyWith<$Res> {
  __$$UpdateContactFromListImplCopyWithImpl(_$UpdateContactFromListImpl _value,
      $Res Function(_$UpdateContactFromListImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contact = null,
  }) {
    return _then(_$UpdateContactFromListImpl(
      contact: null == contact
          ? _value.contact
          : contact // ignore: cast_nullable_to_non_nullable
              as Contact,
    ));
  }

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContactCopyWith<$Res> get contact {
    return $ContactCopyWith<$Res>(_value.contact, (value) {
      return _then(_value.copyWith(contact: value));
    });
  }
}

/// @nodoc

class _$UpdateContactFromListImpl implements _UpdateContactFromList {
  const _$UpdateContactFromListImpl({required this.contact});

  @override
  final Contact contact;

  @override
  String toString() {
    return 'ContactListEvent.updateContactFromList(contact: $contact)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateContactFromListImpl &&
            (identical(other.contact, contact) || other.contact == contact));
  }

  @override
  int get hashCode => Object.hash(runtimeType, contact);

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateContactFromListImplCopyWith<_$UpdateContactFromListImpl>
      get copyWith => __$$UpdateContactFromListImplCopyWithImpl<
          _$UpdateContactFromListImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadContacts,
    required TResult Function(int contactId) deleteContactFromList,
    required TResult Function(Contact contact) updateContactFromList,
    required TResult Function(ContactListSortField sortField, bool ascending)
        sortContacts,
    required TResult Function(String searchTerm) applySearch,
    required TResult Function(ContactListFilter filter) applyFilter,
    required TResult Function(List<int> contactIds) deleteContacts,
    required TResult Function(List<int> contactIds) markContactsAsContacted,
  }) {
    return updateContactFromList(contact);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadContacts,
    TResult? Function(int contactId)? deleteContactFromList,
    TResult? Function(Contact contact)? updateContactFromList,
    TResult? Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult? Function(String searchTerm)? applySearch,
    TResult? Function(ContactListFilter filter)? applyFilter,
    TResult? Function(List<int> contactIds)? deleteContacts,
    TResult? Function(List<int> contactIds)? markContactsAsContacted,
  }) {
    return updateContactFromList?.call(contact);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadContacts,
    TResult Function(int contactId)? deleteContactFromList,
    TResult Function(Contact contact)? updateContactFromList,
    TResult Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult Function(String searchTerm)? applySearch,
    TResult Function(ContactListFilter filter)? applyFilter,
    TResult Function(List<int> contactIds)? deleteContacts,
    TResult Function(List<int> contactIds)? markContactsAsContacted,
    required TResult orElse(),
  }) {
    if (updateContactFromList != null) {
      return updateContactFromList(contact);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadContacts value) loadContacts,
    required TResult Function(_DeleteContactFromList value)
        deleteContactFromList,
    required TResult Function(_UpdateContactFromList value)
        updateContactFromList,
    required TResult Function(_SortContacts value) sortContacts,
    required TResult Function(_ApplySearch value) applySearch,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_DeleteContacts value) deleteContacts,
    required TResult Function(_MarkContactsAsContacted value)
        markContactsAsContacted,
  }) {
    return updateContactFromList(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadContacts value)? loadContacts,
    TResult? Function(_DeleteContactFromList value)? deleteContactFromList,
    TResult? Function(_UpdateContactFromList value)? updateContactFromList,
    TResult? Function(_SortContacts value)? sortContacts,
    TResult? Function(_ApplySearch value)? applySearch,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_DeleteContacts value)? deleteContacts,
    TResult? Function(_MarkContactsAsContacted value)? markContactsAsContacted,
  }) {
    return updateContactFromList?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadContacts value)? loadContacts,
    TResult Function(_DeleteContactFromList value)? deleteContactFromList,
    TResult Function(_UpdateContactFromList value)? updateContactFromList,
    TResult Function(_SortContacts value)? sortContacts,
    TResult Function(_ApplySearch value)? applySearch,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_DeleteContacts value)? deleteContacts,
    TResult Function(_MarkContactsAsContacted value)? markContactsAsContacted,
    required TResult orElse(),
  }) {
    if (updateContactFromList != null) {
      return updateContactFromList(this);
    }
    return orElse();
  }
}

abstract class _UpdateContactFromList implements ContactListEvent {
  const factory _UpdateContactFromList({required final Contact contact}) =
      _$UpdateContactFromListImpl;

  Contact get contact;

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateContactFromListImplCopyWith<_$UpdateContactFromListImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SortContactsImplCopyWith<$Res> {
  factory _$$SortContactsImplCopyWith(
          _$SortContactsImpl value, $Res Function(_$SortContactsImpl) then) =
      __$$SortContactsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ContactListSortField sortField, bool ascending});
}

/// @nodoc
class __$$SortContactsImplCopyWithImpl<$Res>
    extends _$ContactListEventCopyWithImpl<$Res, _$SortContactsImpl>
    implements _$$SortContactsImplCopyWith<$Res> {
  __$$SortContactsImplCopyWithImpl(
      _$SortContactsImpl _value, $Res Function(_$SortContactsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sortField = null,
    Object? ascending = null,
  }) {
    return _then(_$SortContactsImpl(
      sortField: null == sortField
          ? _value.sortField
          : sortField // ignore: cast_nullable_to_non_nullable
              as ContactListSortField,
      ascending: null == ascending
          ? _value.ascending
          : ascending // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SortContactsImpl implements _SortContacts {
  const _$SortContactsImpl({required this.sortField, required this.ascending});

  @override
  final ContactListSortField sortField;
  @override
  final bool ascending;

  @override
  String toString() {
    return 'ContactListEvent.sortContacts(sortField: $sortField, ascending: $ascending)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SortContactsImpl &&
            (identical(other.sortField, sortField) ||
                other.sortField == sortField) &&
            (identical(other.ascending, ascending) ||
                other.ascending == ascending));
  }

  @override
  int get hashCode => Object.hash(runtimeType, sortField, ascending);

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SortContactsImplCopyWith<_$SortContactsImpl> get copyWith =>
      __$$SortContactsImplCopyWithImpl<_$SortContactsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadContacts,
    required TResult Function(int contactId) deleteContactFromList,
    required TResult Function(Contact contact) updateContactFromList,
    required TResult Function(ContactListSortField sortField, bool ascending)
        sortContacts,
    required TResult Function(String searchTerm) applySearch,
    required TResult Function(ContactListFilter filter) applyFilter,
    required TResult Function(List<int> contactIds) deleteContacts,
    required TResult Function(List<int> contactIds) markContactsAsContacted,
  }) {
    return sortContacts(sortField, ascending);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadContacts,
    TResult? Function(int contactId)? deleteContactFromList,
    TResult? Function(Contact contact)? updateContactFromList,
    TResult? Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult? Function(String searchTerm)? applySearch,
    TResult? Function(ContactListFilter filter)? applyFilter,
    TResult? Function(List<int> contactIds)? deleteContacts,
    TResult? Function(List<int> contactIds)? markContactsAsContacted,
  }) {
    return sortContacts?.call(sortField, ascending);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadContacts,
    TResult Function(int contactId)? deleteContactFromList,
    TResult Function(Contact contact)? updateContactFromList,
    TResult Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult Function(String searchTerm)? applySearch,
    TResult Function(ContactListFilter filter)? applyFilter,
    TResult Function(List<int> contactIds)? deleteContacts,
    TResult Function(List<int> contactIds)? markContactsAsContacted,
    required TResult orElse(),
  }) {
    if (sortContacts != null) {
      return sortContacts(sortField, ascending);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadContacts value) loadContacts,
    required TResult Function(_DeleteContactFromList value)
        deleteContactFromList,
    required TResult Function(_UpdateContactFromList value)
        updateContactFromList,
    required TResult Function(_SortContacts value) sortContacts,
    required TResult Function(_ApplySearch value) applySearch,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_DeleteContacts value) deleteContacts,
    required TResult Function(_MarkContactsAsContacted value)
        markContactsAsContacted,
  }) {
    return sortContacts(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadContacts value)? loadContacts,
    TResult? Function(_DeleteContactFromList value)? deleteContactFromList,
    TResult? Function(_UpdateContactFromList value)? updateContactFromList,
    TResult? Function(_SortContacts value)? sortContacts,
    TResult? Function(_ApplySearch value)? applySearch,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_DeleteContacts value)? deleteContacts,
    TResult? Function(_MarkContactsAsContacted value)? markContactsAsContacted,
  }) {
    return sortContacts?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadContacts value)? loadContacts,
    TResult Function(_DeleteContactFromList value)? deleteContactFromList,
    TResult Function(_UpdateContactFromList value)? updateContactFromList,
    TResult Function(_SortContacts value)? sortContacts,
    TResult Function(_ApplySearch value)? applySearch,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_DeleteContacts value)? deleteContacts,
    TResult Function(_MarkContactsAsContacted value)? markContactsAsContacted,
    required TResult orElse(),
  }) {
    if (sortContacts != null) {
      return sortContacts(this);
    }
    return orElse();
  }
}

abstract class _SortContacts implements ContactListEvent {
  const factory _SortContacts(
      {required final ContactListSortField sortField,
      required final bool ascending}) = _$SortContactsImpl;

  ContactListSortField get sortField;
  bool get ascending;

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SortContactsImplCopyWith<_$SortContactsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ApplySearchImplCopyWith<$Res> {
  factory _$$ApplySearchImplCopyWith(
          _$ApplySearchImpl value, $Res Function(_$ApplySearchImpl) then) =
      __$$ApplySearchImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String searchTerm});
}

/// @nodoc
class __$$ApplySearchImplCopyWithImpl<$Res>
    extends _$ContactListEventCopyWithImpl<$Res, _$ApplySearchImpl>
    implements _$$ApplySearchImplCopyWith<$Res> {
  __$$ApplySearchImplCopyWithImpl(
      _$ApplySearchImpl _value, $Res Function(_$ApplySearchImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchTerm = null,
  }) {
    return _then(_$ApplySearchImpl(
      searchTerm: null == searchTerm
          ? _value.searchTerm
          : searchTerm // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ApplySearchImpl implements _ApplySearch {
  const _$ApplySearchImpl({required this.searchTerm});

  @override
  final String searchTerm;

  @override
  String toString() {
    return 'ContactListEvent.applySearch(searchTerm: $searchTerm)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplySearchImpl &&
            (identical(other.searchTerm, searchTerm) ||
                other.searchTerm == searchTerm));
  }

  @override
  int get hashCode => Object.hash(runtimeType, searchTerm);

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplySearchImplCopyWith<_$ApplySearchImpl> get copyWith =>
      __$$ApplySearchImplCopyWithImpl<_$ApplySearchImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadContacts,
    required TResult Function(int contactId) deleteContactFromList,
    required TResult Function(Contact contact) updateContactFromList,
    required TResult Function(ContactListSortField sortField, bool ascending)
        sortContacts,
    required TResult Function(String searchTerm) applySearch,
    required TResult Function(ContactListFilter filter) applyFilter,
    required TResult Function(List<int> contactIds) deleteContacts,
    required TResult Function(List<int> contactIds) markContactsAsContacted,
  }) {
    return applySearch(searchTerm);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadContacts,
    TResult? Function(int contactId)? deleteContactFromList,
    TResult? Function(Contact contact)? updateContactFromList,
    TResult? Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult? Function(String searchTerm)? applySearch,
    TResult? Function(ContactListFilter filter)? applyFilter,
    TResult? Function(List<int> contactIds)? deleteContacts,
    TResult? Function(List<int> contactIds)? markContactsAsContacted,
  }) {
    return applySearch?.call(searchTerm);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadContacts,
    TResult Function(int contactId)? deleteContactFromList,
    TResult Function(Contact contact)? updateContactFromList,
    TResult Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult Function(String searchTerm)? applySearch,
    TResult Function(ContactListFilter filter)? applyFilter,
    TResult Function(List<int> contactIds)? deleteContacts,
    TResult Function(List<int> contactIds)? markContactsAsContacted,
    required TResult orElse(),
  }) {
    if (applySearch != null) {
      return applySearch(searchTerm);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadContacts value) loadContacts,
    required TResult Function(_DeleteContactFromList value)
        deleteContactFromList,
    required TResult Function(_UpdateContactFromList value)
        updateContactFromList,
    required TResult Function(_SortContacts value) sortContacts,
    required TResult Function(_ApplySearch value) applySearch,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_DeleteContacts value) deleteContacts,
    required TResult Function(_MarkContactsAsContacted value)
        markContactsAsContacted,
  }) {
    return applySearch(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadContacts value)? loadContacts,
    TResult? Function(_DeleteContactFromList value)? deleteContactFromList,
    TResult? Function(_UpdateContactFromList value)? updateContactFromList,
    TResult? Function(_SortContacts value)? sortContacts,
    TResult? Function(_ApplySearch value)? applySearch,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_DeleteContacts value)? deleteContacts,
    TResult? Function(_MarkContactsAsContacted value)? markContactsAsContacted,
  }) {
    return applySearch?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadContacts value)? loadContacts,
    TResult Function(_DeleteContactFromList value)? deleteContactFromList,
    TResult Function(_UpdateContactFromList value)? updateContactFromList,
    TResult Function(_SortContacts value)? sortContacts,
    TResult Function(_ApplySearch value)? applySearch,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_DeleteContacts value)? deleteContacts,
    TResult Function(_MarkContactsAsContacted value)? markContactsAsContacted,
    required TResult orElse(),
  }) {
    if (applySearch != null) {
      return applySearch(this);
    }
    return orElse();
  }
}

abstract class _ApplySearch implements ContactListEvent {
  const factory _ApplySearch({required final String searchTerm}) =
      _$ApplySearchImpl;

  String get searchTerm;

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplySearchImplCopyWith<_$ApplySearchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ApplyFilterImplCopyWith<$Res> {
  factory _$$ApplyFilterImplCopyWith(
          _$ApplyFilterImpl value, $Res Function(_$ApplyFilterImpl) then) =
      __$$ApplyFilterImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ContactListFilter filter});
}

/// @nodoc
class __$$ApplyFilterImplCopyWithImpl<$Res>
    extends _$ContactListEventCopyWithImpl<$Res, _$ApplyFilterImpl>
    implements _$$ApplyFilterImplCopyWith<$Res> {
  __$$ApplyFilterImplCopyWithImpl(
      _$ApplyFilterImpl _value, $Res Function(_$ApplyFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filter = null,
  }) {
    return _then(_$ApplyFilterImpl(
      filter: null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as ContactListFilter,
    ));
  }
}

/// @nodoc

class _$ApplyFilterImpl implements _ApplyFilter {
  const _$ApplyFilterImpl({required this.filter});

  @override
  final ContactListFilter filter;

  @override
  String toString() {
    return 'ContactListEvent.applyFilter(filter: $filter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplyFilterImpl &&
            (identical(other.filter, filter) || other.filter == filter));
  }

  @override
  int get hashCode => Object.hash(runtimeType, filter);

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplyFilterImplCopyWith<_$ApplyFilterImpl> get copyWith =>
      __$$ApplyFilterImplCopyWithImpl<_$ApplyFilterImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadContacts,
    required TResult Function(int contactId) deleteContactFromList,
    required TResult Function(Contact contact) updateContactFromList,
    required TResult Function(ContactListSortField sortField, bool ascending)
        sortContacts,
    required TResult Function(String searchTerm) applySearch,
    required TResult Function(ContactListFilter filter) applyFilter,
    required TResult Function(List<int> contactIds) deleteContacts,
    required TResult Function(List<int> contactIds) markContactsAsContacted,
  }) {
    return applyFilter(filter);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadContacts,
    TResult? Function(int contactId)? deleteContactFromList,
    TResult? Function(Contact contact)? updateContactFromList,
    TResult? Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult? Function(String searchTerm)? applySearch,
    TResult? Function(ContactListFilter filter)? applyFilter,
    TResult? Function(List<int> contactIds)? deleteContacts,
    TResult? Function(List<int> contactIds)? markContactsAsContacted,
  }) {
    return applyFilter?.call(filter);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadContacts,
    TResult Function(int contactId)? deleteContactFromList,
    TResult Function(Contact contact)? updateContactFromList,
    TResult Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult Function(String searchTerm)? applySearch,
    TResult Function(ContactListFilter filter)? applyFilter,
    TResult Function(List<int> contactIds)? deleteContacts,
    TResult Function(List<int> contactIds)? markContactsAsContacted,
    required TResult orElse(),
  }) {
    if (applyFilter != null) {
      return applyFilter(filter);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadContacts value) loadContacts,
    required TResult Function(_DeleteContactFromList value)
        deleteContactFromList,
    required TResult Function(_UpdateContactFromList value)
        updateContactFromList,
    required TResult Function(_SortContacts value) sortContacts,
    required TResult Function(_ApplySearch value) applySearch,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_DeleteContacts value) deleteContacts,
    required TResult Function(_MarkContactsAsContacted value)
        markContactsAsContacted,
  }) {
    return applyFilter(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadContacts value)? loadContacts,
    TResult? Function(_DeleteContactFromList value)? deleteContactFromList,
    TResult? Function(_UpdateContactFromList value)? updateContactFromList,
    TResult? Function(_SortContacts value)? sortContacts,
    TResult? Function(_ApplySearch value)? applySearch,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_DeleteContacts value)? deleteContacts,
    TResult? Function(_MarkContactsAsContacted value)? markContactsAsContacted,
  }) {
    return applyFilter?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadContacts value)? loadContacts,
    TResult Function(_DeleteContactFromList value)? deleteContactFromList,
    TResult Function(_UpdateContactFromList value)? updateContactFromList,
    TResult Function(_SortContacts value)? sortContacts,
    TResult Function(_ApplySearch value)? applySearch,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_DeleteContacts value)? deleteContacts,
    TResult Function(_MarkContactsAsContacted value)? markContactsAsContacted,
    required TResult orElse(),
  }) {
    if (applyFilter != null) {
      return applyFilter(this);
    }
    return orElse();
  }
}

abstract class _ApplyFilter implements ContactListEvent {
  const factory _ApplyFilter({required final ContactListFilter filter}) =
      _$ApplyFilterImpl;

  ContactListFilter get filter;

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplyFilterImplCopyWith<_$ApplyFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeleteContactsImplCopyWith<$Res> {
  factory _$$DeleteContactsImplCopyWith(_$DeleteContactsImpl value,
          $Res Function(_$DeleteContactsImpl) then) =
      __$$DeleteContactsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<int> contactIds});
}

/// @nodoc
class __$$DeleteContactsImplCopyWithImpl<$Res>
    extends _$ContactListEventCopyWithImpl<$Res, _$DeleteContactsImpl>
    implements _$$DeleteContactsImplCopyWith<$Res> {
  __$$DeleteContactsImplCopyWithImpl(
      _$DeleteContactsImpl _value, $Res Function(_$DeleteContactsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contactIds = null,
  }) {
    return _then(_$DeleteContactsImpl(
      contactIds: null == contactIds
          ? _value._contactIds
          : contactIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc

class _$DeleteContactsImpl implements _DeleteContacts {
  const _$DeleteContactsImpl({required final List<int> contactIds})
      : _contactIds = contactIds;

  final List<int> _contactIds;
  @override
  List<int> get contactIds {
    if (_contactIds is EqualUnmodifiableListView) return _contactIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contactIds);
  }

  @override
  String toString() {
    return 'ContactListEvent.deleteContacts(contactIds: $contactIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteContactsImpl &&
            const DeepCollectionEquality()
                .equals(other._contactIds, _contactIds));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_contactIds));

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteContactsImplCopyWith<_$DeleteContactsImpl> get copyWith =>
      __$$DeleteContactsImplCopyWithImpl<_$DeleteContactsImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadContacts,
    required TResult Function(int contactId) deleteContactFromList,
    required TResult Function(Contact contact) updateContactFromList,
    required TResult Function(ContactListSortField sortField, bool ascending)
        sortContacts,
    required TResult Function(String searchTerm) applySearch,
    required TResult Function(ContactListFilter filter) applyFilter,
    required TResult Function(List<int> contactIds) deleteContacts,
    required TResult Function(List<int> contactIds) markContactsAsContacted,
  }) {
    return deleteContacts(contactIds);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadContacts,
    TResult? Function(int contactId)? deleteContactFromList,
    TResult? Function(Contact contact)? updateContactFromList,
    TResult? Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult? Function(String searchTerm)? applySearch,
    TResult? Function(ContactListFilter filter)? applyFilter,
    TResult? Function(List<int> contactIds)? deleteContacts,
    TResult? Function(List<int> contactIds)? markContactsAsContacted,
  }) {
    return deleteContacts?.call(contactIds);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadContacts,
    TResult Function(int contactId)? deleteContactFromList,
    TResult Function(Contact contact)? updateContactFromList,
    TResult Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult Function(String searchTerm)? applySearch,
    TResult Function(ContactListFilter filter)? applyFilter,
    TResult Function(List<int> contactIds)? deleteContacts,
    TResult Function(List<int> contactIds)? markContactsAsContacted,
    required TResult orElse(),
  }) {
    if (deleteContacts != null) {
      return deleteContacts(contactIds);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadContacts value) loadContacts,
    required TResult Function(_DeleteContactFromList value)
        deleteContactFromList,
    required TResult Function(_UpdateContactFromList value)
        updateContactFromList,
    required TResult Function(_SortContacts value) sortContacts,
    required TResult Function(_ApplySearch value) applySearch,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_DeleteContacts value) deleteContacts,
    required TResult Function(_MarkContactsAsContacted value)
        markContactsAsContacted,
  }) {
    return deleteContacts(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadContacts value)? loadContacts,
    TResult? Function(_DeleteContactFromList value)? deleteContactFromList,
    TResult? Function(_UpdateContactFromList value)? updateContactFromList,
    TResult? Function(_SortContacts value)? sortContacts,
    TResult? Function(_ApplySearch value)? applySearch,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_DeleteContacts value)? deleteContacts,
    TResult? Function(_MarkContactsAsContacted value)? markContactsAsContacted,
  }) {
    return deleteContacts?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadContacts value)? loadContacts,
    TResult Function(_DeleteContactFromList value)? deleteContactFromList,
    TResult Function(_UpdateContactFromList value)? updateContactFromList,
    TResult Function(_SortContacts value)? sortContacts,
    TResult Function(_ApplySearch value)? applySearch,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_DeleteContacts value)? deleteContacts,
    TResult Function(_MarkContactsAsContacted value)? markContactsAsContacted,
    required TResult orElse(),
  }) {
    if (deleteContacts != null) {
      return deleteContacts(this);
    }
    return orElse();
  }
}

abstract class _DeleteContacts implements ContactListEvent {
  const factory _DeleteContacts({required final List<int> contactIds}) =
      _$DeleteContactsImpl;

  List<int> get contactIds;

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteContactsImplCopyWith<_$DeleteContactsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MarkContactsAsContactedImplCopyWith<$Res> {
  factory _$$MarkContactsAsContactedImplCopyWith(
          _$MarkContactsAsContactedImpl value,
          $Res Function(_$MarkContactsAsContactedImpl) then) =
      __$$MarkContactsAsContactedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<int> contactIds});
}

/// @nodoc
class __$$MarkContactsAsContactedImplCopyWithImpl<$Res>
    extends _$ContactListEventCopyWithImpl<$Res, _$MarkContactsAsContactedImpl>
    implements _$$MarkContactsAsContactedImplCopyWith<$Res> {
  __$$MarkContactsAsContactedImplCopyWithImpl(
      _$MarkContactsAsContactedImpl _value,
      $Res Function(_$MarkContactsAsContactedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contactIds = null,
  }) {
    return _then(_$MarkContactsAsContactedImpl(
      contactIds: null == contactIds
          ? _value._contactIds
          : contactIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc

class _$MarkContactsAsContactedImpl implements _MarkContactsAsContacted {
  const _$MarkContactsAsContactedImpl({required final List<int> contactIds})
      : _contactIds = contactIds;

  final List<int> _contactIds;
  @override
  List<int> get contactIds {
    if (_contactIds is EqualUnmodifiableListView) return _contactIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contactIds);
  }

  @override
  String toString() {
    return 'ContactListEvent.markContactsAsContacted(contactIds: $contactIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarkContactsAsContactedImpl &&
            const DeepCollectionEquality()
                .equals(other._contactIds, _contactIds));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_contactIds));

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarkContactsAsContactedImplCopyWith<_$MarkContactsAsContactedImpl>
      get copyWith => __$$MarkContactsAsContactedImplCopyWithImpl<
          _$MarkContactsAsContactedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadContacts,
    required TResult Function(int contactId) deleteContactFromList,
    required TResult Function(Contact contact) updateContactFromList,
    required TResult Function(ContactListSortField sortField, bool ascending)
        sortContacts,
    required TResult Function(String searchTerm) applySearch,
    required TResult Function(ContactListFilter filter) applyFilter,
    required TResult Function(List<int> contactIds) deleteContacts,
    required TResult Function(List<int> contactIds) markContactsAsContacted,
  }) {
    return markContactsAsContacted(contactIds);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadContacts,
    TResult? Function(int contactId)? deleteContactFromList,
    TResult? Function(Contact contact)? updateContactFromList,
    TResult? Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult? Function(String searchTerm)? applySearch,
    TResult? Function(ContactListFilter filter)? applyFilter,
    TResult? Function(List<int> contactIds)? deleteContacts,
    TResult? Function(List<int> contactIds)? markContactsAsContacted,
  }) {
    return markContactsAsContacted?.call(contactIds);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadContacts,
    TResult Function(int contactId)? deleteContactFromList,
    TResult Function(Contact contact)? updateContactFromList,
    TResult Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult Function(String searchTerm)? applySearch,
    TResult Function(ContactListFilter filter)? applyFilter,
    TResult Function(List<int> contactIds)? deleteContacts,
    TResult Function(List<int> contactIds)? markContactsAsContacted,
    required TResult orElse(),
  }) {
    if (markContactsAsContacted != null) {
      return markContactsAsContacted(contactIds);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadContacts value) loadContacts,
    required TResult Function(_DeleteContactFromList value)
        deleteContactFromList,
    required TResult Function(_UpdateContactFromList value)
        updateContactFromList,
    required TResult Function(_SortContacts value) sortContacts,
    required TResult Function(_ApplySearch value) applySearch,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_DeleteContacts value) deleteContacts,
    required TResult Function(_MarkContactsAsContacted value)
        markContactsAsContacted,
  }) {
    return markContactsAsContacted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadContacts value)? loadContacts,
    TResult? Function(_DeleteContactFromList value)? deleteContactFromList,
    TResult? Function(_UpdateContactFromList value)? updateContactFromList,
    TResult? Function(_SortContacts value)? sortContacts,
    TResult? Function(_ApplySearch value)? applySearch,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_DeleteContacts value)? deleteContacts,
    TResult? Function(_MarkContactsAsContacted value)? markContactsAsContacted,
  }) {
    return markContactsAsContacted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadContacts value)? loadContacts,
    TResult Function(_DeleteContactFromList value)? deleteContactFromList,
    TResult Function(_UpdateContactFromList value)? updateContactFromList,
    TResult Function(_SortContacts value)? sortContacts,
    TResult Function(_ApplySearch value)? applySearch,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_DeleteContacts value)? deleteContacts,
    TResult Function(_MarkContactsAsContacted value)? markContactsAsContacted,
    required TResult orElse(),
  }) {
    if (markContactsAsContacted != null) {
      return markContactsAsContacted(this);
    }
    return orElse();
  }
}

abstract class _MarkContactsAsContacted implements ContactListEvent {
  const factory _MarkContactsAsContacted(
      {required final List<int> contactIds}) = _$MarkContactsAsContactedImpl;

  List<int> get contactIds;

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarkContactsAsContactedImplCopyWith<_$MarkContactsAsContactedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ContactListState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Contact> originalContacts,
            List<Contact> displayedContacts,
            ContactListSortField sortField,
            bool ascending,
            String searchTerm,
            ContactListFilter currentFilter)
        loaded,
    required TResult Function() empty,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Contact> originalContacts,
            List<Contact> displayedContacts,
            ContactListSortField sortField,
            bool ascending,
            String searchTerm,
            ContactListFilter currentFilter)?
        loaded,
    TResult? Function()? empty,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Contact> originalContacts,
            List<Contact> displayedContacts,
            ContactListSortField sortField,
            bool ascending,
            String searchTerm,
            ContactListFilter currentFilter)?
        loaded,
    TResult Function()? empty,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Empty value) empty,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Empty value)? empty,
    TResult? Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Empty value)? empty,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactListStateCopyWith<$Res> {
  factory $ContactListStateCopyWith(
          ContactListState value, $Res Function(ContactListState) then) =
      _$ContactListStateCopyWithImpl<$Res, ContactListState>;
}

/// @nodoc
class _$ContactListStateCopyWithImpl<$Res, $Val extends ContactListState>
    implements $ContactListStateCopyWith<$Res> {
  _$ContactListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactListState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$ContactListStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactListState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'ContactListState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Contact> originalContacts,
            List<Contact> displayedContacts,
            ContactListSortField sortField,
            bool ascending,
            String searchTerm,
            ContactListFilter currentFilter)
        loaded,
    required TResult Function() empty,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Contact> originalContacts,
            List<Contact> displayedContacts,
            ContactListSortField sortField,
            bool ascending,
            String searchTerm,
            ContactListFilter currentFilter)?
        loaded,
    TResult? Function()? empty,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Contact> originalContacts,
            List<Contact> displayedContacts,
            ContactListSortField sortField,
            bool ascending,
            String searchTerm,
            ContactListFilter currentFilter)?
        loaded,
    TResult Function()? empty,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Empty value) empty,
    required TResult Function(_Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Empty value)? empty,
    TResult? Function(_Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Empty value)? empty,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements ContactListState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl value, $Res Function(_$LoadingImpl) then) =
      __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$ContactListStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactListState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'ContactListState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Contact> originalContacts,
            List<Contact> displayedContacts,
            ContactListSortField sortField,
            bool ascending,
            String searchTerm,
            ContactListFilter currentFilter)
        loaded,
    required TResult Function() empty,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Contact> originalContacts,
            List<Contact> displayedContacts,
            ContactListSortField sortField,
            bool ascending,
            String searchTerm,
            ContactListFilter currentFilter)?
        loaded,
    TResult? Function()? empty,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Contact> originalContacts,
            List<Contact> displayedContacts,
            ContactListSortField sortField,
            bool ascending,
            String searchTerm,
            ContactListFilter currentFilter)?
        loaded,
    TResult Function()? empty,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Empty value) empty,
    required TResult Function(_Error value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Empty value)? empty,
    TResult? Function(_Error value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Empty value)? empty,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements ContactListState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$LoadedImplCopyWith<$Res> {
  factory _$$LoadedImplCopyWith(
          _$LoadedImpl value, $Res Function(_$LoadedImpl) then) =
      __$$LoadedImplCopyWithImpl<$Res>;
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
class __$$LoadedImplCopyWithImpl<$Res>
    extends _$ContactListStateCopyWithImpl<$Res, _$LoadedImpl>
    implements _$$LoadedImplCopyWith<$Res> {
  __$$LoadedImplCopyWithImpl(
      _$LoadedImpl _value, $Res Function(_$LoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalContacts = null,
    Object? displayedContacts = null,
    Object? sortField = null,
    Object? ascending = null,
    Object? searchTerm = null,
    Object? currentFilter = null,
  }) {
    return _then(_$LoadedImpl(
      originalContacts: null == originalContacts
          ? _value._originalContacts
          : originalContacts // ignore: cast_nullable_to_non_nullable
              as List<Contact>,
      displayedContacts: null == displayedContacts
          ? _value._displayedContacts
          : displayedContacts // ignore: cast_nullable_to_non_nullable
              as List<Contact>,
      sortField: null == sortField
          ? _value.sortField
          : sortField // ignore: cast_nullable_to_non_nullable
              as ContactListSortField,
      ascending: null == ascending
          ? _value.ascending
          : ascending // ignore: cast_nullable_to_non_nullable
              as bool,
      searchTerm: null == searchTerm
          ? _value.searchTerm
          : searchTerm // ignore: cast_nullable_to_non_nullable
              as String,
      currentFilter: null == currentFilter
          ? _value.currentFilter
          : currentFilter // ignore: cast_nullable_to_non_nullable
              as ContactListFilter,
    ));
  }
}

/// @nodoc

class _$LoadedImpl implements _Loaded {
  const _$LoadedImpl(
      {required final List<Contact> originalContacts,
      required final List<Contact> displayedContacts,
      required this.sortField,
      required this.ascending,
      required this.searchTerm,
      required this.currentFilter})
      : _originalContacts = originalContacts,
        _displayedContacts = displayedContacts;

  final List<Contact> _originalContacts;
  @override
  List<Contact> get originalContacts {
    if (_originalContacts is EqualUnmodifiableListView)
      return _originalContacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_originalContacts);
  }

// Keep the full list
  final List<Contact> _displayedContacts;
// Keep the full list
  @override
  List<Contact> get displayedContacts {
    if (_displayedContacts is EqualUnmodifiableListView)
      return _displayedContacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_displayedContacts);
  }

// List after filtering/sorting
  @override
  final ContactListSortField sortField;
  @override
  final bool ascending;
  @override
  final String searchTerm;
  @override
  final ContactListFilter currentFilter;

  @override
  String toString() {
    return 'ContactListState.loaded(originalContacts: $originalContacts, displayedContacts: $displayedContacts, sortField: $sortField, ascending: $ascending, searchTerm: $searchTerm, currentFilter: $currentFilter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadedImpl &&
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

  /// Create a copy of ContactListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      __$$LoadedImplCopyWithImpl<_$LoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Contact> originalContacts,
            List<Contact> displayedContacts,
            ContactListSortField sortField,
            bool ascending,
            String searchTerm,
            ContactListFilter currentFilter)
        loaded,
    required TResult Function() empty,
    required TResult Function(String message) error,
  }) {
    return loaded(originalContacts, displayedContacts, sortField, ascending,
        searchTerm, currentFilter);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Contact> originalContacts,
            List<Contact> displayedContacts,
            ContactListSortField sortField,
            bool ascending,
            String searchTerm,
            ContactListFilter currentFilter)?
        loaded,
    TResult? Function()? empty,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(originalContacts, displayedContacts, sortField,
        ascending, searchTerm, currentFilter);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Contact> originalContacts,
            List<Contact> displayedContacts,
            ContactListSortField sortField,
            bool ascending,
            String searchTerm,
            ContactListFilter currentFilter)?
        loaded,
    TResult Function()? empty,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(originalContacts, displayedContacts, sortField, ascending,
          searchTerm, currentFilter);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Empty value) empty,
    required TResult Function(_Error value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Empty value)? empty,
    TResult? Function(_Error value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Empty value)? empty,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _Loaded implements ContactListState {
  const factory _Loaded(
      {required final List<Contact> originalContacts,
      required final List<Contact> displayedContacts,
      required final ContactListSortField sortField,
      required final bool ascending,
      required final String searchTerm,
      required final ContactListFilter currentFilter}) = _$LoadedImpl;

  List<Contact> get originalContacts; // Keep the full list
  List<Contact> get displayedContacts; // List after filtering/sorting
  ContactListSortField get sortField;
  bool get ascending;
  String get searchTerm;
  ContactListFilter get currentFilter;

  /// Create a copy of ContactListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EmptyImplCopyWith<$Res> {
  factory _$$EmptyImplCopyWith(
          _$EmptyImpl value, $Res Function(_$EmptyImpl) then) =
      __$$EmptyImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$EmptyImplCopyWithImpl<$Res>
    extends _$ContactListStateCopyWithImpl<$Res, _$EmptyImpl>
    implements _$$EmptyImplCopyWith<$Res> {
  __$$EmptyImplCopyWithImpl(
      _$EmptyImpl _value, $Res Function(_$EmptyImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactListState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$EmptyImpl implements _Empty {
  const _$EmptyImpl();

  @override
  String toString() {
    return 'ContactListState.empty()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$EmptyImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Contact> originalContacts,
            List<Contact> displayedContacts,
            ContactListSortField sortField,
            bool ascending,
            String searchTerm,
            ContactListFilter currentFilter)
        loaded,
    required TResult Function() empty,
    required TResult Function(String message) error,
  }) {
    return empty();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Contact> originalContacts,
            List<Contact> displayedContacts,
            ContactListSortField sortField,
            bool ascending,
            String searchTerm,
            ContactListFilter currentFilter)?
        loaded,
    TResult? Function()? empty,
    TResult? Function(String message)? error,
  }) {
    return empty?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Contact> originalContacts,
            List<Contact> displayedContacts,
            ContactListSortField sortField,
            bool ascending,
            String searchTerm,
            ContactListFilter currentFilter)?
        loaded,
    TResult Function()? empty,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Empty value) empty,
    required TResult Function(_Error value) error,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Empty value)? empty,
    TResult? Function(_Error value)? error,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Empty value)? empty,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class _Empty implements ContactListState {
  const factory _Empty() = _$EmptyImpl;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$ContactListStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'ContactListState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ContactListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Contact> originalContacts,
            List<Contact> displayedContacts,
            ContactListSortField sortField,
            bool ascending,
            String searchTerm,
            ContactListFilter currentFilter)
        loaded,
    required TResult Function() empty,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Contact> originalContacts,
            List<Contact> displayedContacts,
            ContactListSortField sortField,
            bool ascending,
            String searchTerm,
            ContactListFilter currentFilter)?
        loaded,
    TResult? Function()? empty,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Contact> originalContacts,
            List<Contact> displayedContacts,
            ContactListSortField sortField,
            bool ascending,
            String searchTerm,
            ContactListFilter currentFilter)?
        loaded,
    TResult Function()? empty,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Empty value) empty,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Empty value)? empty,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Empty value)? empty,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements ContactListState {
  const factory _Error(final String message) = _$ErrorImpl;

  String get message;

  /// Create a copy of ContactListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
