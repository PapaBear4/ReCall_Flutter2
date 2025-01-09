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
    required TResult Function(Contact updatedContact) saveContactDetails,
    required TResult Function(Contact updatedContact) updateContactDetails,
    required TResult Function(DateTime? birthday, int contactId) updateBirthday,
    required TResult Function() startNewContact,
    required TResult Function(Contact newContact) addNewContact,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int contactId)? loadContact,
    TResult? Function(Contact updatedContact)? saveContactDetails,
    TResult? Function(Contact updatedContact)? updateContactDetails,
    TResult? Function(DateTime? birthday, int contactId)? updateBirthday,
    TResult? Function()? startNewContact,
    TResult? Function(Contact newContact)? addNewContact,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int contactId)? loadContact,
    TResult Function(Contact updatedContact)? saveContactDetails,
    TResult Function(Contact updatedContact)? updateContactDetails,
    TResult Function(DateTime? birthday, int contactId)? updateBirthday,
    TResult Function()? startNewContact,
    TResult Function(Contact newContact)? addNewContact,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadContact value) loadContact,
    required TResult Function(SaveContactDetails value) saveContactDetails,
    required TResult Function(UpdateContactDetails value) updateContactDetails,
    required TResult Function(UpdateBirthday value) updateBirthday,
    required TResult Function(StartNewContact value) startNewContact,
    required TResult Function(AddNewContact value) addNewContact,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadContact value)? loadContact,
    TResult? Function(SaveContactDetails value)? saveContactDetails,
    TResult? Function(UpdateContactDetails value)? updateContactDetails,
    TResult? Function(UpdateBirthday value)? updateBirthday,
    TResult? Function(StartNewContact value)? startNewContact,
    TResult? Function(AddNewContact value)? addNewContact,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadContact value)? loadContact,
    TResult Function(SaveContactDetails value)? saveContactDetails,
    TResult Function(UpdateContactDetails value)? updateContactDetails,
    TResult Function(UpdateBirthday value)? updateBirthday,
    TResult Function(StartNewContact value)? startNewContact,
    TResult Function(AddNewContact value)? addNewContact,
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
      null == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$LoadContactImpl implements LoadContact {
  const _$LoadContactImpl(this.contactId);

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
    required TResult Function(Contact updatedContact) saveContactDetails,
    required TResult Function(Contact updatedContact) updateContactDetails,
    required TResult Function(DateTime? birthday, int contactId) updateBirthday,
    required TResult Function() startNewContact,
    required TResult Function(Contact newContact) addNewContact,
  }) {
    return loadContact(contactId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int contactId)? loadContact,
    TResult? Function(Contact updatedContact)? saveContactDetails,
    TResult? Function(Contact updatedContact)? updateContactDetails,
    TResult? Function(DateTime? birthday, int contactId)? updateBirthday,
    TResult? Function()? startNewContact,
    TResult? Function(Contact newContact)? addNewContact,
  }) {
    return loadContact?.call(contactId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int contactId)? loadContact,
    TResult Function(Contact updatedContact)? saveContactDetails,
    TResult Function(Contact updatedContact)? updateContactDetails,
    TResult Function(DateTime? birthday, int contactId)? updateBirthday,
    TResult Function()? startNewContact,
    TResult Function(Contact newContact)? addNewContact,
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
    required TResult Function(LoadContact value) loadContact,
    required TResult Function(SaveContactDetails value) saveContactDetails,
    required TResult Function(UpdateContactDetails value) updateContactDetails,
    required TResult Function(UpdateBirthday value) updateBirthday,
    required TResult Function(StartNewContact value) startNewContact,
    required TResult Function(AddNewContact value) addNewContact,
  }) {
    return loadContact(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadContact value)? loadContact,
    TResult? Function(SaveContactDetails value)? saveContactDetails,
    TResult? Function(UpdateContactDetails value)? updateContactDetails,
    TResult? Function(UpdateBirthday value)? updateBirthday,
    TResult? Function(StartNewContact value)? startNewContact,
    TResult? Function(AddNewContact value)? addNewContact,
  }) {
    return loadContact?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadContact value)? loadContact,
    TResult Function(SaveContactDetails value)? saveContactDetails,
    TResult Function(UpdateContactDetails value)? updateContactDetails,
    TResult Function(UpdateBirthday value)? updateBirthday,
    TResult Function(StartNewContact value)? startNewContact,
    TResult Function(AddNewContact value)? addNewContact,
    required TResult orElse(),
  }) {
    if (loadContact != null) {
      return loadContact(this);
    }
    return orElse();
  }
}

abstract class LoadContact implements ContactDetailsEvent {
  const factory LoadContact(final int contactId) = _$LoadContactImpl;

  int get contactId;

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadContactImplCopyWith<_$LoadContactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SaveContactDetailsImplCopyWith<$Res> {
  factory _$$SaveContactDetailsImplCopyWith(_$SaveContactDetailsImpl value,
          $Res Function(_$SaveContactDetailsImpl) then) =
      __$$SaveContactDetailsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Contact updatedContact});

  $ContactCopyWith<$Res> get updatedContact;
}

/// @nodoc
class __$$SaveContactDetailsImplCopyWithImpl<$Res>
    extends _$ContactDetailsEventCopyWithImpl<$Res, _$SaveContactDetailsImpl>
    implements _$$SaveContactDetailsImplCopyWith<$Res> {
  __$$SaveContactDetailsImplCopyWithImpl(_$SaveContactDetailsImpl _value,
      $Res Function(_$SaveContactDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? updatedContact = null,
  }) {
    return _then(_$SaveContactDetailsImpl(
      null == updatedContact
          ? _value.updatedContact
          : updatedContact // ignore: cast_nullable_to_non_nullable
              as Contact,
    ));
  }

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContactCopyWith<$Res> get updatedContact {
    return $ContactCopyWith<$Res>(_value.updatedContact, (value) {
      return _then(_value.copyWith(updatedContact: value));
    });
  }
}

/// @nodoc

class _$SaveContactDetailsImpl implements SaveContactDetails {
  const _$SaveContactDetailsImpl(this.updatedContact);

  @override
  final Contact updatedContact;

  @override
  String toString() {
    return 'ContactDetailsEvent.saveContactDetails(updatedContact: $updatedContact)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaveContactDetailsImpl &&
            (identical(other.updatedContact, updatedContact) ||
                other.updatedContact == updatedContact));
  }

  @override
  int get hashCode => Object.hash(runtimeType, updatedContact);

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaveContactDetailsImplCopyWith<_$SaveContactDetailsImpl> get copyWith =>
      __$$SaveContactDetailsImplCopyWithImpl<_$SaveContactDetailsImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int contactId) loadContact,
    required TResult Function(Contact updatedContact) saveContactDetails,
    required TResult Function(Contact updatedContact) updateContactDetails,
    required TResult Function(DateTime? birthday, int contactId) updateBirthday,
    required TResult Function() startNewContact,
    required TResult Function(Contact newContact) addNewContact,
  }) {
    return saveContactDetails(updatedContact);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int contactId)? loadContact,
    TResult? Function(Contact updatedContact)? saveContactDetails,
    TResult? Function(Contact updatedContact)? updateContactDetails,
    TResult? Function(DateTime? birthday, int contactId)? updateBirthday,
    TResult? Function()? startNewContact,
    TResult? Function(Contact newContact)? addNewContact,
  }) {
    return saveContactDetails?.call(updatedContact);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int contactId)? loadContact,
    TResult Function(Contact updatedContact)? saveContactDetails,
    TResult Function(Contact updatedContact)? updateContactDetails,
    TResult Function(DateTime? birthday, int contactId)? updateBirthday,
    TResult Function()? startNewContact,
    TResult Function(Contact newContact)? addNewContact,
    required TResult orElse(),
  }) {
    if (saveContactDetails != null) {
      return saveContactDetails(updatedContact);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadContact value) loadContact,
    required TResult Function(SaveContactDetails value) saveContactDetails,
    required TResult Function(UpdateContactDetails value) updateContactDetails,
    required TResult Function(UpdateBirthday value) updateBirthday,
    required TResult Function(StartNewContact value) startNewContact,
    required TResult Function(AddNewContact value) addNewContact,
  }) {
    return saveContactDetails(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadContact value)? loadContact,
    TResult? Function(SaveContactDetails value)? saveContactDetails,
    TResult? Function(UpdateContactDetails value)? updateContactDetails,
    TResult? Function(UpdateBirthday value)? updateBirthday,
    TResult? Function(StartNewContact value)? startNewContact,
    TResult? Function(AddNewContact value)? addNewContact,
  }) {
    return saveContactDetails?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadContact value)? loadContact,
    TResult Function(SaveContactDetails value)? saveContactDetails,
    TResult Function(UpdateContactDetails value)? updateContactDetails,
    TResult Function(UpdateBirthday value)? updateBirthday,
    TResult Function(StartNewContact value)? startNewContact,
    TResult Function(AddNewContact value)? addNewContact,
    required TResult orElse(),
  }) {
    if (saveContactDetails != null) {
      return saveContactDetails(this);
    }
    return orElse();
  }
}

abstract class SaveContactDetails implements ContactDetailsEvent {
  const factory SaveContactDetails(final Contact updatedContact) =
      _$SaveContactDetailsImpl;

  Contact get updatedContact;

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaveContactDetailsImplCopyWith<_$SaveContactDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateContactDetailsImplCopyWith<$Res> {
  factory _$$UpdateContactDetailsImplCopyWith(_$UpdateContactDetailsImpl value,
          $Res Function(_$UpdateContactDetailsImpl) then) =
      __$$UpdateContactDetailsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Contact updatedContact});

  $ContactCopyWith<$Res> get updatedContact;
}

/// @nodoc
class __$$UpdateContactDetailsImplCopyWithImpl<$Res>
    extends _$ContactDetailsEventCopyWithImpl<$Res, _$UpdateContactDetailsImpl>
    implements _$$UpdateContactDetailsImplCopyWith<$Res> {
  __$$UpdateContactDetailsImplCopyWithImpl(_$UpdateContactDetailsImpl _value,
      $Res Function(_$UpdateContactDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? updatedContact = null,
  }) {
    return _then(_$UpdateContactDetailsImpl(
      null == updatedContact
          ? _value.updatedContact
          : updatedContact // ignore: cast_nullable_to_non_nullable
              as Contact,
    ));
  }

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContactCopyWith<$Res> get updatedContact {
    return $ContactCopyWith<$Res>(_value.updatedContact, (value) {
      return _then(_value.copyWith(updatedContact: value));
    });
  }
}

/// @nodoc

class _$UpdateContactDetailsImpl implements UpdateContactDetails {
  const _$UpdateContactDetailsImpl(this.updatedContact);

  @override
  final Contact updatedContact;

  @override
  String toString() {
    return 'ContactDetailsEvent.updateContactDetails(updatedContact: $updatedContact)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateContactDetailsImpl &&
            (identical(other.updatedContact, updatedContact) ||
                other.updatedContact == updatedContact));
  }

  @override
  int get hashCode => Object.hash(runtimeType, updatedContact);

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateContactDetailsImplCopyWith<_$UpdateContactDetailsImpl>
      get copyWith =>
          __$$UpdateContactDetailsImplCopyWithImpl<_$UpdateContactDetailsImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int contactId) loadContact,
    required TResult Function(Contact updatedContact) saveContactDetails,
    required TResult Function(Contact updatedContact) updateContactDetails,
    required TResult Function(DateTime? birthday, int contactId) updateBirthday,
    required TResult Function() startNewContact,
    required TResult Function(Contact newContact) addNewContact,
  }) {
    return updateContactDetails(updatedContact);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int contactId)? loadContact,
    TResult? Function(Contact updatedContact)? saveContactDetails,
    TResult? Function(Contact updatedContact)? updateContactDetails,
    TResult? Function(DateTime? birthday, int contactId)? updateBirthday,
    TResult? Function()? startNewContact,
    TResult? Function(Contact newContact)? addNewContact,
  }) {
    return updateContactDetails?.call(updatedContact);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int contactId)? loadContact,
    TResult Function(Contact updatedContact)? saveContactDetails,
    TResult Function(Contact updatedContact)? updateContactDetails,
    TResult Function(DateTime? birthday, int contactId)? updateBirthday,
    TResult Function()? startNewContact,
    TResult Function(Contact newContact)? addNewContact,
    required TResult orElse(),
  }) {
    if (updateContactDetails != null) {
      return updateContactDetails(updatedContact);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadContact value) loadContact,
    required TResult Function(SaveContactDetails value) saveContactDetails,
    required TResult Function(UpdateContactDetails value) updateContactDetails,
    required TResult Function(UpdateBirthday value) updateBirthday,
    required TResult Function(StartNewContact value) startNewContact,
    required TResult Function(AddNewContact value) addNewContact,
  }) {
    return updateContactDetails(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadContact value)? loadContact,
    TResult? Function(SaveContactDetails value)? saveContactDetails,
    TResult? Function(UpdateContactDetails value)? updateContactDetails,
    TResult? Function(UpdateBirthday value)? updateBirthday,
    TResult? Function(StartNewContact value)? startNewContact,
    TResult? Function(AddNewContact value)? addNewContact,
  }) {
    return updateContactDetails?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadContact value)? loadContact,
    TResult Function(SaveContactDetails value)? saveContactDetails,
    TResult Function(UpdateContactDetails value)? updateContactDetails,
    TResult Function(UpdateBirthday value)? updateBirthday,
    TResult Function(StartNewContact value)? startNewContact,
    TResult Function(AddNewContact value)? addNewContact,
    required TResult orElse(),
  }) {
    if (updateContactDetails != null) {
      return updateContactDetails(this);
    }
    return orElse();
  }
}

abstract class UpdateContactDetails implements ContactDetailsEvent {
  const factory UpdateContactDetails(final Contact updatedContact) =
      _$UpdateContactDetailsImpl;

  Contact get updatedContact;

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateContactDetailsImplCopyWith<_$UpdateContactDetailsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateBirthdayImplCopyWith<$Res> {
  factory _$$UpdateBirthdayImplCopyWith(_$UpdateBirthdayImpl value,
          $Res Function(_$UpdateBirthdayImpl) then) =
      __$$UpdateBirthdayImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DateTime? birthday, int contactId});
}

/// @nodoc
class __$$UpdateBirthdayImplCopyWithImpl<$Res>
    extends _$ContactDetailsEventCopyWithImpl<$Res, _$UpdateBirthdayImpl>
    implements _$$UpdateBirthdayImplCopyWith<$Res> {
  __$$UpdateBirthdayImplCopyWithImpl(
      _$UpdateBirthdayImpl _value, $Res Function(_$UpdateBirthdayImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? birthday = freezed,
    Object? contactId = null,
  }) {
    return _then(_$UpdateBirthdayImpl(
      birthday: freezed == birthday
          ? _value.birthday
          : birthday // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      contactId: null == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$UpdateBirthdayImpl implements UpdateBirthday {
  const _$UpdateBirthdayImpl({required this.birthday, required this.contactId});

  @override
  final DateTime? birthday;
  @override
  final int contactId;

  @override
  String toString() {
    return 'ContactDetailsEvent.updateBirthday(birthday: $birthday, contactId: $contactId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateBirthdayImpl &&
            (identical(other.birthday, birthday) ||
                other.birthday == birthday) &&
            (identical(other.contactId, contactId) ||
                other.contactId == contactId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, birthday, contactId);

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateBirthdayImplCopyWith<_$UpdateBirthdayImpl> get copyWith =>
      __$$UpdateBirthdayImplCopyWithImpl<_$UpdateBirthdayImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int contactId) loadContact,
    required TResult Function(Contact updatedContact) saveContactDetails,
    required TResult Function(Contact updatedContact) updateContactDetails,
    required TResult Function(DateTime? birthday, int contactId) updateBirthday,
    required TResult Function() startNewContact,
    required TResult Function(Contact newContact) addNewContact,
  }) {
    return updateBirthday(birthday, contactId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int contactId)? loadContact,
    TResult? Function(Contact updatedContact)? saveContactDetails,
    TResult? Function(Contact updatedContact)? updateContactDetails,
    TResult? Function(DateTime? birthday, int contactId)? updateBirthday,
    TResult? Function()? startNewContact,
    TResult? Function(Contact newContact)? addNewContact,
  }) {
    return updateBirthday?.call(birthday, contactId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int contactId)? loadContact,
    TResult Function(Contact updatedContact)? saveContactDetails,
    TResult Function(Contact updatedContact)? updateContactDetails,
    TResult Function(DateTime? birthday, int contactId)? updateBirthday,
    TResult Function()? startNewContact,
    TResult Function(Contact newContact)? addNewContact,
    required TResult orElse(),
  }) {
    if (updateBirthday != null) {
      return updateBirthday(birthday, contactId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadContact value) loadContact,
    required TResult Function(SaveContactDetails value) saveContactDetails,
    required TResult Function(UpdateContactDetails value) updateContactDetails,
    required TResult Function(UpdateBirthday value) updateBirthday,
    required TResult Function(StartNewContact value) startNewContact,
    required TResult Function(AddNewContact value) addNewContact,
  }) {
    return updateBirthday(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadContact value)? loadContact,
    TResult? Function(SaveContactDetails value)? saveContactDetails,
    TResult? Function(UpdateContactDetails value)? updateContactDetails,
    TResult? Function(UpdateBirthday value)? updateBirthday,
    TResult? Function(StartNewContact value)? startNewContact,
    TResult? Function(AddNewContact value)? addNewContact,
  }) {
    return updateBirthday?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadContact value)? loadContact,
    TResult Function(SaveContactDetails value)? saveContactDetails,
    TResult Function(UpdateContactDetails value)? updateContactDetails,
    TResult Function(UpdateBirthday value)? updateBirthday,
    TResult Function(StartNewContact value)? startNewContact,
    TResult Function(AddNewContact value)? addNewContact,
    required TResult orElse(),
  }) {
    if (updateBirthday != null) {
      return updateBirthday(this);
    }
    return orElse();
  }
}

abstract class UpdateBirthday implements ContactDetailsEvent {
  const factory UpdateBirthday(
      {required final DateTime? birthday,
      required final int contactId}) = _$UpdateBirthdayImpl;

  DateTime? get birthday;
  int get contactId;

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateBirthdayImplCopyWith<_$UpdateBirthdayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StartNewContactImplCopyWith<$Res> {
  factory _$$StartNewContactImplCopyWith(_$StartNewContactImpl value,
          $Res Function(_$StartNewContactImpl) then) =
      __$$StartNewContactImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StartNewContactImplCopyWithImpl<$Res>
    extends _$ContactDetailsEventCopyWithImpl<$Res, _$StartNewContactImpl>
    implements _$$StartNewContactImplCopyWith<$Res> {
  __$$StartNewContactImplCopyWithImpl(
      _$StartNewContactImpl _value, $Res Function(_$StartNewContactImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StartNewContactImpl implements StartNewContact {
  const _$StartNewContactImpl();

  @override
  String toString() {
    return 'ContactDetailsEvent.startNewContact()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$StartNewContactImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int contactId) loadContact,
    required TResult Function(Contact updatedContact) saveContactDetails,
    required TResult Function(Contact updatedContact) updateContactDetails,
    required TResult Function(DateTime? birthday, int contactId) updateBirthday,
    required TResult Function() startNewContact,
    required TResult Function(Contact newContact) addNewContact,
  }) {
    return startNewContact();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int contactId)? loadContact,
    TResult? Function(Contact updatedContact)? saveContactDetails,
    TResult? Function(Contact updatedContact)? updateContactDetails,
    TResult? Function(DateTime? birthday, int contactId)? updateBirthday,
    TResult? Function()? startNewContact,
    TResult? Function(Contact newContact)? addNewContact,
  }) {
    return startNewContact?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int contactId)? loadContact,
    TResult Function(Contact updatedContact)? saveContactDetails,
    TResult Function(Contact updatedContact)? updateContactDetails,
    TResult Function(DateTime? birthday, int contactId)? updateBirthday,
    TResult Function()? startNewContact,
    TResult Function(Contact newContact)? addNewContact,
    required TResult orElse(),
  }) {
    if (startNewContact != null) {
      return startNewContact();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadContact value) loadContact,
    required TResult Function(SaveContactDetails value) saveContactDetails,
    required TResult Function(UpdateContactDetails value) updateContactDetails,
    required TResult Function(UpdateBirthday value) updateBirthday,
    required TResult Function(StartNewContact value) startNewContact,
    required TResult Function(AddNewContact value) addNewContact,
  }) {
    return startNewContact(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadContact value)? loadContact,
    TResult? Function(SaveContactDetails value)? saveContactDetails,
    TResult? Function(UpdateContactDetails value)? updateContactDetails,
    TResult? Function(UpdateBirthday value)? updateBirthday,
    TResult? Function(StartNewContact value)? startNewContact,
    TResult? Function(AddNewContact value)? addNewContact,
  }) {
    return startNewContact?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadContact value)? loadContact,
    TResult Function(SaveContactDetails value)? saveContactDetails,
    TResult Function(UpdateContactDetails value)? updateContactDetails,
    TResult Function(UpdateBirthday value)? updateBirthday,
    TResult Function(StartNewContact value)? startNewContact,
    TResult Function(AddNewContact value)? addNewContact,
    required TResult orElse(),
  }) {
    if (startNewContact != null) {
      return startNewContact(this);
    }
    return orElse();
  }
}

abstract class StartNewContact implements ContactDetailsEvent {
  const factory StartNewContact() = _$StartNewContactImpl;
}

/// @nodoc
abstract class _$$AddNewContactImplCopyWith<$Res> {
  factory _$$AddNewContactImplCopyWith(
          _$AddNewContactImpl value, $Res Function(_$AddNewContactImpl) then) =
      __$$AddNewContactImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Contact newContact});

  $ContactCopyWith<$Res> get newContact;
}

/// @nodoc
class __$$AddNewContactImplCopyWithImpl<$Res>
    extends _$ContactDetailsEventCopyWithImpl<$Res, _$AddNewContactImpl>
    implements _$$AddNewContactImplCopyWith<$Res> {
  __$$AddNewContactImplCopyWithImpl(
      _$AddNewContactImpl _value, $Res Function(_$AddNewContactImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newContact = null,
  }) {
    return _then(_$AddNewContactImpl(
      null == newContact
          ? _value.newContact
          : newContact // ignore: cast_nullable_to_non_nullable
              as Contact,
    ));
  }

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContactCopyWith<$Res> get newContact {
    return $ContactCopyWith<$Res>(_value.newContact, (value) {
      return _then(_value.copyWith(newContact: value));
    });
  }
}

/// @nodoc

class _$AddNewContactImpl implements AddNewContact {
  const _$AddNewContactImpl(this.newContact);

  @override
  final Contact newContact;

  @override
  String toString() {
    return 'ContactDetailsEvent.addNewContact(newContact: $newContact)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddNewContactImpl &&
            (identical(other.newContact, newContact) ||
                other.newContact == newContact));
  }

  @override
  int get hashCode => Object.hash(runtimeType, newContact);

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddNewContactImplCopyWith<_$AddNewContactImpl> get copyWith =>
      __$$AddNewContactImplCopyWithImpl<_$AddNewContactImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int contactId) loadContact,
    required TResult Function(Contact updatedContact) saveContactDetails,
    required TResult Function(Contact updatedContact) updateContactDetails,
    required TResult Function(DateTime? birthday, int contactId) updateBirthday,
    required TResult Function() startNewContact,
    required TResult Function(Contact newContact) addNewContact,
  }) {
    return addNewContact(newContact);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int contactId)? loadContact,
    TResult? Function(Contact updatedContact)? saveContactDetails,
    TResult? Function(Contact updatedContact)? updateContactDetails,
    TResult? Function(DateTime? birthday, int contactId)? updateBirthday,
    TResult? Function()? startNewContact,
    TResult? Function(Contact newContact)? addNewContact,
  }) {
    return addNewContact?.call(newContact);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int contactId)? loadContact,
    TResult Function(Contact updatedContact)? saveContactDetails,
    TResult Function(Contact updatedContact)? updateContactDetails,
    TResult Function(DateTime? birthday, int contactId)? updateBirthday,
    TResult Function()? startNewContact,
    TResult Function(Contact newContact)? addNewContact,
    required TResult orElse(),
  }) {
    if (addNewContact != null) {
      return addNewContact(newContact);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadContact value) loadContact,
    required TResult Function(SaveContactDetails value) saveContactDetails,
    required TResult Function(UpdateContactDetails value) updateContactDetails,
    required TResult Function(UpdateBirthday value) updateBirthday,
    required TResult Function(StartNewContact value) startNewContact,
    required TResult Function(AddNewContact value) addNewContact,
  }) {
    return addNewContact(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadContact value)? loadContact,
    TResult? Function(SaveContactDetails value)? saveContactDetails,
    TResult? Function(UpdateContactDetails value)? updateContactDetails,
    TResult? Function(UpdateBirthday value)? updateBirthday,
    TResult? Function(StartNewContact value)? startNewContact,
    TResult? Function(AddNewContact value)? addNewContact,
  }) {
    return addNewContact?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadContact value)? loadContact,
    TResult Function(SaveContactDetails value)? saveContactDetails,
    TResult Function(UpdateContactDetails value)? updateContactDetails,
    TResult Function(UpdateBirthday value)? updateBirthday,
    TResult Function(StartNewContact value)? startNewContact,
    TResult Function(AddNewContact value)? addNewContact,
    required TResult orElse(),
  }) {
    if (addNewContact != null) {
      return addNewContact(this);
    }
    return orElse();
  }
}

abstract class AddNewContact implements ContactDetailsEvent {
  const factory AddNewContact(final Contact newContact) = _$AddNewContactImpl;

  Contact get newContact;

  /// Create a copy of ContactDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddNewContactImplCopyWith<_$AddNewContactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ContactDetailsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(Contact contact) loaded,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(Contact contact)? loaded,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(Contact contact)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ContactDetailsIntial value) initial,
    required TResult Function(ContactDetailsLoading value) loading,
    required TResult Function(ContactDetailsLoaded value) loaded,
    required TResult Function(ContactDetailsError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ContactDetailsIntial value)? initial,
    TResult? Function(ContactDetailsLoading value)? loading,
    TResult? Function(ContactDetailsLoaded value)? loaded,
    TResult? Function(ContactDetailsError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ContactDetailsIntial value)? initial,
    TResult Function(ContactDetailsLoading value)? loading,
    TResult Function(ContactDetailsLoaded value)? loaded,
    TResult Function(ContactDetailsError value)? error,
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
abstract class _$$ContactDetailsIntialImplCopyWith<$Res> {
  factory _$$ContactDetailsIntialImplCopyWith(_$ContactDetailsIntialImpl value,
          $Res Function(_$ContactDetailsIntialImpl) then) =
      __$$ContactDetailsIntialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ContactDetailsIntialImplCopyWithImpl<$Res>
    extends _$ContactDetailsStateCopyWithImpl<$Res, _$ContactDetailsIntialImpl>
    implements _$$ContactDetailsIntialImplCopyWith<$Res> {
  __$$ContactDetailsIntialImplCopyWithImpl(_$ContactDetailsIntialImpl _value,
      $Res Function(_$ContactDetailsIntialImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactDetailsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ContactDetailsIntialImpl implements ContactDetailsIntial {
  const _$ContactDetailsIntialImpl();

  @override
  String toString() {
    return 'ContactDetailsState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactDetailsIntialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(Contact contact) loaded,
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
    required TResult Function(ContactDetailsIntial value) initial,
    required TResult Function(ContactDetailsLoading value) loading,
    required TResult Function(ContactDetailsLoaded value) loaded,
    required TResult Function(ContactDetailsError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ContactDetailsIntial value)? initial,
    TResult? Function(ContactDetailsLoading value)? loading,
    TResult? Function(ContactDetailsLoaded value)? loaded,
    TResult? Function(ContactDetailsError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ContactDetailsIntial value)? initial,
    TResult Function(ContactDetailsLoading value)? loading,
    TResult Function(ContactDetailsLoaded value)? loaded,
    TResult Function(ContactDetailsError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class ContactDetailsIntial implements ContactDetailsState {
  const factory ContactDetailsIntial() = _$ContactDetailsIntialImpl;
}

/// @nodoc
abstract class _$$ContactDetailsLoadingImplCopyWith<$Res> {
  factory _$$ContactDetailsLoadingImplCopyWith(
          _$ContactDetailsLoadingImpl value,
          $Res Function(_$ContactDetailsLoadingImpl) then) =
      __$$ContactDetailsLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ContactDetailsLoadingImplCopyWithImpl<$Res>
    extends _$ContactDetailsStateCopyWithImpl<$Res, _$ContactDetailsLoadingImpl>
    implements _$$ContactDetailsLoadingImplCopyWith<$Res> {
  __$$ContactDetailsLoadingImplCopyWithImpl(_$ContactDetailsLoadingImpl _value,
      $Res Function(_$ContactDetailsLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactDetailsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ContactDetailsLoadingImpl implements ContactDetailsLoading {
  const _$ContactDetailsLoadingImpl();

  @override
  String toString() {
    return 'ContactDetailsState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactDetailsLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(Contact contact) loaded,
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
    required TResult Function(ContactDetailsIntial value) initial,
    required TResult Function(ContactDetailsLoading value) loading,
    required TResult Function(ContactDetailsLoaded value) loaded,
    required TResult Function(ContactDetailsError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ContactDetailsIntial value)? initial,
    TResult? Function(ContactDetailsLoading value)? loading,
    TResult? Function(ContactDetailsLoaded value)? loaded,
    TResult? Function(ContactDetailsError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ContactDetailsIntial value)? initial,
    TResult Function(ContactDetailsLoading value)? loading,
    TResult Function(ContactDetailsLoaded value)? loaded,
    TResult Function(ContactDetailsError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class ContactDetailsLoading implements ContactDetailsState {
  const factory ContactDetailsLoading() = _$ContactDetailsLoadingImpl;
}

/// @nodoc
abstract class _$$ContactDetailsLoadedImplCopyWith<$Res> {
  factory _$$ContactDetailsLoadedImplCopyWith(_$ContactDetailsLoadedImpl value,
          $Res Function(_$ContactDetailsLoadedImpl) then) =
      __$$ContactDetailsLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Contact contact});

  $ContactCopyWith<$Res> get contact;
}

/// @nodoc
class __$$ContactDetailsLoadedImplCopyWithImpl<$Res>
    extends _$ContactDetailsStateCopyWithImpl<$Res, _$ContactDetailsLoadedImpl>
    implements _$$ContactDetailsLoadedImplCopyWith<$Res> {
  __$$ContactDetailsLoadedImplCopyWithImpl(_$ContactDetailsLoadedImpl _value,
      $Res Function(_$ContactDetailsLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contact = null,
  }) {
    return _then(_$ContactDetailsLoadedImpl(
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

class _$ContactDetailsLoadedImpl implements ContactDetailsLoaded {
  const _$ContactDetailsLoadedImpl(this.contact);

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
            other is _$ContactDetailsLoadedImpl &&
            (identical(other.contact, contact) || other.contact == contact));
  }

  @override
  int get hashCode => Object.hash(runtimeType, contact);

  /// Create a copy of ContactDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactDetailsLoadedImplCopyWith<_$ContactDetailsLoadedImpl>
      get copyWith =>
          __$$ContactDetailsLoadedImplCopyWithImpl<_$ContactDetailsLoadedImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(Contact contact) loaded,
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
    required TResult Function(ContactDetailsIntial value) initial,
    required TResult Function(ContactDetailsLoading value) loading,
    required TResult Function(ContactDetailsLoaded value) loaded,
    required TResult Function(ContactDetailsError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ContactDetailsIntial value)? initial,
    TResult? Function(ContactDetailsLoading value)? loading,
    TResult? Function(ContactDetailsLoaded value)? loaded,
    TResult? Function(ContactDetailsError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ContactDetailsIntial value)? initial,
    TResult Function(ContactDetailsLoading value)? loading,
    TResult Function(ContactDetailsLoaded value)? loaded,
    TResult Function(ContactDetailsError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class ContactDetailsLoaded implements ContactDetailsState {
  const factory ContactDetailsLoaded(final Contact contact) =
      _$ContactDetailsLoadedImpl;

  Contact get contact;

  /// Create a copy of ContactDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactDetailsLoadedImplCopyWith<_$ContactDetailsLoadedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ContactDetailsErrorImplCopyWith<$Res> {
  factory _$$ContactDetailsErrorImplCopyWith(_$ContactDetailsErrorImpl value,
          $Res Function(_$ContactDetailsErrorImpl) then) =
      __$$ContactDetailsErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ContactDetailsErrorImplCopyWithImpl<$Res>
    extends _$ContactDetailsStateCopyWithImpl<$Res, _$ContactDetailsErrorImpl>
    implements _$$ContactDetailsErrorImplCopyWith<$Res> {
  __$$ContactDetailsErrorImplCopyWithImpl(_$ContactDetailsErrorImpl _value,
      $Res Function(_$ContactDetailsErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ContactDetailsErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ContactDetailsErrorImpl implements ContactDetailsError {
  const _$ContactDetailsErrorImpl(this.message);

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
            other is _$ContactDetailsErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ContactDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactDetailsErrorImplCopyWith<_$ContactDetailsErrorImpl> get copyWith =>
      __$$ContactDetailsErrorImplCopyWithImpl<_$ContactDetailsErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(Contact contact) loaded,
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
    required TResult Function(ContactDetailsIntial value) initial,
    required TResult Function(ContactDetailsLoading value) loading,
    required TResult Function(ContactDetailsLoaded value) loaded,
    required TResult Function(ContactDetailsError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ContactDetailsIntial value)? initial,
    TResult? Function(ContactDetailsLoading value)? loading,
    TResult? Function(ContactDetailsLoaded value)? loaded,
    TResult? Function(ContactDetailsError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ContactDetailsIntial value)? initial,
    TResult Function(ContactDetailsLoading value)? loading,
    TResult Function(ContactDetailsLoaded value)? loaded,
    TResult Function(ContactDetailsError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ContactDetailsError implements ContactDetailsState {
  const factory ContactDetailsError(final String message) =
      _$ContactDetailsErrorImpl;

  String get message;

  /// Create a copy of ContactDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactDetailsErrorImplCopyWith<_$ContactDetailsErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
