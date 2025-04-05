// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Contact _$ContactFromJson(Map<String, dynamic> json) {
  return _Contact.fromJson(json);
}

/// @nodoc
mixin _$Contact {
  @Id(assignable: true)
  int? get id => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String get frequency =>
      throw _privateConstructorUsedError; // Store the String representation
  @Property(type: PropertyType.date)
  DateTime? get birthday => throw _privateConstructorUsedError;
  @Property(type: PropertyType.date)
  DateTime? get lastContacted => throw _privateConstructorUsedError;
  @Property(type: PropertyType.date)
  DateTime? get anniversary => throw _privateConstructorUsedError;
  String? get phoneNumber =>
      throw _privateConstructorUsedError; // Single phone number (optional)
  List<String>? get emails =>
      throw _privateConstructorUsedError; // List of emails (optional)
  String? get notes =>
      throw _privateConstructorUsedError; // Notes field (optional)
// Specific Social Media Fields (optional Strings)
  String? get youtubeUrl => throw _privateConstructorUsedError;
  String? get instagramHandle => throw _privateConstructorUsedError;
  String? get facebookUrl => throw _privateConstructorUsedError;
  String? get snapchatHandle => throw _privateConstructorUsedError;
  String? get tikTokHandle => throw _privateConstructorUsedError;

  /// Serializes this Contact to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Contact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactCopyWith<Contact> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactCopyWith<$Res> {
  factory $ContactCopyWith(Contact value, $Res Function(Contact) then) =
      _$ContactCopyWithImpl<$Res, Contact>;
  @useResult
  $Res call(
      {@Id(assignable: true) int? id,
      String firstName,
      String lastName,
      String frequency,
      @Property(type: PropertyType.date) DateTime? birthday,
      @Property(type: PropertyType.date) DateTime? lastContacted,
      @Property(type: PropertyType.date) DateTime? anniversary,
      String? phoneNumber,
      List<String>? emails,
      String? notes,
      String? youtubeUrl,
      String? instagramHandle,
      String? facebookUrl,
      String? snapchatHandle,
      String? tikTokHandle});
}

/// @nodoc
class _$ContactCopyWithImpl<$Res, $Val extends Contact>
    implements $ContactCopyWith<$Res> {
  _$ContactCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Contact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? firstName = null,
    Object? lastName = null,
    Object? frequency = null,
    Object? birthday = freezed,
    Object? lastContacted = freezed,
    Object? anniversary = freezed,
    Object? phoneNumber = freezed,
    Object? emails = freezed,
    Object? notes = freezed,
    Object? youtubeUrl = freezed,
    Object? instagramHandle = freezed,
    Object? facebookUrl = freezed,
    Object? snapchatHandle = freezed,
    Object? tikTokHandle = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String,
      birthday: freezed == birthday
          ? _value.birthday
          : birthday // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastContacted: freezed == lastContacted
          ? _value.lastContacted
          : lastContacted // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      anniversary: freezed == anniversary
          ? _value.anniversary
          : anniversary // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      emails: freezed == emails
          ? _value.emails
          : emails // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      youtubeUrl: freezed == youtubeUrl
          ? _value.youtubeUrl
          : youtubeUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      instagramHandle: freezed == instagramHandle
          ? _value.instagramHandle
          : instagramHandle // ignore: cast_nullable_to_non_nullable
              as String?,
      facebookUrl: freezed == facebookUrl
          ? _value.facebookUrl
          : facebookUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      snapchatHandle: freezed == snapchatHandle
          ? _value.snapchatHandle
          : snapchatHandle // ignore: cast_nullable_to_non_nullable
              as String?,
      tikTokHandle: freezed == tikTokHandle
          ? _value.tikTokHandle
          : tikTokHandle // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContactImplCopyWith<$Res> implements $ContactCopyWith<$Res> {
  factory _$$ContactImplCopyWith(
          _$ContactImpl value, $Res Function(_$ContactImpl) then) =
      __$$ContactImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@Id(assignable: true) int? id,
      String firstName,
      String lastName,
      String frequency,
      @Property(type: PropertyType.date) DateTime? birthday,
      @Property(type: PropertyType.date) DateTime? lastContacted,
      @Property(type: PropertyType.date) DateTime? anniversary,
      String? phoneNumber,
      List<String>? emails,
      String? notes,
      String? youtubeUrl,
      String? instagramHandle,
      String? facebookUrl,
      String? snapchatHandle,
      String? tikTokHandle});
}

/// @nodoc
class __$$ContactImplCopyWithImpl<$Res>
    extends _$ContactCopyWithImpl<$Res, _$ContactImpl>
    implements _$$ContactImplCopyWith<$Res> {
  __$$ContactImplCopyWithImpl(
      _$ContactImpl _value, $Res Function(_$ContactImpl) _then)
      : super(_value, _then);

  /// Create a copy of Contact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? firstName = null,
    Object? lastName = null,
    Object? frequency = null,
    Object? birthday = freezed,
    Object? lastContacted = freezed,
    Object? anniversary = freezed,
    Object? phoneNumber = freezed,
    Object? emails = freezed,
    Object? notes = freezed,
    Object? youtubeUrl = freezed,
    Object? instagramHandle = freezed,
    Object? facebookUrl = freezed,
    Object? snapchatHandle = freezed,
    Object? tikTokHandle = freezed,
  }) {
    return _then(_$ContactImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String,
      birthday: freezed == birthday
          ? _value.birthday
          : birthday // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastContacted: freezed == lastContacted
          ? _value.lastContacted
          : lastContacted // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      anniversary: freezed == anniversary
          ? _value.anniversary
          : anniversary // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      emails: freezed == emails
          ? _value._emails
          : emails // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      youtubeUrl: freezed == youtubeUrl
          ? _value.youtubeUrl
          : youtubeUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      instagramHandle: freezed == instagramHandle
          ? _value.instagramHandle
          : instagramHandle // ignore: cast_nullable_to_non_nullable
              as String?,
      facebookUrl: freezed == facebookUrl
          ? _value.facebookUrl
          : facebookUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      snapchatHandle: freezed == snapchatHandle
          ? _value.snapchatHandle
          : snapchatHandle // ignore: cast_nullable_to_non_nullable
              as String?,
      tikTokHandle: freezed == tikTokHandle
          ? _value.tikTokHandle
          : tikTokHandle // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@Entity(realClass: Contact)
class _$ContactImpl extends _Contact with DiagnosticableTreeMixin {
  _$ContactImpl(
      {@Id(assignable: true) this.id,
      required this.firstName,
      required this.lastName,
      this.frequency = ContactFrequency.defaultValue,
      @Property(type: PropertyType.date) this.birthday,
      @Property(type: PropertyType.date) this.lastContacted,
      @Property(type: PropertyType.date) this.anniversary,
      this.phoneNumber,
      final List<String>? emails,
      this.notes,
      this.youtubeUrl,
      this.instagramHandle,
      this.facebookUrl,
      this.snapchatHandle,
      this.tikTokHandle})
      : _emails = emails,
        super._();

  factory _$ContactImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactImplFromJson(json);

  @override
  @Id(assignable: true)
  final int? id;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  @JsonKey()
  final String frequency;
// Store the String representation
  @override
  @Property(type: PropertyType.date)
  final DateTime? birthday;
  @override
  @Property(type: PropertyType.date)
  final DateTime? lastContacted;
  @override
  @Property(type: PropertyType.date)
  final DateTime? anniversary;
  @override
  final String? phoneNumber;
// Single phone number (optional)
  final List<String>? _emails;
// Single phone number (optional)
  @override
  List<String>? get emails {
    final value = _emails;
    if (value == null) return null;
    if (_emails is EqualUnmodifiableListView) return _emails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// List of emails (optional)
  @override
  final String? notes;
// Notes field (optional)
// Specific Social Media Fields (optional Strings)
  @override
  final String? youtubeUrl;
  @override
  final String? instagramHandle;
  @override
  final String? facebookUrl;
  @override
  final String? snapchatHandle;
  @override
  final String? tikTokHandle;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Contact(id: $id, firstName: $firstName, lastName: $lastName, frequency: $frequency, birthday: $birthday, lastContacted: $lastContacted, anniversary: $anniversary, phoneNumber: $phoneNumber, emails: $emails, notes: $notes, youtubeUrl: $youtubeUrl, instagramHandle: $instagramHandle, facebookUrl: $facebookUrl, snapchatHandle: $snapchatHandle, tikTokHandle: $tikTokHandle)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Contact'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('firstName', firstName))
      ..add(DiagnosticsProperty('lastName', lastName))
      ..add(DiagnosticsProperty('frequency', frequency))
      ..add(DiagnosticsProperty('birthday', birthday))
      ..add(DiagnosticsProperty('lastContacted', lastContacted))
      ..add(DiagnosticsProperty('anniversary', anniversary))
      ..add(DiagnosticsProperty('phoneNumber', phoneNumber))
      ..add(DiagnosticsProperty('emails', emails))
      ..add(DiagnosticsProperty('notes', notes))
      ..add(DiagnosticsProperty('youtubeUrl', youtubeUrl))
      ..add(DiagnosticsProperty('instagramHandle', instagramHandle))
      ..add(DiagnosticsProperty('facebookUrl', facebookUrl))
      ..add(DiagnosticsProperty('snapchatHandle', snapchatHandle))
      ..add(DiagnosticsProperty('tikTokHandle', tikTokHandle));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.birthday, birthday) ||
                other.birthday == birthday) &&
            (identical(other.lastContacted, lastContacted) ||
                other.lastContacted == lastContacted) &&
            (identical(other.anniversary, anniversary) ||
                other.anniversary == anniversary) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            const DeepCollectionEquality().equals(other._emails, _emails) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.youtubeUrl, youtubeUrl) ||
                other.youtubeUrl == youtubeUrl) &&
            (identical(other.instagramHandle, instagramHandle) ||
                other.instagramHandle == instagramHandle) &&
            (identical(other.facebookUrl, facebookUrl) ||
                other.facebookUrl == facebookUrl) &&
            (identical(other.snapchatHandle, snapchatHandle) ||
                other.snapchatHandle == snapchatHandle) &&
            (identical(other.tikTokHandle, tikTokHandle) ||
                other.tikTokHandle == tikTokHandle));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      firstName,
      lastName,
      frequency,
      birthday,
      lastContacted,
      anniversary,
      phoneNumber,
      const DeepCollectionEquality().hash(_emails),
      notes,
      youtubeUrl,
      instagramHandle,
      facebookUrl,
      snapchatHandle,
      tikTokHandle);

  /// Create a copy of Contact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactImplCopyWith<_$ContactImpl> get copyWith =>
      __$$ContactImplCopyWithImpl<_$ContactImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactImplToJson(
      this,
    );
  }
}

abstract class _Contact extends Contact {
  factory _Contact(
      {@Id(assignable: true) final int? id,
      required final String firstName,
      required final String lastName,
      final String frequency,
      @Property(type: PropertyType.date) final DateTime? birthday,
      @Property(type: PropertyType.date) final DateTime? lastContacted,
      @Property(type: PropertyType.date) final DateTime? anniversary,
      final String? phoneNumber,
      final List<String>? emails,
      final String? notes,
      final String? youtubeUrl,
      final String? instagramHandle,
      final String? facebookUrl,
      final String? snapchatHandle,
      final String? tikTokHandle}) = _$ContactImpl;
  _Contact._() : super._();

  factory _Contact.fromJson(Map<String, dynamic> json) = _$ContactImpl.fromJson;

  @override
  @Id(assignable: true)
  int? get id;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String get frequency; // Store the String representation
  @override
  @Property(type: PropertyType.date)
  DateTime? get birthday;
  @override
  @Property(type: PropertyType.date)
  DateTime? get lastContacted;
  @override
  @Property(type: PropertyType.date)
  DateTime? get anniversary;
  @override
  String? get phoneNumber; // Single phone number (optional)
  @override
  List<String>? get emails; // List of emails (optional)
  @override
  String? get notes; // Notes field (optional)
// Specific Social Media Fields (optional Strings)
  @override
  String? get youtubeUrl;
  @override
  String? get instagramHandle;
  @override
  String? get facebookUrl;
  @override
  String? get snapchatHandle;
  @override
  String? get tikTokHandle;

  /// Create a copy of Contact
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactImplCopyWith<_$ContactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
