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
    required TResult Function(Contact contact) addContact,
    required TResult Function(int contactId) deleteContact,
    required TResult Function(Contact updatedContact) updateContact,
    required TResult Function() contactUpdated,
    required TResult Function(ContactListSortField sortField, bool ascending)
        sortContacts,
    required TResult Function(int contactId) updateLastContacted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadContacts,
    TResult? Function(Contact contact)? addContact,
    TResult? Function(int contactId)? deleteContact,
    TResult? Function(Contact updatedContact)? updateContact,
    TResult? Function()? contactUpdated,
    TResult? Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult? Function(int contactId)? updateLastContacted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadContacts,
    TResult Function(Contact contact)? addContact,
    TResult Function(int contactId)? deleteContact,
    TResult Function(Contact updatedContact)? updateContact,
    TResult Function()? contactUpdated,
    TResult Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult Function(int contactId)? updateLastContacted,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadContacts value) loadContacts,
    required TResult Function(AddContact value) addContact,
    required TResult Function(DeleteContact value) deleteContact,
    required TResult Function(UpdateContact value) updateContact,
    required TResult Function(ContactUpdated value) contactUpdated,
    required TResult Function(SortContacts value) sortContacts,
    required TResult Function(UpdateLastContacted value) updateLastContacted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadContacts value)? loadContacts,
    TResult? Function(AddContact value)? addContact,
    TResult? Function(DeleteContact value)? deleteContact,
    TResult? Function(UpdateContact value)? updateContact,
    TResult? Function(ContactUpdated value)? contactUpdated,
    TResult? Function(SortContacts value)? sortContacts,
    TResult? Function(UpdateLastContacted value)? updateLastContacted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadContacts value)? loadContacts,
    TResult Function(AddContact value)? addContact,
    TResult Function(DeleteContact value)? deleteContact,
    TResult Function(UpdateContact value)? updateContact,
    TResult Function(ContactUpdated value)? contactUpdated,
    TResult Function(SortContacts value)? sortContacts,
    TResult Function(UpdateLastContacted value)? updateLastContacted,
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

class _$LoadContactsImpl implements LoadContacts {
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
    required TResult Function(Contact contact) addContact,
    required TResult Function(int contactId) deleteContact,
    required TResult Function(Contact updatedContact) updateContact,
    required TResult Function() contactUpdated,
    required TResult Function(ContactListSortField sortField, bool ascending)
        sortContacts,
    required TResult Function(int contactId) updateLastContacted,
  }) {
    return loadContacts();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadContacts,
    TResult? Function(Contact contact)? addContact,
    TResult? Function(int contactId)? deleteContact,
    TResult? Function(Contact updatedContact)? updateContact,
    TResult? Function()? contactUpdated,
    TResult? Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult? Function(int contactId)? updateLastContacted,
  }) {
    return loadContacts?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadContacts,
    TResult Function(Contact contact)? addContact,
    TResult Function(int contactId)? deleteContact,
    TResult Function(Contact updatedContact)? updateContact,
    TResult Function()? contactUpdated,
    TResult Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult Function(int contactId)? updateLastContacted,
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
    required TResult Function(LoadContacts value) loadContacts,
    required TResult Function(AddContact value) addContact,
    required TResult Function(DeleteContact value) deleteContact,
    required TResult Function(UpdateContact value) updateContact,
    required TResult Function(ContactUpdated value) contactUpdated,
    required TResult Function(SortContacts value) sortContacts,
    required TResult Function(UpdateLastContacted value) updateLastContacted,
  }) {
    return loadContacts(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadContacts value)? loadContacts,
    TResult? Function(AddContact value)? addContact,
    TResult? Function(DeleteContact value)? deleteContact,
    TResult? Function(UpdateContact value)? updateContact,
    TResult? Function(ContactUpdated value)? contactUpdated,
    TResult? Function(SortContacts value)? sortContacts,
    TResult? Function(UpdateLastContacted value)? updateLastContacted,
  }) {
    return loadContacts?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadContacts value)? loadContacts,
    TResult Function(AddContact value)? addContact,
    TResult Function(DeleteContact value)? deleteContact,
    TResult Function(UpdateContact value)? updateContact,
    TResult Function(ContactUpdated value)? contactUpdated,
    TResult Function(SortContacts value)? sortContacts,
    TResult Function(UpdateLastContacted value)? updateLastContacted,
    required TResult orElse(),
  }) {
    if (loadContacts != null) {
      return loadContacts(this);
    }
    return orElse();
  }
}

abstract class LoadContacts implements ContactListEvent {
  const factory LoadContacts() = _$LoadContactsImpl;
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
    extends _$ContactListEventCopyWithImpl<$Res, _$AddContactImpl>
    implements _$$AddContactImplCopyWith<$Res> {
  __$$AddContactImplCopyWithImpl(
      _$AddContactImpl _value, $Res Function(_$AddContactImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contact = null,
  }) {
    return _then(_$AddContactImpl(
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

class _$AddContactImpl implements AddContact {
  const _$AddContactImpl(this.contact);

  @override
  final Contact contact;

  @override
  String toString() {
    return 'ContactListEvent.addContact(contact: $contact)';
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

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddContactImplCopyWith<_$AddContactImpl> get copyWith =>
      __$$AddContactImplCopyWithImpl<_$AddContactImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadContacts,
    required TResult Function(Contact contact) addContact,
    required TResult Function(int contactId) deleteContact,
    required TResult Function(Contact updatedContact) updateContact,
    required TResult Function() contactUpdated,
    required TResult Function(ContactListSortField sortField, bool ascending)
        sortContacts,
    required TResult Function(int contactId) updateLastContacted,
  }) {
    return addContact(contact);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadContacts,
    TResult? Function(Contact contact)? addContact,
    TResult? Function(int contactId)? deleteContact,
    TResult? Function(Contact updatedContact)? updateContact,
    TResult? Function()? contactUpdated,
    TResult? Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult? Function(int contactId)? updateLastContacted,
  }) {
    return addContact?.call(contact);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadContacts,
    TResult Function(Contact contact)? addContact,
    TResult Function(int contactId)? deleteContact,
    TResult Function(Contact updatedContact)? updateContact,
    TResult Function()? contactUpdated,
    TResult Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult Function(int contactId)? updateLastContacted,
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
    required TResult Function(LoadContacts value) loadContacts,
    required TResult Function(AddContact value) addContact,
    required TResult Function(DeleteContact value) deleteContact,
    required TResult Function(UpdateContact value) updateContact,
    required TResult Function(ContactUpdated value) contactUpdated,
    required TResult Function(SortContacts value) sortContacts,
    required TResult Function(UpdateLastContacted value) updateLastContacted,
  }) {
    return addContact(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadContacts value)? loadContacts,
    TResult? Function(AddContact value)? addContact,
    TResult? Function(DeleteContact value)? deleteContact,
    TResult? Function(UpdateContact value)? updateContact,
    TResult? Function(ContactUpdated value)? contactUpdated,
    TResult? Function(SortContacts value)? sortContacts,
    TResult? Function(UpdateLastContacted value)? updateLastContacted,
  }) {
    return addContact?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadContacts value)? loadContacts,
    TResult Function(AddContact value)? addContact,
    TResult Function(DeleteContact value)? deleteContact,
    TResult Function(UpdateContact value)? updateContact,
    TResult Function(ContactUpdated value)? contactUpdated,
    TResult Function(SortContacts value)? sortContacts,
    TResult Function(UpdateLastContacted value)? updateLastContacted,
    required TResult orElse(),
  }) {
    if (addContact != null) {
      return addContact(this);
    }
    return orElse();
  }
}

abstract class AddContact implements ContactListEvent {
  const factory AddContact(final Contact contact) = _$AddContactImpl;

  Contact get contact;

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddContactImplCopyWith<_$AddContactImpl> get copyWith =>
      throw _privateConstructorUsedError;
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
    extends _$ContactListEventCopyWithImpl<$Res, _$DeleteContactImpl>
    implements _$$DeleteContactImplCopyWith<$Res> {
  __$$DeleteContactImplCopyWithImpl(
      _$DeleteContactImpl _value, $Res Function(_$DeleteContactImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contactId = null,
  }) {
    return _then(_$DeleteContactImpl(
      null == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$DeleteContactImpl implements DeleteContact {
  const _$DeleteContactImpl(this.contactId);

  @override
  final int contactId;

  @override
  String toString() {
    return 'ContactListEvent.deleteContact(contactId: $contactId)';
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

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteContactImplCopyWith<_$DeleteContactImpl> get copyWith =>
      __$$DeleteContactImplCopyWithImpl<_$DeleteContactImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadContacts,
    required TResult Function(Contact contact) addContact,
    required TResult Function(int contactId) deleteContact,
    required TResult Function(Contact updatedContact) updateContact,
    required TResult Function() contactUpdated,
    required TResult Function(ContactListSortField sortField, bool ascending)
        sortContacts,
    required TResult Function(int contactId) updateLastContacted,
  }) {
    return deleteContact(contactId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadContacts,
    TResult? Function(Contact contact)? addContact,
    TResult? Function(int contactId)? deleteContact,
    TResult? Function(Contact updatedContact)? updateContact,
    TResult? Function()? contactUpdated,
    TResult? Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult? Function(int contactId)? updateLastContacted,
  }) {
    return deleteContact?.call(contactId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadContacts,
    TResult Function(Contact contact)? addContact,
    TResult Function(int contactId)? deleteContact,
    TResult Function(Contact updatedContact)? updateContact,
    TResult Function()? contactUpdated,
    TResult Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult Function(int contactId)? updateLastContacted,
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
    required TResult Function(LoadContacts value) loadContacts,
    required TResult Function(AddContact value) addContact,
    required TResult Function(DeleteContact value) deleteContact,
    required TResult Function(UpdateContact value) updateContact,
    required TResult Function(ContactUpdated value) contactUpdated,
    required TResult Function(SortContacts value) sortContacts,
    required TResult Function(UpdateLastContacted value) updateLastContacted,
  }) {
    return deleteContact(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadContacts value)? loadContacts,
    TResult? Function(AddContact value)? addContact,
    TResult? Function(DeleteContact value)? deleteContact,
    TResult? Function(UpdateContact value)? updateContact,
    TResult? Function(ContactUpdated value)? contactUpdated,
    TResult? Function(SortContacts value)? sortContacts,
    TResult? Function(UpdateLastContacted value)? updateLastContacted,
  }) {
    return deleteContact?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadContacts value)? loadContacts,
    TResult Function(AddContact value)? addContact,
    TResult Function(DeleteContact value)? deleteContact,
    TResult Function(UpdateContact value)? updateContact,
    TResult Function(ContactUpdated value)? contactUpdated,
    TResult Function(SortContacts value)? sortContacts,
    TResult Function(UpdateLastContacted value)? updateLastContacted,
    required TResult orElse(),
  }) {
    if (deleteContact != null) {
      return deleteContact(this);
    }
    return orElse();
  }
}

abstract class DeleteContact implements ContactListEvent {
  const factory DeleteContact(final int contactId) = _$DeleteContactImpl;

  int get contactId;

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteContactImplCopyWith<_$DeleteContactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateContactImplCopyWith<$Res> {
  factory _$$UpdateContactImplCopyWith(
          _$UpdateContactImpl value, $Res Function(_$UpdateContactImpl) then) =
      __$$UpdateContactImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Contact updatedContact});

  $ContactCopyWith<$Res> get updatedContact;
}

/// @nodoc
class __$$UpdateContactImplCopyWithImpl<$Res>
    extends _$ContactListEventCopyWithImpl<$Res, _$UpdateContactImpl>
    implements _$$UpdateContactImplCopyWith<$Res> {
  __$$UpdateContactImplCopyWithImpl(
      _$UpdateContactImpl _value, $Res Function(_$UpdateContactImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? updatedContact = null,
  }) {
    return _then(_$UpdateContactImpl(
      null == updatedContact
          ? _value.updatedContact
          : updatedContact // ignore: cast_nullable_to_non_nullable
              as Contact,
    ));
  }

  /// Create a copy of ContactListEvent
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

class _$UpdateContactImpl implements UpdateContact {
  const _$UpdateContactImpl(this.updatedContact);

  @override
  final Contact updatedContact;

  @override
  String toString() {
    return 'ContactListEvent.updateContact(updatedContact: $updatedContact)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateContactImpl &&
            (identical(other.updatedContact, updatedContact) ||
                other.updatedContact == updatedContact));
  }

  @override
  int get hashCode => Object.hash(runtimeType, updatedContact);

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateContactImplCopyWith<_$UpdateContactImpl> get copyWith =>
      __$$UpdateContactImplCopyWithImpl<_$UpdateContactImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadContacts,
    required TResult Function(Contact contact) addContact,
    required TResult Function(int contactId) deleteContact,
    required TResult Function(Contact updatedContact) updateContact,
    required TResult Function() contactUpdated,
    required TResult Function(ContactListSortField sortField, bool ascending)
        sortContacts,
    required TResult Function(int contactId) updateLastContacted,
  }) {
    return updateContact(updatedContact);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadContacts,
    TResult? Function(Contact contact)? addContact,
    TResult? Function(int contactId)? deleteContact,
    TResult? Function(Contact updatedContact)? updateContact,
    TResult? Function()? contactUpdated,
    TResult? Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult? Function(int contactId)? updateLastContacted,
  }) {
    return updateContact?.call(updatedContact);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadContacts,
    TResult Function(Contact contact)? addContact,
    TResult Function(int contactId)? deleteContact,
    TResult Function(Contact updatedContact)? updateContact,
    TResult Function()? contactUpdated,
    TResult Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult Function(int contactId)? updateLastContacted,
    required TResult orElse(),
  }) {
    if (updateContact != null) {
      return updateContact(updatedContact);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadContacts value) loadContacts,
    required TResult Function(AddContact value) addContact,
    required TResult Function(DeleteContact value) deleteContact,
    required TResult Function(UpdateContact value) updateContact,
    required TResult Function(ContactUpdated value) contactUpdated,
    required TResult Function(SortContacts value) sortContacts,
    required TResult Function(UpdateLastContacted value) updateLastContacted,
  }) {
    return updateContact(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadContacts value)? loadContacts,
    TResult? Function(AddContact value)? addContact,
    TResult? Function(DeleteContact value)? deleteContact,
    TResult? Function(UpdateContact value)? updateContact,
    TResult? Function(ContactUpdated value)? contactUpdated,
    TResult? Function(SortContacts value)? sortContacts,
    TResult? Function(UpdateLastContacted value)? updateLastContacted,
  }) {
    return updateContact?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadContacts value)? loadContacts,
    TResult Function(AddContact value)? addContact,
    TResult Function(DeleteContact value)? deleteContact,
    TResult Function(UpdateContact value)? updateContact,
    TResult Function(ContactUpdated value)? contactUpdated,
    TResult Function(SortContacts value)? sortContacts,
    TResult Function(UpdateLastContacted value)? updateLastContacted,
    required TResult orElse(),
  }) {
    if (updateContact != null) {
      return updateContact(this);
    }
    return orElse();
  }
}

abstract class UpdateContact implements ContactListEvent {
  const factory UpdateContact(final Contact updatedContact) =
      _$UpdateContactImpl;

  Contact get updatedContact;

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateContactImplCopyWith<_$UpdateContactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ContactUpdatedImplCopyWith<$Res> {
  factory _$$ContactUpdatedImplCopyWith(_$ContactUpdatedImpl value,
          $Res Function(_$ContactUpdatedImpl) then) =
      __$$ContactUpdatedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ContactUpdatedImplCopyWithImpl<$Res>
    extends _$ContactListEventCopyWithImpl<$Res, _$ContactUpdatedImpl>
    implements _$$ContactUpdatedImplCopyWith<$Res> {
  __$$ContactUpdatedImplCopyWithImpl(
      _$ContactUpdatedImpl _value, $Res Function(_$ContactUpdatedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ContactUpdatedImpl implements ContactUpdated {
  const _$ContactUpdatedImpl();

  @override
  String toString() {
    return 'ContactListEvent.contactUpdated()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ContactUpdatedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadContacts,
    required TResult Function(Contact contact) addContact,
    required TResult Function(int contactId) deleteContact,
    required TResult Function(Contact updatedContact) updateContact,
    required TResult Function() contactUpdated,
    required TResult Function(ContactListSortField sortField, bool ascending)
        sortContacts,
    required TResult Function(int contactId) updateLastContacted,
  }) {
    return contactUpdated();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadContacts,
    TResult? Function(Contact contact)? addContact,
    TResult? Function(int contactId)? deleteContact,
    TResult? Function(Contact updatedContact)? updateContact,
    TResult? Function()? contactUpdated,
    TResult? Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult? Function(int contactId)? updateLastContacted,
  }) {
    return contactUpdated?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadContacts,
    TResult Function(Contact contact)? addContact,
    TResult Function(int contactId)? deleteContact,
    TResult Function(Contact updatedContact)? updateContact,
    TResult Function()? contactUpdated,
    TResult Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult Function(int contactId)? updateLastContacted,
    required TResult orElse(),
  }) {
    if (contactUpdated != null) {
      return contactUpdated();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadContacts value) loadContacts,
    required TResult Function(AddContact value) addContact,
    required TResult Function(DeleteContact value) deleteContact,
    required TResult Function(UpdateContact value) updateContact,
    required TResult Function(ContactUpdated value) contactUpdated,
    required TResult Function(SortContacts value) sortContacts,
    required TResult Function(UpdateLastContacted value) updateLastContacted,
  }) {
    return contactUpdated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadContacts value)? loadContacts,
    TResult? Function(AddContact value)? addContact,
    TResult? Function(DeleteContact value)? deleteContact,
    TResult? Function(UpdateContact value)? updateContact,
    TResult? Function(ContactUpdated value)? contactUpdated,
    TResult? Function(SortContacts value)? sortContacts,
    TResult? Function(UpdateLastContacted value)? updateLastContacted,
  }) {
    return contactUpdated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadContacts value)? loadContacts,
    TResult Function(AddContact value)? addContact,
    TResult Function(DeleteContact value)? deleteContact,
    TResult Function(UpdateContact value)? updateContact,
    TResult Function(ContactUpdated value)? contactUpdated,
    TResult Function(SortContacts value)? sortContacts,
    TResult Function(UpdateLastContacted value)? updateLastContacted,
    required TResult orElse(),
  }) {
    if (contactUpdated != null) {
      return contactUpdated(this);
    }
    return orElse();
  }
}

abstract class ContactUpdated implements ContactListEvent {
  const factory ContactUpdated() = _$ContactUpdatedImpl;
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

class _$SortContactsImpl implements SortContacts {
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
    required TResult Function(Contact contact) addContact,
    required TResult Function(int contactId) deleteContact,
    required TResult Function(Contact updatedContact) updateContact,
    required TResult Function() contactUpdated,
    required TResult Function(ContactListSortField sortField, bool ascending)
        sortContacts,
    required TResult Function(int contactId) updateLastContacted,
  }) {
    return sortContacts(sortField, ascending);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadContacts,
    TResult? Function(Contact contact)? addContact,
    TResult? Function(int contactId)? deleteContact,
    TResult? Function(Contact updatedContact)? updateContact,
    TResult? Function()? contactUpdated,
    TResult? Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult? Function(int contactId)? updateLastContacted,
  }) {
    return sortContacts?.call(sortField, ascending);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadContacts,
    TResult Function(Contact contact)? addContact,
    TResult Function(int contactId)? deleteContact,
    TResult Function(Contact updatedContact)? updateContact,
    TResult Function()? contactUpdated,
    TResult Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult Function(int contactId)? updateLastContacted,
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
    required TResult Function(LoadContacts value) loadContacts,
    required TResult Function(AddContact value) addContact,
    required TResult Function(DeleteContact value) deleteContact,
    required TResult Function(UpdateContact value) updateContact,
    required TResult Function(ContactUpdated value) contactUpdated,
    required TResult Function(SortContacts value) sortContacts,
    required TResult Function(UpdateLastContacted value) updateLastContacted,
  }) {
    return sortContacts(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadContacts value)? loadContacts,
    TResult? Function(AddContact value)? addContact,
    TResult? Function(DeleteContact value)? deleteContact,
    TResult? Function(UpdateContact value)? updateContact,
    TResult? Function(ContactUpdated value)? contactUpdated,
    TResult? Function(SortContacts value)? sortContacts,
    TResult? Function(UpdateLastContacted value)? updateLastContacted,
  }) {
    return sortContacts?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadContacts value)? loadContacts,
    TResult Function(AddContact value)? addContact,
    TResult Function(DeleteContact value)? deleteContact,
    TResult Function(UpdateContact value)? updateContact,
    TResult Function(ContactUpdated value)? contactUpdated,
    TResult Function(SortContacts value)? sortContacts,
    TResult Function(UpdateLastContacted value)? updateLastContacted,
    required TResult orElse(),
  }) {
    if (sortContacts != null) {
      return sortContacts(this);
    }
    return orElse();
  }
}

abstract class SortContacts implements ContactListEvent {
  const factory SortContacts(
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
abstract class _$$UpdateLastContactedImplCopyWith<$Res> {
  factory _$$UpdateLastContactedImplCopyWith(_$UpdateLastContactedImpl value,
          $Res Function(_$UpdateLastContactedImpl) then) =
      __$$UpdateLastContactedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int contactId});
}

/// @nodoc
class __$$UpdateLastContactedImplCopyWithImpl<$Res>
    extends _$ContactListEventCopyWithImpl<$Res, _$UpdateLastContactedImpl>
    implements _$$UpdateLastContactedImplCopyWith<$Res> {
  __$$UpdateLastContactedImplCopyWithImpl(_$UpdateLastContactedImpl _value,
      $Res Function(_$UpdateLastContactedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contactId = null,
  }) {
    return _then(_$UpdateLastContactedImpl(
      contactId: null == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$UpdateLastContactedImpl implements UpdateLastContacted {
  const _$UpdateLastContactedImpl({required this.contactId});

  @override
  final int contactId;

  @override
  String toString() {
    return 'ContactListEvent.updateLastContacted(contactId: $contactId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateLastContactedImpl &&
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
  _$$UpdateLastContactedImplCopyWith<_$UpdateLastContactedImpl> get copyWith =>
      __$$UpdateLastContactedImplCopyWithImpl<_$UpdateLastContactedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadContacts,
    required TResult Function(Contact contact) addContact,
    required TResult Function(int contactId) deleteContact,
    required TResult Function(Contact updatedContact) updateContact,
    required TResult Function() contactUpdated,
    required TResult Function(ContactListSortField sortField, bool ascending)
        sortContacts,
    required TResult Function(int contactId) updateLastContacted,
  }) {
    return updateLastContacted(contactId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadContacts,
    TResult? Function(Contact contact)? addContact,
    TResult? Function(int contactId)? deleteContact,
    TResult? Function(Contact updatedContact)? updateContact,
    TResult? Function()? contactUpdated,
    TResult? Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult? Function(int contactId)? updateLastContacted,
  }) {
    return updateLastContacted?.call(contactId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadContacts,
    TResult Function(Contact contact)? addContact,
    TResult Function(int contactId)? deleteContact,
    TResult Function(Contact updatedContact)? updateContact,
    TResult Function()? contactUpdated,
    TResult Function(ContactListSortField sortField, bool ascending)?
        sortContacts,
    TResult Function(int contactId)? updateLastContacted,
    required TResult orElse(),
  }) {
    if (updateLastContacted != null) {
      return updateLastContacted(contactId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadContacts value) loadContacts,
    required TResult Function(AddContact value) addContact,
    required TResult Function(DeleteContact value) deleteContact,
    required TResult Function(UpdateContact value) updateContact,
    required TResult Function(ContactUpdated value) contactUpdated,
    required TResult Function(SortContacts value) sortContacts,
    required TResult Function(UpdateLastContacted value) updateLastContacted,
  }) {
    return updateLastContacted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadContacts value)? loadContacts,
    TResult? Function(AddContact value)? addContact,
    TResult? Function(DeleteContact value)? deleteContact,
    TResult? Function(UpdateContact value)? updateContact,
    TResult? Function(ContactUpdated value)? contactUpdated,
    TResult? Function(SortContacts value)? sortContacts,
    TResult? Function(UpdateLastContacted value)? updateLastContacted,
  }) {
    return updateLastContacted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadContacts value)? loadContacts,
    TResult Function(AddContact value)? addContact,
    TResult Function(DeleteContact value)? deleteContact,
    TResult Function(UpdateContact value)? updateContact,
    TResult Function(ContactUpdated value)? contactUpdated,
    TResult Function(SortContacts value)? sortContacts,
    TResult Function(UpdateLastContacted value)? updateLastContacted,
    required TResult orElse(),
  }) {
    if (updateLastContacted != null) {
      return updateLastContacted(this);
    }
    return orElse();
  }
}

abstract class UpdateLastContacted implements ContactListEvent {
  const factory UpdateLastContacted({required final int contactId}) =
      _$UpdateLastContactedImpl;

  int get contactId;

  /// Create a copy of ContactListEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateLastContactedImplCopyWith<_$UpdateLastContactedImpl> get copyWith =>
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
    required TResult Function(ContactListInitial value) initial,
    required TResult Function(ContactListEmpty value) empty,
    required TResult Function(ContactListLoading value) loading,
    required TResult Function(ContactListLoaded value) loaded,
    required TResult Function(ContactListError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ContactListInitial value)? initial,
    TResult? Function(ContactListEmpty value)? empty,
    TResult? Function(ContactListLoading value)? loading,
    TResult? Function(ContactListLoaded value)? loaded,
    TResult? Function(ContactListError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ContactListInitial value)? initial,
    TResult Function(ContactListEmpty value)? empty,
    TResult Function(ContactListLoading value)? loading,
    TResult Function(ContactListLoaded value)? loaded,
    TResult Function(ContactListError value)? error,
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
abstract class _$$ContactListInitialImplCopyWith<$Res> {
  factory _$$ContactListInitialImplCopyWith(_$ContactListInitialImpl value,
          $Res Function(_$ContactListInitialImpl) then) =
      __$$ContactListInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ContactListInitialImplCopyWithImpl<$Res>
    extends _$ContactListStateCopyWithImpl<$Res, _$ContactListInitialImpl>
    implements _$$ContactListInitialImplCopyWith<$Res> {
  __$$ContactListInitialImplCopyWithImpl(_$ContactListInitialImpl _value,
      $Res Function(_$ContactListInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactListState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ContactListInitialImpl implements ContactListInitial {
  const _$ContactListInitialImpl();

  @override
  String toString() {
    return 'ContactListState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ContactListInitialImpl);
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
    required TResult Function(ContactListInitial value) initial,
    required TResult Function(ContactListEmpty value) empty,
    required TResult Function(ContactListLoading value) loading,
    required TResult Function(ContactListLoaded value) loaded,
    required TResult Function(ContactListError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ContactListInitial value)? initial,
    TResult? Function(ContactListEmpty value)? empty,
    TResult? Function(ContactListLoading value)? loading,
    TResult? Function(ContactListLoaded value)? loaded,
    TResult? Function(ContactListError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ContactListInitial value)? initial,
    TResult Function(ContactListEmpty value)? empty,
    TResult Function(ContactListLoading value)? loading,
    TResult Function(ContactListLoaded value)? loaded,
    TResult Function(ContactListError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class ContactListInitial implements ContactListState {
  const factory ContactListInitial() = _$ContactListInitialImpl;
}

/// @nodoc
abstract class _$$ContactListEmptyImplCopyWith<$Res> {
  factory _$$ContactListEmptyImplCopyWith(_$ContactListEmptyImpl value,
          $Res Function(_$ContactListEmptyImpl) then) =
      __$$ContactListEmptyImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ContactListEmptyImplCopyWithImpl<$Res>
    extends _$ContactListStateCopyWithImpl<$Res, _$ContactListEmptyImpl>
    implements _$$ContactListEmptyImplCopyWith<$Res> {
  __$$ContactListEmptyImplCopyWithImpl(_$ContactListEmptyImpl _value,
      $Res Function(_$ContactListEmptyImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactListState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ContactListEmptyImpl implements ContactListEmpty {
  const _$ContactListEmptyImpl();

  @override
  String toString() {
    return 'ContactListState.empty()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ContactListEmptyImpl);
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
    required TResult Function(ContactListInitial value) initial,
    required TResult Function(ContactListEmpty value) empty,
    required TResult Function(ContactListLoading value) loading,
    required TResult Function(ContactListLoaded value) loaded,
    required TResult Function(ContactListError value) error,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ContactListInitial value)? initial,
    TResult? Function(ContactListEmpty value)? empty,
    TResult? Function(ContactListLoading value)? loading,
    TResult? Function(ContactListLoaded value)? loaded,
    TResult? Function(ContactListError value)? error,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ContactListInitial value)? initial,
    TResult Function(ContactListEmpty value)? empty,
    TResult Function(ContactListLoading value)? loading,
    TResult Function(ContactListLoaded value)? loaded,
    TResult Function(ContactListError value)? error,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class ContactListEmpty implements ContactListState {
  const factory ContactListEmpty() = _$ContactListEmptyImpl;
}

/// @nodoc
abstract class _$$ContactListLoadingImplCopyWith<$Res> {
  factory _$$ContactListLoadingImplCopyWith(_$ContactListLoadingImpl value,
          $Res Function(_$ContactListLoadingImpl) then) =
      __$$ContactListLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ContactListLoadingImplCopyWithImpl<$Res>
    extends _$ContactListStateCopyWithImpl<$Res, _$ContactListLoadingImpl>
    implements _$$ContactListLoadingImplCopyWith<$Res> {
  __$$ContactListLoadingImplCopyWithImpl(_$ContactListLoadingImpl _value,
      $Res Function(_$ContactListLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactListState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ContactListLoadingImpl implements ContactListLoading {
  const _$ContactListLoadingImpl();

  @override
  String toString() {
    return 'ContactListState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ContactListLoadingImpl);
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
    required TResult Function(ContactListInitial value) initial,
    required TResult Function(ContactListEmpty value) empty,
    required TResult Function(ContactListLoading value) loading,
    required TResult Function(ContactListLoaded value) loaded,
    required TResult Function(ContactListError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ContactListInitial value)? initial,
    TResult? Function(ContactListEmpty value)? empty,
    TResult? Function(ContactListLoading value)? loading,
    TResult? Function(ContactListLoaded value)? loaded,
    TResult? Function(ContactListError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ContactListInitial value)? initial,
    TResult Function(ContactListEmpty value)? empty,
    TResult Function(ContactListLoading value)? loading,
    TResult Function(ContactListLoaded value)? loaded,
    TResult Function(ContactListError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class ContactListLoading implements ContactListState {
  const factory ContactListLoading() = _$ContactListLoadingImpl;
}

/// @nodoc
abstract class _$$ContactListLoadedImplCopyWith<$Res> {
  factory _$$ContactListLoadedImplCopyWith(_$ContactListLoadedImpl value,
          $Res Function(_$ContactListLoadedImpl) then) =
      __$$ContactListLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {List<Contact> contacts, ContactListSortField sortField, bool ascending});
}

/// @nodoc
class __$$ContactListLoadedImplCopyWithImpl<$Res>
    extends _$ContactListStateCopyWithImpl<$Res, _$ContactListLoadedImpl>
    implements _$$ContactListLoadedImplCopyWith<$Res> {
  __$$ContactListLoadedImplCopyWithImpl(_$ContactListLoadedImpl _value,
      $Res Function(_$ContactListLoadedImpl) _then)
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
    return _then(_$ContactListLoadedImpl(
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

class _$ContactListLoadedImpl implements ContactListLoaded {
  const _$ContactListLoadedImpl(
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
            other is _$ContactListLoadedImpl &&
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
  _$$ContactListLoadedImplCopyWith<_$ContactListLoadedImpl> get copyWith =>
      __$$ContactListLoadedImplCopyWithImpl<_$ContactListLoadedImpl>(
          this, _$identity);

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
    required TResult Function(ContactListInitial value) initial,
    required TResult Function(ContactListEmpty value) empty,
    required TResult Function(ContactListLoading value) loading,
    required TResult Function(ContactListLoaded value) loaded,
    required TResult Function(ContactListError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ContactListInitial value)? initial,
    TResult? Function(ContactListEmpty value)? empty,
    TResult? Function(ContactListLoading value)? loading,
    TResult? Function(ContactListLoaded value)? loaded,
    TResult? Function(ContactListError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ContactListInitial value)? initial,
    TResult Function(ContactListEmpty value)? empty,
    TResult Function(ContactListLoading value)? loading,
    TResult Function(ContactListLoaded value)? loaded,
    TResult Function(ContactListError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class ContactListLoaded implements ContactListState {
  const factory ContactListLoaded(
      {required final List<Contact> contacts,
      final ContactListSortField sortField,
      final bool ascending}) = _$ContactListLoadedImpl;

  List<Contact> get contacts;
  ContactListSortField get sortField;
  bool get ascending;

  /// Create a copy of ContactListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactListLoadedImplCopyWith<_$ContactListLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ContactListErrorImplCopyWith<$Res> {
  factory _$$ContactListErrorImplCopyWith(_$ContactListErrorImpl value,
          $Res Function(_$ContactListErrorImpl) then) =
      __$$ContactListErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ContactListErrorImplCopyWithImpl<$Res>
    extends _$ContactListStateCopyWithImpl<$Res, _$ContactListErrorImpl>
    implements _$$ContactListErrorImplCopyWith<$Res> {
  __$$ContactListErrorImplCopyWithImpl(_$ContactListErrorImpl _value,
      $Res Function(_$ContactListErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ContactListErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ContactListErrorImpl implements ContactListError {
  const _$ContactListErrorImpl(this.message);

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
            other is _$ContactListErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ContactListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactListErrorImplCopyWith<_$ContactListErrorImpl> get copyWith =>
      __$$ContactListErrorImplCopyWithImpl<_$ContactListErrorImpl>(
          this, _$identity);

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
    required TResult Function(ContactListInitial value) initial,
    required TResult Function(ContactListEmpty value) empty,
    required TResult Function(ContactListLoading value) loading,
    required TResult Function(ContactListLoaded value) loaded,
    required TResult Function(ContactListError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ContactListInitial value)? initial,
    TResult? Function(ContactListEmpty value)? empty,
    TResult? Function(ContactListLoading value)? loading,
    TResult? Function(ContactListLoaded value)? loaded,
    TResult? Function(ContactListError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ContactListInitial value)? initial,
    TResult Function(ContactListEmpty value)? empty,
    TResult Function(ContactListLoading value)? loading,
    TResult Function(ContactListLoaded value)? loaded,
    TResult Function(ContactListError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ContactListError implements ContactListState {
  const factory ContactListError(final String message) = _$ContactListErrorImpl;

  String get message;

  /// Create a copy of ContactListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactListErrorImplCopyWith<_$ContactListErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
