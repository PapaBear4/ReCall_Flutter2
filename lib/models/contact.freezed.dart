// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Contact implements DiagnosticableTreeMixin {
  @Id(assignable: true)
  int? get id;
  String get firstName;
  String get lastName;
  String? get nickname;
  String get frequency; // Store the String representation
  @Property(type: PropertyType.date)
  DateTime? get birthday;
  @Property(type: PropertyType.date)
  DateTime? get lastContacted;
  @Property(type: PropertyType.date)
  DateTime? get anniversary;
  String? get phoneNumber; // Single phone number (optional)
  List<String>? get emails; // List of emails (optional)
  String? get notes; // Notes field (optional)
// Specific Social Media Fields (optional Strings)
  String? get youtubeUrl;
  String? get instagramHandle;
  String? get facebookUrl;
  String? get snapchatHandle;
  String? get xHandle;
  String? get linkedInUrl;

  /// Create a copy of Contact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ContactCopyWith<Contact> get copyWith =>
      _$ContactCopyWithImpl<Contact>(this as Contact, _$identity);

  /// Serializes this Contact to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'Contact'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('firstName', firstName))
      ..add(DiagnosticsProperty('lastName', lastName))
      ..add(DiagnosticsProperty('nickname', nickname))
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
      ..add(DiagnosticsProperty('xHandle', xHandle))
      ..add(DiagnosticsProperty('linkedInUrl', linkedInUrl));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Contact &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
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
            const DeepCollectionEquality().equals(other.emails, emails) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.youtubeUrl, youtubeUrl) ||
                other.youtubeUrl == youtubeUrl) &&
            (identical(other.instagramHandle, instagramHandle) ||
                other.instagramHandle == instagramHandle) &&
            (identical(other.facebookUrl, facebookUrl) ||
                other.facebookUrl == facebookUrl) &&
            (identical(other.snapchatHandle, snapchatHandle) ||
                other.snapchatHandle == snapchatHandle) &&
            (identical(other.xHandle, xHandle) || other.xHandle == xHandle) &&
            (identical(other.linkedInUrl, linkedInUrl) ||
                other.linkedInUrl == linkedInUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      firstName,
      lastName,
      nickname,
      frequency,
      birthday,
      lastContacted,
      anniversary,
      phoneNumber,
      const DeepCollectionEquality().hash(emails),
      notes,
      youtubeUrl,
      instagramHandle,
      facebookUrl,
      snapchatHandle,
      xHandle,
      linkedInUrl);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Contact(id: $id, firstName: $firstName, lastName: $lastName, nickname: $nickname, frequency: $frequency, birthday: $birthday, lastContacted: $lastContacted, anniversary: $anniversary, phoneNumber: $phoneNumber, emails: $emails, notes: $notes, youtubeUrl: $youtubeUrl, instagramHandle: $instagramHandle, facebookUrl: $facebookUrl, snapchatHandle: $snapchatHandle, xHandle: $xHandle, linkedInUrl: $linkedInUrl)';
  }
}

/// @nodoc
abstract mixin class $ContactCopyWith<$Res> {
  factory $ContactCopyWith(Contact value, $Res Function(Contact) _then) =
      _$ContactCopyWithImpl;
  @useResult
  $Res call(
      {@Id(assignable: true) int? id,
      String firstName,
      String lastName,
      String? nickname,
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
      String? xHandle,
      String? linkedInUrl});
}

/// @nodoc
class _$ContactCopyWithImpl<$Res> implements $ContactCopyWith<$Res> {
  _$ContactCopyWithImpl(this._self, this._then);

  final Contact _self;
  final $Res Function(Contact) _then;

  /// Create a copy of Contact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? firstName = null,
    Object? lastName = null,
    Object? nickname = freezed,
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
    Object? xHandle = freezed,
    Object? linkedInUrl = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      firstName: null == firstName
          ? _self.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _self.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: freezed == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      frequency: null == frequency
          ? _self.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String,
      birthday: freezed == birthday
          ? _self.birthday
          : birthday // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastContacted: freezed == lastContacted
          ? _self.lastContacted
          : lastContacted // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      anniversary: freezed == anniversary
          ? _self.anniversary
          : anniversary // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      phoneNumber: freezed == phoneNumber
          ? _self.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      emails: freezed == emails
          ? _self.emails
          : emails // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      youtubeUrl: freezed == youtubeUrl
          ? _self.youtubeUrl
          : youtubeUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      instagramHandle: freezed == instagramHandle
          ? _self.instagramHandle
          : instagramHandle // ignore: cast_nullable_to_non_nullable
              as String?,
      facebookUrl: freezed == facebookUrl
          ? _self.facebookUrl
          : facebookUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      snapchatHandle: freezed == snapchatHandle
          ? _self.snapchatHandle
          : snapchatHandle // ignore: cast_nullable_to_non_nullable
              as String?,
      xHandle: freezed == xHandle
          ? _self.xHandle
          : xHandle // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedInUrl: freezed == linkedInUrl
          ? _self.linkedInUrl
          : linkedInUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@Entity(realClass: Contact)
class _Contact extends Contact with DiagnosticableTreeMixin {
  _Contact(
      {@Id(assignable: true) this.id,
      required this.firstName,
      required this.lastName,
      this.nickname,
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
      this.xHandle,
      this.linkedInUrl})
      : _emails = emails,
        super._();
  factory _Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);

  @override
  @Id(assignable: true)
  final int? id;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? nickname;
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
  final String? xHandle;
  @override
  final String? linkedInUrl;

  /// Create a copy of Contact
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ContactCopyWith<_Contact> get copyWith =>
      __$ContactCopyWithImpl<_Contact>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ContactToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'Contact'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('firstName', firstName))
      ..add(DiagnosticsProperty('lastName', lastName))
      ..add(DiagnosticsProperty('nickname', nickname))
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
      ..add(DiagnosticsProperty('xHandle', xHandle))
      ..add(DiagnosticsProperty('linkedInUrl', linkedInUrl));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Contact &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
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
            (identical(other.xHandle, xHandle) || other.xHandle == xHandle) &&
            (identical(other.linkedInUrl, linkedInUrl) ||
                other.linkedInUrl == linkedInUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      firstName,
      lastName,
      nickname,
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
      xHandle,
      linkedInUrl);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Contact(id: $id, firstName: $firstName, lastName: $lastName, nickname: $nickname, frequency: $frequency, birthday: $birthday, lastContacted: $lastContacted, anniversary: $anniversary, phoneNumber: $phoneNumber, emails: $emails, notes: $notes, youtubeUrl: $youtubeUrl, instagramHandle: $instagramHandle, facebookUrl: $facebookUrl, snapchatHandle: $snapchatHandle, xHandle: $xHandle, linkedInUrl: $linkedInUrl)';
  }
}

/// @nodoc
abstract mixin class _$ContactCopyWith<$Res> implements $ContactCopyWith<$Res> {
  factory _$ContactCopyWith(_Contact value, $Res Function(_Contact) _then) =
      __$ContactCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@Id(assignable: true) int? id,
      String firstName,
      String lastName,
      String? nickname,
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
      String? xHandle,
      String? linkedInUrl});
}

/// @nodoc
class __$ContactCopyWithImpl<$Res> implements _$ContactCopyWith<$Res> {
  __$ContactCopyWithImpl(this._self, this._then);

  final _Contact _self;
  final $Res Function(_Contact) _then;

  /// Create a copy of Contact
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? firstName = null,
    Object? lastName = null,
    Object? nickname = freezed,
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
    Object? xHandle = freezed,
    Object? linkedInUrl = freezed,
  }) {
    return _then(_Contact(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      firstName: null == firstName
          ? _self.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _self.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: freezed == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      frequency: null == frequency
          ? _self.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String,
      birthday: freezed == birthday
          ? _self.birthday
          : birthday // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastContacted: freezed == lastContacted
          ? _self.lastContacted
          : lastContacted // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      anniversary: freezed == anniversary
          ? _self.anniversary
          : anniversary // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      phoneNumber: freezed == phoneNumber
          ? _self.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      emails: freezed == emails
          ? _self._emails
          : emails // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      youtubeUrl: freezed == youtubeUrl
          ? _self.youtubeUrl
          : youtubeUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      instagramHandle: freezed == instagramHandle
          ? _self.instagramHandle
          : instagramHandle // ignore: cast_nullable_to_non_nullable
              as String?,
      facebookUrl: freezed == facebookUrl
          ? _self.facebookUrl
          : facebookUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      snapchatHandle: freezed == snapchatHandle
          ? _self.snapchatHandle
          : snapchatHandle // ignore: cast_nullable_to_non_nullable
              as String?,
      xHandle: freezed == xHandle
          ? _self.xHandle
          : xHandle // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedInUrl: freezed == linkedInUrl
          ? _self.linkedInUrl
          : linkedInUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
