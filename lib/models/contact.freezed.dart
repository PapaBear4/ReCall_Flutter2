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
      @Property(type: PropertyType.date) DateTime? lastContacted});
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
      @Property(type: PropertyType.date) DateTime? lastContacted});
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
      @Property(type: PropertyType.date) this.lastContacted})
      : super._();

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
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Contact(id: $id, firstName: $firstName, lastName: $lastName, frequency: $frequency, birthday: $birthday, lastContacted: $lastContacted)';
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
      ..add(DiagnosticsProperty('lastContacted', lastContacted));
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
                other.lastContacted == lastContacted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, firstName, lastName, frequency, birthday, lastContacted);

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
          @Property(type: PropertyType.date) final DateTime? lastContacted}) =
      _$ContactImpl;
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

  /// Create a copy of Contact
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactImplCopyWith<_$ContactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
