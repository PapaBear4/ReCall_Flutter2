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
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadContacts,
    TResult? Function(int contactId)? deleteContactFromList,
    TResult? Function(Contact contact)? updateContactFromList,
    TResult? Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadContacts,
    TResult Function(int contactId)? deleteContactFromList,
    TResult Function(Contact contact)? updateContactFromList,
    TResult Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
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
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadContacts value)? loadContacts,
    TResult? Function(_DeleteContactFromList value)? deleteContactFromList,
    TResult? Function(_UpdateContactFromList value)? updateContactFromList,
    TResult? Function(_SortContacts value)? sortContacts,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadContacts value)? loadContacts,
    TResult Function(_DeleteContactFromList value)? deleteContactFromList,
    TResult Function(_UpdateContactFromList value)? updateContactFromList,
    TResult Function(_SortContacts value)? sortContacts,
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
      null == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$DeleteContactFromListImpl implements _DeleteContactFromList {
  const _$DeleteContactFromListImpl(this.contactId);

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
    required TResult orElse(),
  }) {
    if (deleteContactFromList != null) {
      return deleteContactFromList(this);
    }
    return orElse();
  }
}

abstract class _DeleteContactFromList implements ContactListEvent {
  const factory _DeleteContactFromList(final int contactId) =
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
      null == contact
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
  const _$UpdateContactFromListImpl(this.contact);

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
    required TResult orElse(),
  }) {
    if (updateContactFromList != null) {
      return updateContactFromList(this);
    }
    return orElse();
  }
}

abstract class _UpdateContactFromList implements ContactListEvent {
  const factory _UpdateContactFromList(final Contact contact) =
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
      null == sortField
          ? _value.sortField
          : sortField // ignore: cast_nullable_to_non_nullable
              as ContactListSortField,
      null == ascending
          ? _value.ascending
          : ascending // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SortContactsImpl implements _SortContacts {
  const _$SortContactsImpl(this.sortField, this.ascending);

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
          final ContactListSortField sortField, final bool ascending) =
      _$SortContactsImpl;

  ContactListSortField get sortField;
  bool get ascending;

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SortContactsImplCopyWith<_$SortContactsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ContactListState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() empty,
    required TResult Function() loading,
    required TResult Function(List<Contact> contacts,
            ContactListSortField sortField, bool ascending)
        loaded,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? empty,
    TResult? Function()? loading,
    TResult? Function(List<Contact> contacts, ContactListSortField sortField,
            bool ascending)?
        loaded,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? empty,
    TResult Function()? loading,
    TResult Function(List<Contact> contacts, ContactListSortField sortField,
            bool ascending)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Empty value) empty,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Empty value)? empty,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Empty value)? empty,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
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
    required TResult Function() empty,
    required TResult Function() loading,
    required TResult Function(List<Contact> contacts,
            ContactListSortField sortField, bool ascending)
        loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? empty,
    TResult? Function()? loading,
    TResult? Function(List<Contact> contacts, ContactListSortField sortField,
            bool ascending)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? empty,
    TResult Function()? loading,
    TResult Function(List<Contact> contacts, ContactListSortField sortField,
            bool ascending)?
        loaded,
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
    required TResult Function(_Empty value) empty,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Empty value)? empty,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Empty value)? empty,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
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
    required TResult Function() empty,
    required TResult Function() loading,
    required TResult Function(List<Contact> contacts,
            ContactListSortField sortField, bool ascending)
        loaded,
    required TResult Function(String message) error,
  }) {
    return empty();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? empty,
    TResult? Function()? loading,
    TResult? Function(List<Contact> contacts, ContactListSortField sortField,
            bool ascending)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return empty?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? empty,
    TResult Function()? loading,
    TResult Function(List<Contact> contacts, ContactListSortField sortField,
            bool ascending)?
        loaded,
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
    required TResult Function(_Empty value) empty,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Empty value)? empty,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Empty value)? empty,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
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
    required TResult Function() empty,
    required TResult Function() loading,
    required TResult Function(List<Contact> contacts,
            ContactListSortField sortField, bool ascending)
        loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? empty,
    TResult? Function()? loading,
    TResult? Function(List<Contact> contacts, ContactListSortField sortField,
            bool ascending)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? empty,
    TResult Function()? loading,
    TResult Function(List<Contact> contacts, ContactListSortField sortField,
            bool ascending)?
        loaded,
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
    required TResult Function(_Empty value) empty,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Empty value)? empty,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Empty value)? empty,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
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
      {List<Contact> contacts, ContactListSortField sortField, bool ascending});
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
    Object? contacts = null,
    Object? sortField = null,
    Object? ascending = null,
  }) {
    return _then(_$LoadedImpl(
      contacts: null == contacts
          ? _value._contacts
          : contacts // ignore: cast_nullable_to_non_nullable
              as List<Contact>,
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

class _$LoadedImpl implements _Loaded {
  const _$LoadedImpl(
      {required final List<Contact> contacts,
      this.sortField = ContactListSortField.lastName,
      this.ascending = true})
      : _contacts = contacts;

  final List<Contact> _contacts;
  @override
  List<Contact> get contacts {
    if (_contacts is EqualUnmodifiableListView) return _contacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contacts);
  }

  @override
  @JsonKey()
  final ContactListSortField sortField;
  @override
  @JsonKey()
  final bool ascending;

  @override
  String toString() {
    return 'ContactListState.loaded(contacts: $contacts, sortField: $sortField, ascending: $ascending)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadedImpl &&
            const DeepCollectionEquality().equals(other._contacts, _contacts) &&
            (identical(other.sortField, sortField) ||
                other.sortField == sortField) &&
            (identical(other.ascending, ascending) ||
                other.ascending == ascending));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_contacts), sortField, ascending);

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
    required TResult Function() empty,
    required TResult Function() loading,
    required TResult Function(List<Contact> contacts,
            ContactListSortField sortField, bool ascending)
        loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(contacts, sortField, ascending);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? empty,
    TResult? Function()? loading,
    TResult? Function(List<Contact> contacts, ContactListSortField sortField,
            bool ascending)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(contacts, sortField, ascending);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? empty,
    TResult Function()? loading,
    TResult Function(List<Contact> contacts, ContactListSortField sortField,
            bool ascending)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(contacts, sortField, ascending);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Empty value) empty,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Empty value)? empty,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Empty value)? empty,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
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
      {required final List<Contact> contacts,
      final ContactListSortField sortField,
      final bool ascending}) = _$LoadedImpl;

  List<Contact> get contacts;
  ContactListSortField get sortField;
  bool get ascending;

  /// Create a copy of ContactListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
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
    required TResult Function() empty,
    required TResult Function() loading,
    required TResult Function(List<Contact> contacts,
            ContactListSortField sortField, bool ascending)
        loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? empty,
    TResult? Function()? loading,
    TResult? Function(List<Contact> contacts, ContactListSortField sortField,
            bool ascending)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? empty,
    TResult Function()? loading,
    TResult Function(List<Contact> contacts, ContactListSortField sortField,
            bool ascending)?
        loaded,
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
    required TResult Function(_Empty value) empty,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Empty value)? empty,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Empty value)? empty,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
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
