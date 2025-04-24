// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_details_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContactDetailsEvent {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ContactDetailsEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ContactDetailsEvent()';
  }
}

/// @nodoc
class $ContactDetailsEventCopyWith<$Res> {
  $ContactDetailsEventCopyWith(
      ContactDetailsEvent _, $Res Function(ContactDetailsEvent) __);
}

/// @nodoc

class _LoadContact implements ContactDetailsEvent {
  const _LoadContact({required this.contactId});

  final int contactId;

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LoadContactCopyWith<_LoadContact> get copyWith =>
      __$LoadContactCopyWithImpl<_LoadContact>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LoadContact &&
            (identical(other.contactId, contactId) ||
                other.contactId == contactId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, contactId);

  @override
  String toString() {
    return 'ContactDetailsEvent.loadContact(contactId: $contactId)';
  }
}

/// @nodoc
abstract mixin class _$LoadContactCopyWith<$Res>
    implements $ContactDetailsEventCopyWith<$Res> {
  factory _$LoadContactCopyWith(
          _LoadContact value, $Res Function(_LoadContact) _then) =
      __$LoadContactCopyWithImpl;
  @useResult
  $Res call({int contactId});
}

/// @nodoc
class __$LoadContactCopyWithImpl<$Res> implements _$LoadContactCopyWith<$Res> {
  __$LoadContactCopyWithImpl(this._self, this._then);

  final _LoadContact _self;
  final $Res Function(_LoadContact) _then;

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? contactId = null,
  }) {
    return _then(_LoadContact(
      contactId: null == contactId
          ? _self.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _SaveContact implements ContactDetailsEvent {
  const _SaveContact({required this.contact});

  final Contact contact;

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SaveContactCopyWith<_SaveContact> get copyWith =>
      __$SaveContactCopyWithImpl<_SaveContact>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SaveContact &&
            (identical(other.contact, contact) || other.contact == contact));
  }

  @override
  int get hashCode => Object.hash(runtimeType, contact);

  @override
  String toString() {
    return 'ContactDetailsEvent.saveContact(contact: $contact)';
  }
}

/// @nodoc
abstract mixin class _$SaveContactCopyWith<$Res>
    implements $ContactDetailsEventCopyWith<$Res> {
  factory _$SaveContactCopyWith(
          _SaveContact value, $Res Function(_SaveContact) _then) =
      __$SaveContactCopyWithImpl;
  @useResult
  $Res call({Contact contact});

  $ContactCopyWith<$Res> get contact;
}

/// @nodoc
class __$SaveContactCopyWithImpl<$Res> implements _$SaveContactCopyWith<$Res> {
  __$SaveContactCopyWithImpl(this._self, this._then);

  final _SaveContact _self;
  final $Res Function(_SaveContact) _then;

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? contact = null,
  }) {
    return _then(_SaveContact(
      contact: null == contact
          ? _self.contact
          : contact // ignore: cast_nullable_to_non_nullable
              as Contact,
    ));
  }

  /// Create a copy of ContactDetailsEvent
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

class _UpdateContactLocally implements ContactDetailsEvent {
  const _UpdateContactLocally({required this.contact});

  final Contact contact;

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UpdateContactLocallyCopyWith<_UpdateContactLocally> get copyWith =>
      __$UpdateContactLocallyCopyWithImpl<_UpdateContactLocally>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UpdateContactLocally &&
            (identical(other.contact, contact) || other.contact == contact));
  }

  @override
  int get hashCode => Object.hash(runtimeType, contact);

  @override
  String toString() {
    return 'ContactDetailsEvent.updateContactLocally(contact: $contact)';
  }
}

/// @nodoc
abstract mixin class _$UpdateContactLocallyCopyWith<$Res>
    implements $ContactDetailsEventCopyWith<$Res> {
  factory _$UpdateContactLocallyCopyWith(_UpdateContactLocally value,
          $Res Function(_UpdateContactLocally) _then) =
      __$UpdateContactLocallyCopyWithImpl;
  @useResult
  $Res call({Contact contact});

  $ContactCopyWith<$Res> get contact;
}

/// @nodoc
class __$UpdateContactLocallyCopyWithImpl<$Res>
    implements _$UpdateContactLocallyCopyWith<$Res> {
  __$UpdateContactLocallyCopyWithImpl(this._self, this._then);

  final _UpdateContactLocally _self;
  final $Res Function(_UpdateContactLocally) _then;

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? contact = null,
  }) {
    return _then(_UpdateContactLocally(
      contact: null == contact
          ? _self.contact
          : contact // ignore: cast_nullable_to_non_nullable
              as Contact,
    ));
  }

  /// Create a copy of ContactDetailsEvent
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

class _AddContact implements ContactDetailsEvent {
  const _AddContact({required this.contact});

  final Contact contact;

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AddContactCopyWith<_AddContact> get copyWith =>
      __$AddContactCopyWithImpl<_AddContact>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AddContact &&
            (identical(other.contact, contact) || other.contact == contact));
  }

  @override
  int get hashCode => Object.hash(runtimeType, contact);

  @override
  String toString() {
    return 'ContactDetailsEvent.addContact(contact: $contact)';
  }
}

/// @nodoc
abstract mixin class _$AddContactCopyWith<$Res>
    implements $ContactDetailsEventCopyWith<$Res> {
  factory _$AddContactCopyWith(
          _AddContact value, $Res Function(_AddContact) _then) =
      __$AddContactCopyWithImpl;
  @useResult
  $Res call({Contact contact});

  $ContactCopyWith<$Res> get contact;
}

/// @nodoc
class __$AddContactCopyWithImpl<$Res> implements _$AddContactCopyWith<$Res> {
  __$AddContactCopyWithImpl(this._self, this._then);

  final _AddContact _self;
  final $Res Function(_AddContact) _then;

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? contact = null,
  }) {
    return _then(_AddContact(
      contact: null == contact
          ? _self.contact
          : contact // ignore: cast_nullable_to_non_nullable
              as Contact,
    ));
  }

  /// Create a copy of ContactDetailsEvent
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

class _ClearContact implements ContactDetailsEvent {
  const _ClearContact();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _ClearContact);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ContactDetailsEvent.clearContact()';
  }
}

/// @nodoc

class _DeleteContact implements ContactDetailsEvent {
  const _DeleteContact({required this.contactId});

  final int contactId;

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DeleteContactCopyWith<_DeleteContact> get copyWith =>
      __$DeleteContactCopyWithImpl<_DeleteContact>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DeleteContact &&
            (identical(other.contactId, contactId) ||
                other.contactId == contactId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, contactId);

  @override
  String toString() {
    return 'ContactDetailsEvent.deleteContact(contactId: $contactId)';
  }
}

/// @nodoc
abstract mixin class _$DeleteContactCopyWith<$Res>
    implements $ContactDetailsEventCopyWith<$Res> {
  factory _$DeleteContactCopyWith(
          _DeleteContact value, $Res Function(_DeleteContact) _then) =
      __$DeleteContactCopyWithImpl;
  @useResult
  $Res call({int contactId});
}

/// @nodoc
class __$DeleteContactCopyWithImpl<$Res>
    implements _$DeleteContactCopyWith<$Res> {
  __$DeleteContactCopyWithImpl(this._self, this._then);

  final _DeleteContact _self;
  final $Res Function(_DeleteContact) _then;

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? contactId = null,
  }) {
    return _then(_DeleteContact(
      contactId: null == contactId
          ? _self.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$ContactDetailsState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ContactDetailsState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ContactDetailsState()';
  }
}

/// @nodoc
class $ContactDetailsStateCopyWith<$Res> {
  $ContactDetailsStateCopyWith(
      ContactDetailsState _, $Res Function(ContactDetailsState) __);
}

/// @nodoc

class _Initial implements ContactDetailsState {
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
    return 'ContactDetailsState.initial()';
  }
}

/// @nodoc

class _Loading implements ContactDetailsState {
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
    return 'ContactDetailsState.loading()';
  }
}

/// @nodoc

class _Loaded implements ContactDetailsState {
  const _Loaded(this.contact);

  final Contact contact;

  /// Create a copy of ContactDetailsState
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
            (identical(other.contact, contact) || other.contact == contact));
  }

  @override
  int get hashCode => Object.hash(runtimeType, contact);

  @override
  String toString() {
    return 'ContactDetailsState.loaded(contact: $contact)';
  }
}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res>
    implements $ContactDetailsStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) =
      __$LoadedCopyWithImpl;
  @useResult
  $Res call({Contact contact});

  $ContactCopyWith<$Res> get contact;
}

/// @nodoc
class __$LoadedCopyWithImpl<$Res> implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

  /// Create a copy of ContactDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? contact = null,
  }) {
    return _then(_Loaded(
      null == contact
          ? _self.contact
          : contact // ignore: cast_nullable_to_non_nullable
              as Contact,
    ));
  }

  /// Create a copy of ContactDetailsState
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

class _Cleared implements ContactDetailsState {
  const _Cleared();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Cleared);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ContactDetailsState.cleared()';
  }
}

/// @nodoc

class _Error implements ContactDetailsState {
  const _Error(this.message);

  final String message;

  /// Create a copy of ContactDetailsState
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
    return 'ContactDetailsState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res>
    implements $ContactDetailsStateCopyWith<$Res> {
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

  /// Create a copy of ContactDetailsState
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
