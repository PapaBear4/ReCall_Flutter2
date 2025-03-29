// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_details_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ContactDetailsEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int contactId) loadContact,
    required TResult Function(Contact contact) saveContact,
    required TResult Function(Contact contact) updateContactLocally,
    required TResult Function(Contact contact) addContact,
    required TResult Function() clearContact,
    required TResult Function(int contactId) deleteContact,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int contactId)? loadContact,
    TResult? Function(Contact contact)? saveContact,
    TResult? Function(Contact contact)? updateContactLocally,
    TResult? Function(Contact contact)? addContact,
    TResult? Function()? clearContact,
    TResult? Function(int contactId)? deleteContact,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int contactId)? loadContact,
    TResult Function(Contact contact)? saveContact,
    TResult Function(Contact contact)? updateContactLocally,
    TResult Function(Contact contact)? addContact,
    TResult Function()? clearContact,
    TResult Function(int contactId)? deleteContact,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadContact value) loadContact,
    required TResult Function(_SaveContact value) saveContact,
    required TResult Function(_UpdateContactLocally value) updateContactLocally,
    required TResult Function(_AddContact value) addContact,
    required TResult Function(_ClearContact value) clearContact,
    required TResult Function(_DeleteContact value) deleteContact,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadContact value)? loadContact,
    TResult? Function(_SaveContact value)? saveContact,
    TResult? Function(_UpdateContactLocally value)? updateContactLocally,
    TResult? Function(_AddContact value)? addContact,
    TResult? Function(_ClearContact value)? clearContact,
    TResult? Function(_DeleteContact value)? deleteContact,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadContact value)? loadContact,
    TResult Function(_SaveContact value)? saveContact,
    TResult Function(_UpdateContactLocally value)? updateContactLocally,
    TResult Function(_AddContact value)? addContact,
    TResult Function(_ClearContact value)? clearContact,
    TResult Function(_DeleteContact value)? deleteContact,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactDetailsEventCopyWith<$Res> {
  factory $ContactDetailsEventCopyWith(
          ContactDetailsEvent value, $Res Function(ContactDetailsEvent) then) =
      _$ContactDetailsEventCopyWithImpl<$Res, ContactDetailsEvent>;
}

/// @nodoc
class _$ContactDetailsEventCopyWithImpl<$Res, $Val extends ContactDetailsEvent>
    implements $ContactDetailsEventCopyWith<$Res> {
  _$ContactDetailsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoadContactImplCopyWith<$Res> {
  factory _$$LoadContactImplCopyWith(
          _$LoadContactImpl value, $Res Function(_$LoadContactImpl) then) =
      __$$LoadContactImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int contactId});
}

/// @nodoc
class __$$LoadContactImplCopyWithImpl<$Res>
    extends _$ContactDetailsEventCopyWithImpl<$Res, _$LoadContactImpl>
    implements _$$LoadContactImplCopyWith<$Res> {
  __$$LoadContactImplCopyWithImpl(
      _$LoadContactImpl _value, $Res Function(_$LoadContactImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contactId = null,
  }) {
    return _then(_$LoadContactImpl(
      contactId: null == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$LoadContactImpl implements _LoadContact {
  const _$LoadContactImpl({required this.contactId});

  @override
  final int contactId;

  @override
  String toString() {
    return 'ContactDetailsEvent.loadContact(contactId: $contactId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadContactImpl &&
            (identical(other.contactId, contactId) ||
                other.contactId == contactId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, contactId);

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadContactImplCopyWith<_$LoadContactImpl> get copyWith =>
      __$$LoadContactImplCopyWithImpl<_$LoadContactImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int contactId) loadContact,
    required TResult Function(Contact contact) saveContact,
    required TResult Function(Contact contact) updateContactLocally,
    required TResult Function(Contact contact) addContact,
    required TResult Function() clearContact,
    required TResult Function(int contactId) deleteContact,
  }) {
    return loadContact(contactId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int contactId)? loadContact,
    TResult? Function(Contact contact)? saveContact,
    TResult? Function(Contact contact)? updateContactLocally,
    TResult? Function(Contact contact)? addContact,
    TResult? Function()? clearContact,
    TResult? Function(int contactId)? deleteContact,
  }) {
    return loadContact?.call(contactId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int contactId)? loadContact,
    TResult Function(Contact contact)? saveContact,
    TResult Function(Contact contact)? updateContactLocally,
    TResult Function(Contact contact)? addContact,
    TResult Function()? clearContact,
    TResult Function(int contactId)? deleteContact,
    required TResult orElse(),
  }) {
    if (loadContact != null) {
      return loadContact(contactId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadContact value) loadContact,
    required TResult Function(_SaveContact value) saveContact,
    required TResult Function(_UpdateContactLocally value) updateContactLocally,
    required TResult Function(_AddContact value) addContact,
    required TResult Function(_ClearContact value) clearContact,
    required TResult Function(_DeleteContact value) deleteContact,
  }) {
    return loadContact(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadContact value)? loadContact,
    TResult? Function(_SaveContact value)? saveContact,
    TResult? Function(_UpdateContactLocally value)? updateContactLocally,
    TResult? Function(_AddContact value)? addContact,
    TResult? Function(_ClearContact value)? clearContact,
    TResult? Function(_DeleteContact value)? deleteContact,
  }) {
    return loadContact?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadContact value)? loadContact,
    TResult Function(_SaveContact value)? saveContact,
    TResult Function(_UpdateContactLocally value)? updateContactLocally,
    TResult Function(_AddContact value)? addContact,
    TResult Function(_ClearContact value)? clearContact,
    TResult Function(_DeleteContact value)? deleteContact,
    required TResult orElse(),
  }) {
    if (loadContact != null) {
      return loadContact(this);
    }
    return orElse();
  }
}

abstract class _LoadContact implements ContactDetailsEvent {
  const factory _LoadContact({required final int contactId}) =
      _$LoadContactImpl;

  int get contactId;

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadContactImplCopyWith<_$LoadContactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SaveContactImplCopyWith<$Res> {
  factory _$$SaveContactImplCopyWith(
          _$SaveContactImpl value, $Res Function(_$SaveContactImpl) then) =
      __$$SaveContactImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Contact contact});

  $ContactCopyWith<$Res> get contact;
}

/// @nodoc
class __$$SaveContactImplCopyWithImpl<$Res>
    extends _$ContactDetailsEventCopyWithImpl<$Res, _$SaveContactImpl>
    implements _$$SaveContactImplCopyWith<$Res> {
  __$$SaveContactImplCopyWithImpl(
      _$SaveContactImpl _value, $Res Function(_$SaveContactImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contact = null,
  }) {
    return _then(_$SaveContactImpl(
      contact: null == contact
          ? _value.contact
          : contact // ignore: cast_nullable_to_non_nullable
              as Contact,
    ));
  }

  /// Create a copy of ContactDetailsEvent
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

class _$SaveContactImpl implements _SaveContact {
  const _$SaveContactImpl({required this.contact});

  @override
  final Contact contact;

  @override
  String toString() {
    return 'ContactDetailsEvent.saveContact(contact: $contact)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaveContactImpl &&
            (identical(other.contact, contact) || other.contact == contact));
  }

  @override
  int get hashCode => Object.hash(runtimeType, contact);

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaveContactImplCopyWith<_$SaveContactImpl> get copyWith =>
      __$$SaveContactImplCopyWithImpl<_$SaveContactImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int contactId) loadContact,
    required TResult Function(Contact contact) saveContact,
    required TResult Function(Contact contact) updateContactLocally,
    required TResult Function(Contact contact) addContact,
    required TResult Function() clearContact,
    required TResult Function(int contactId) deleteContact,
  }) {
    return saveContact(contact);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int contactId)? loadContact,
    TResult? Function(Contact contact)? saveContact,
    TResult? Function(Contact contact)? updateContactLocally,
    TResult? Function(Contact contact)? addContact,
    TResult? Function()? clearContact,
    TResult? Function(int contactId)? deleteContact,
  }) {
    return saveContact?.call(contact);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int contactId)? loadContact,
    TResult Function(Contact contact)? saveContact,
    TResult Function(Contact contact)? updateContactLocally,
    TResult Function(Contact contact)? addContact,
    TResult Function()? clearContact,
    TResult Function(int contactId)? deleteContact,
    required TResult orElse(),
  }) {
    if (saveContact != null) {
      return saveContact(contact);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadContact value) loadContact,
    required TResult Function(_SaveContact value) saveContact,
    required TResult Function(_UpdateContactLocally value) updateContactLocally,
    required TResult Function(_AddContact value) addContact,
    required TResult Function(_ClearContact value) clearContact,
    required TResult Function(_DeleteContact value) deleteContact,
  }) {
    return saveContact(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadContact value)? loadContact,
    TResult? Function(_SaveContact value)? saveContact,
    TResult? Function(_UpdateContactLocally value)? updateContactLocally,
    TResult? Function(_AddContact value)? addContact,
    TResult? Function(_ClearContact value)? clearContact,
    TResult? Function(_DeleteContact value)? deleteContact,
  }) {
    return saveContact?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadContact value)? loadContact,
    TResult Function(_SaveContact value)? saveContact,
    TResult Function(_UpdateContactLocally value)? updateContactLocally,
    TResult Function(_AddContact value)? addContact,
    TResult Function(_ClearContact value)? clearContact,
    TResult Function(_DeleteContact value)? deleteContact,
    required TResult orElse(),
  }) {
    if (saveContact != null) {
      return saveContact(this);
    }
    return orElse();
  }
}

abstract class _SaveContact implements ContactDetailsEvent {
  const factory _SaveContact({required final Contact contact}) =
      _$SaveContactImpl;

  Contact get contact;

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaveContactImplCopyWith<_$SaveContactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateContactLocallyImplCopyWith<$Res> {
  factory _$$UpdateContactLocallyImplCopyWith(_$UpdateContactLocallyImpl value,
          $Res Function(_$UpdateContactLocallyImpl) then) =
      __$$UpdateContactLocallyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Contact contact});

  $ContactCopyWith<$Res> get contact;
}

/// @nodoc
class __$$UpdateContactLocallyImplCopyWithImpl<$Res>
    extends _$ContactDetailsEventCopyWithImpl<$Res, _$UpdateContactLocallyImpl>
    implements _$$UpdateContactLocallyImplCopyWith<$Res> {
  __$$UpdateContactLocallyImplCopyWithImpl(_$UpdateContactLocallyImpl _value,
      $Res Function(_$UpdateContactLocallyImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contact = null,
  }) {
    return _then(_$UpdateContactLocallyImpl(
      contact: null == contact
          ? _value.contact
          : contact // ignore: cast_nullable_to_non_nullable
              as Contact,
    ));
  }

  /// Create a copy of ContactDetailsEvent
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

class _$UpdateContactLocallyImpl implements _UpdateContactLocally {
  const _$UpdateContactLocallyImpl({required this.contact});

  @override
  final Contact contact;

  @override
  String toString() {
    return 'ContactDetailsEvent.updateContactLocally(contact: $contact)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateContactLocallyImpl &&
            (identical(other.contact, contact) || other.contact == contact));
  }

  @override
  int get hashCode => Object.hash(runtimeType, contact);

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateContactLocallyImplCopyWith<_$UpdateContactLocallyImpl>
      get copyWith =>
          __$$UpdateContactLocallyImplCopyWithImpl<_$UpdateContactLocallyImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int contactId) loadContact,
    required TResult Function(Contact contact) saveContact,
    required TResult Function(Contact contact) updateContactLocally,
    required TResult Function(Contact contact) addContact,
    required TResult Function() clearContact,
    required TResult Function(int contactId) deleteContact,
  }) {
    return updateContactLocally(contact);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int contactId)? loadContact,
    TResult? Function(Contact contact)? saveContact,
    TResult? Function(Contact contact)? updateContactLocally,
    TResult? Function(Contact contact)? addContact,
    TResult? Function()? clearContact,
    TResult? Function(int contactId)? deleteContact,
  }) {
    return updateContactLocally?.call(contact);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int contactId)? loadContact,
    TResult Function(Contact contact)? saveContact,
    TResult Function(Contact contact)? updateContactLocally,
    TResult Function(Contact contact)? addContact,
    TResult Function()? clearContact,
    TResult Function(int contactId)? deleteContact,
    required TResult orElse(),
  }) {
    if (updateContactLocally != null) {
      return updateContactLocally(contact);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadContact value) loadContact,
    required TResult Function(_SaveContact value) saveContact,
    required TResult Function(_UpdateContactLocally value) updateContactLocally,
    required TResult Function(_AddContact value) addContact,
    required TResult Function(_ClearContact value) clearContact,
    required TResult Function(_DeleteContact value) deleteContact,
  }) {
    return updateContactLocally(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadContact value)? loadContact,
    TResult? Function(_SaveContact value)? saveContact,
    TResult? Function(_UpdateContactLocally value)? updateContactLocally,
    TResult? Function(_AddContact value)? addContact,
    TResult? Function(_ClearContact value)? clearContact,
    TResult? Function(_DeleteContact value)? deleteContact,
  }) {
    return updateContactLocally?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadContact value)? loadContact,
    TResult Function(_SaveContact value)? saveContact,
    TResult Function(_UpdateContactLocally value)? updateContactLocally,
    TResult Function(_AddContact value)? addContact,
    TResult Function(_ClearContact value)? clearContact,
    TResult Function(_DeleteContact value)? deleteContact,
    required TResult orElse(),
  }) {
    if (updateContactLocally != null) {
      return updateContactLocally(this);
    }
    return orElse();
  }
}

abstract class _UpdateContactLocally implements ContactDetailsEvent {
  const factory _UpdateContactLocally({required final Contact contact}) =
      _$UpdateContactLocallyImpl;

  Contact get contact;

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateContactLocallyImplCopyWith<_$UpdateContactLocallyImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AddContactImplCopyWith<$Res> {
  factory _$$AddContactImplCopyWith(
          _$AddContactImpl value, $Res Function(_$AddContactImpl) then) =
      __$$AddContactImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Contact contact});

  $ContactCopyWith<$Res> get contact;
}

/// @nodoc
class __$$AddContactImplCopyWithImpl<$Res>
    extends _$ContactDetailsEventCopyWithImpl<$Res, _$AddContactImpl>
    implements _$$AddContactImplCopyWith<$Res> {
  __$$AddContactImplCopyWithImpl(
      _$AddContactImpl _value, $Res Function(_$AddContactImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contact = null,
  }) {
    return _then(_$AddContactImpl(
      contact: null == contact
          ? _value.contact
          : contact // ignore: cast_nullable_to_non_nullable
              as Contact,
    ));
  }

  /// Create a copy of ContactDetailsEvent
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

class _$AddContactImpl implements _AddContact {
  const _$AddContactImpl({required this.contact});

  @override
  final Contact contact;

  @override
  String toString() {
    return 'ContactDetailsEvent.addContact(contact: $contact)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddContactImpl &&
            (identical(other.contact, contact) || other.contact == contact));
  }

  @override
  int get hashCode => Object.hash(runtimeType, contact);

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddContactImplCopyWith<_$AddContactImpl> get copyWith =>
      __$$AddContactImplCopyWithImpl<_$AddContactImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int contactId) loadContact,
    required TResult Function(Contact contact) saveContact,
    required TResult Function(Contact contact) updateContactLocally,
    required TResult Function(Contact contact) addContact,
    required TResult Function() clearContact,
    required TResult Function(int contactId) deleteContact,
  }) {
    return addContact(contact);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int contactId)? loadContact,
    TResult? Function(Contact contact)? saveContact,
    TResult? Function(Contact contact)? updateContactLocally,
    TResult? Function(Contact contact)? addContact,
    TResult? Function()? clearContact,
    TResult? Function(int contactId)? deleteContact,
  }) {
    return addContact?.call(contact);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int contactId)? loadContact,
    TResult Function(Contact contact)? saveContact,
    TResult Function(Contact contact)? updateContactLocally,
    TResult Function(Contact contact)? addContact,
    TResult Function()? clearContact,
    TResult Function(int contactId)? deleteContact,
    required TResult orElse(),
  }) {
    if (addContact != null) {
      return addContact(contact);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadContact value) loadContact,
    required TResult Function(_SaveContact value) saveContact,
    required TResult Function(_UpdateContactLocally value) updateContactLocally,
    required TResult Function(_AddContact value) addContact,
    required TResult Function(_ClearContact value) clearContact,
    required TResult Function(_DeleteContact value) deleteContact,
  }) {
    return addContact(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadContact value)? loadContact,
    TResult? Function(_SaveContact value)? saveContact,
    TResult? Function(_UpdateContactLocally value)? updateContactLocally,
    TResult? Function(_AddContact value)? addContact,
    TResult? Function(_ClearContact value)? clearContact,
    TResult? Function(_DeleteContact value)? deleteContact,
  }) {
    return addContact?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadContact value)? loadContact,
    TResult Function(_SaveContact value)? saveContact,
    TResult Function(_UpdateContactLocally value)? updateContactLocally,
    TResult Function(_AddContact value)? addContact,
    TResult Function(_ClearContact value)? clearContact,
    TResult Function(_DeleteContact value)? deleteContact,
    required TResult orElse(),
  }) {
    if (addContact != null) {
      return addContact(this);
    }
    return orElse();
  }
}

abstract class _AddContact implements ContactDetailsEvent {
  const factory _AddContact({required final Contact contact}) =
      _$AddContactImpl;

  Contact get contact;

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddContactImplCopyWith<_$AddContactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ClearContactImplCopyWith<$Res> {
  factory _$$ClearContactImplCopyWith(
          _$ClearContactImpl value, $Res Function(_$ClearContactImpl) then) =
      __$$ClearContactImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ClearContactImplCopyWithImpl<$Res>
    extends _$ContactDetailsEventCopyWithImpl<$Res, _$ClearContactImpl>
    implements _$$ClearContactImplCopyWith<$Res> {
  __$$ClearContactImplCopyWithImpl(
      _$ClearContactImpl _value, $Res Function(_$ClearContactImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ClearContactImpl implements _ClearContact {
  const _$ClearContactImpl();

  @override
  String toString() {
    return 'ContactDetailsEvent.clearContact()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ClearContactImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int contactId) loadContact,
    required TResult Function(Contact contact) saveContact,
    required TResult Function(Contact contact) updateContactLocally,
    required TResult Function(Contact contact) addContact,
    required TResult Function() clearContact,
    required TResult Function(int contactId) deleteContact,
  }) {
    return clearContact();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int contactId)? loadContact,
    TResult? Function(Contact contact)? saveContact,
    TResult? Function(Contact contact)? updateContactLocally,
    TResult? Function(Contact contact)? addContact,
    TResult? Function()? clearContact,
    TResult? Function(int contactId)? deleteContact,
  }) {
    return clearContact?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int contactId)? loadContact,
    TResult Function(Contact contact)? saveContact,
    TResult Function(Contact contact)? updateContactLocally,
    TResult Function(Contact contact)? addContact,
    TResult Function()? clearContact,
    TResult Function(int contactId)? deleteContact,
    required TResult orElse(),
  }) {
    if (clearContact != null) {
      return clearContact();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadContact value) loadContact,
    required TResult Function(_SaveContact value) saveContact,
    required TResult Function(_UpdateContactLocally value) updateContactLocally,
    required TResult Function(_AddContact value) addContact,
    required TResult Function(_ClearContact value) clearContact,
    required TResult Function(_DeleteContact value) deleteContact,
  }) {
    return clearContact(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadContact value)? loadContact,
    TResult? Function(_SaveContact value)? saveContact,
    TResult? Function(_UpdateContactLocally value)? updateContactLocally,
    TResult? Function(_AddContact value)? addContact,
    TResult? Function(_ClearContact value)? clearContact,
    TResult? Function(_DeleteContact value)? deleteContact,
  }) {
    return clearContact?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadContact value)? loadContact,
    TResult Function(_SaveContact value)? saveContact,
    TResult Function(_UpdateContactLocally value)? updateContactLocally,
    TResult Function(_AddContact value)? addContact,
    TResult Function(_ClearContact value)? clearContact,
    TResult Function(_DeleteContact value)? deleteContact,
    required TResult orElse(),
  }) {
    if (clearContact != null) {
      return clearContact(this);
    }
    return orElse();
  }
}

abstract class _ClearContact implements ContactDetailsEvent {
  const factory _ClearContact() = _$ClearContactImpl;
}

/// @nodoc
abstract class _$$DeleteContactImplCopyWith<$Res> {
  factory _$$DeleteContactImplCopyWith(
          _$DeleteContactImpl value, $Res Function(_$DeleteContactImpl) then) =
      __$$DeleteContactImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int contactId});
}

/// @nodoc
class __$$DeleteContactImplCopyWithImpl<$Res>
    extends _$ContactDetailsEventCopyWithImpl<$Res, _$DeleteContactImpl>
    implements _$$DeleteContactImplCopyWith<$Res> {
  __$$DeleteContactImplCopyWithImpl(
      _$DeleteContactImpl _value, $Res Function(_$DeleteContactImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contactId = null,
  }) {
    return _then(_$DeleteContactImpl(
      contactId: null == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$DeleteContactImpl implements _DeleteContact {
  const _$DeleteContactImpl({required this.contactId});

  @override
  final int contactId;

  @override
  String toString() {
    return 'ContactDetailsEvent.deleteContact(contactId: $contactId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteContactImpl &&
            (identical(other.contactId, contactId) ||
                other.contactId == contactId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, contactId);

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteContactImplCopyWith<_$DeleteContactImpl> get copyWith =>
      __$$DeleteContactImplCopyWithImpl<_$DeleteContactImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int contactId) loadContact,
    required TResult Function(Contact contact) saveContact,
    required TResult Function(Contact contact) updateContactLocally,
    required TResult Function(Contact contact) addContact,
    required TResult Function() clearContact,
    required TResult Function(int contactId) deleteContact,
  }) {
    return deleteContact(contactId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int contactId)? loadContact,
    TResult? Function(Contact contact)? saveContact,
    TResult? Function(Contact contact)? updateContactLocally,
    TResult? Function(Contact contact)? addContact,
    TResult? Function()? clearContact,
    TResult? Function(int contactId)? deleteContact,
  }) {
    return deleteContact?.call(contactId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int contactId)? loadContact,
    TResult Function(Contact contact)? saveContact,
    TResult Function(Contact contact)? updateContactLocally,
    TResult Function(Contact contact)? addContact,
    TResult Function()? clearContact,
    TResult Function(int contactId)? deleteContact,
    required TResult orElse(),
  }) {
    if (deleteContact != null) {
      return deleteContact(contactId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadContact value) loadContact,
    required TResult Function(_SaveContact value) saveContact,
    required TResult Function(_UpdateContactLocally value) updateContactLocally,
    required TResult Function(_AddContact value) addContact,
    required TResult Function(_ClearContact value) clearContact,
    required TResult Function(_DeleteContact value) deleteContact,
  }) {
    return deleteContact(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadContact value)? loadContact,
    TResult? Function(_SaveContact value)? saveContact,
    TResult? Function(_UpdateContactLocally value)? updateContactLocally,
    TResult? Function(_AddContact value)? addContact,
    TResult? Function(_ClearContact value)? clearContact,
    TResult? Function(_DeleteContact value)? deleteContact,
  }) {
    return deleteContact?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadContact value)? loadContact,
    TResult Function(_SaveContact value)? saveContact,
    TResult Function(_UpdateContactLocally value)? updateContactLocally,
    TResult Function(_AddContact value)? addContact,
    TResult Function(_ClearContact value)? clearContact,
    TResult Function(_DeleteContact value)? deleteContact,
    required TResult orElse(),
  }) {
    if (deleteContact != null) {
      return deleteContact(this);
    }
    return orElse();
  }
}

abstract class _DeleteContact implements ContactDetailsEvent {
  const factory _DeleteContact({required final int contactId}) =
      _$DeleteContactImpl;

  int get contactId;

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteContactImplCopyWith<_$DeleteContactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ContactDetailsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(Contact contact) loaded,
    required TResult Function() cleared,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(Contact contact)? loaded,
    TResult? Function()? cleared,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(Contact contact)? loaded,
    TResult Function()? cleared,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Cleared value) cleared,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Cleared value)? cleared,
    TResult? Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Cleared value)? cleared,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactDetailsStateCopyWith<$Res> {
  factory $ContactDetailsStateCopyWith(
          ContactDetailsState value, $Res Function(ContactDetailsState) then) =
      _$ContactDetailsStateCopyWithImpl<$Res, ContactDetailsState>;
}

/// @nodoc
class _$ContactDetailsStateCopyWithImpl<$Res, $Val extends ContactDetailsState>
    implements $ContactDetailsStateCopyWith<$Res> {
  _$ContactDetailsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactDetailsState
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
    extends _$ContactDetailsStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactDetailsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'ContactDetailsState.initial()';
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
    required TResult Function(Contact contact) loaded,
    required TResult Function() cleared,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(Contact contact)? loaded,
    TResult? Function()? cleared,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(Contact contact)? loaded,
    TResult Function()? cleared,
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
    required TResult Function(_Cleared value) cleared,
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
    TResult? Function(_Cleared value)? cleared,
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
    TResult Function(_Cleared value)? cleared,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements ContactDetailsState {
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
    extends _$ContactDetailsStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactDetailsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'ContactDetailsState.loading()';
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
    required TResult Function(Contact contact) loaded,
    required TResult Function() cleared,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(Contact contact)? loaded,
    TResult? Function()? cleared,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(Contact contact)? loaded,
    TResult Function()? cleared,
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
    required TResult Function(_Cleared value) cleared,
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
    TResult? Function(_Cleared value)? cleared,
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
    TResult Function(_Cleared value)? cleared,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements ContactDetailsState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$LoadedImplCopyWith<$Res> {
  factory _$$LoadedImplCopyWith(
          _$LoadedImpl value, $Res Function(_$LoadedImpl) then) =
      __$$LoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Contact contact});

  $ContactCopyWith<$Res> get contact;
}

/// @nodoc
class __$$LoadedImplCopyWithImpl<$Res>
    extends _$ContactDetailsStateCopyWithImpl<$Res, _$LoadedImpl>
    implements _$$LoadedImplCopyWith<$Res> {
  __$$LoadedImplCopyWithImpl(
      _$LoadedImpl _value, $Res Function(_$LoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contact = null,
  }) {
    return _then(_$LoadedImpl(
      null == contact
          ? _value.contact
          : contact // ignore: cast_nullable_to_non_nullable
              as Contact,
    ));
  }

  /// Create a copy of ContactDetailsState
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

class _$LoadedImpl implements _Loaded {
  const _$LoadedImpl(this.contact);

  @override
  final Contact contact;

  @override
  String toString() {
    return 'ContactDetailsState.loaded(contact: $contact)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadedImpl &&
            (identical(other.contact, contact) || other.contact == contact));
  }

  @override
  int get hashCode => Object.hash(runtimeType, contact);

  /// Create a copy of ContactDetailsState
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
    required TResult Function(Contact contact) loaded,
    required TResult Function() cleared,
    required TResult Function(String message) error,
  }) {
    return loaded(contact);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(Contact contact)? loaded,
    TResult? Function()? cleared,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(contact);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(Contact contact)? loaded,
    TResult Function()? cleared,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(contact);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Cleared value) cleared,
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
    TResult? Function(_Cleared value)? cleared,
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
    TResult Function(_Cleared value)? cleared,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _Loaded implements ContactDetailsState {
  const factory _Loaded(final Contact contact) = _$LoadedImpl;

  Contact get contact;

  /// Create a copy of ContactDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ClearedImplCopyWith<$Res> {
  factory _$$ClearedImplCopyWith(
          _$ClearedImpl value, $Res Function(_$ClearedImpl) then) =
      __$$ClearedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ClearedImplCopyWithImpl<$Res>
    extends _$ContactDetailsStateCopyWithImpl<$Res, _$ClearedImpl>
    implements _$$ClearedImplCopyWith<$Res> {
  __$$ClearedImplCopyWithImpl(
      _$ClearedImpl _value, $Res Function(_$ClearedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactDetailsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ClearedImpl implements _Cleared {
  const _$ClearedImpl();

  @override
  String toString() {
    return 'ContactDetailsState.cleared()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ClearedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(Contact contact) loaded,
    required TResult Function() cleared,
    required TResult Function(String message) error,
  }) {
    return cleared();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(Contact contact)? loaded,
    TResult? Function()? cleared,
    TResult? Function(String message)? error,
  }) {
    return cleared?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(Contact contact)? loaded,
    TResult Function()? cleared,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (cleared != null) {
      return cleared();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Cleared value) cleared,
    required TResult Function(_Error value) error,
  }) {
    return cleared(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Cleared value)? cleared,
    TResult? Function(_Error value)? error,
  }) {
    return cleared?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Cleared value)? cleared,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (cleared != null) {
      return cleared(this);
    }
    return orElse();
  }
}

abstract class _Cleared implements ContactDetailsState {
  const factory _Cleared() = _$ClearedImpl;
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
    extends _$ContactDetailsStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactDetailsState
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
    return 'ContactDetailsState.error(message: $message)';
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

  /// Create a copy of ContactDetailsState
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
    required TResult Function(Contact contact) loaded,
    required TResult Function() cleared,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(Contact contact)? loaded,
    TResult? Function()? cleared,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(Contact contact)? loaded,
    TResult Function()? cleared,
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
    required TResult Function(_Cleared value) cleared,
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
    TResult? Function(_Cleared value)? cleared,
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
    TResult Function(_Cleared value)? cleared,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements ContactDetailsState {
  const factory _Error(final String message) = _$ErrorImpl;

  String get message;

  /// Create a copy of ContactDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
