// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'usersettings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) {
  return _UserSettings.fromJson(json);
}

/// @nodoc
mixin _$UserSettings {
  @Id(assignable: true)
  int? get id => throw _privateConstructorUsedError;
  bool get remindersEnabled => throw _privateConstructorUsedError;
  bool get alertsEnabled => throw _privateConstructorUsedError;
  int get notificationHour => throw _privateConstructorUsedError;
  int get notificationMinute => throw _privateConstructorUsedError;
  String get defaultFrequency => throw _privateConstructorUsedError;

  /// Serializes this UserSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserSettingsCopyWith<UserSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSettingsCopyWith<$Res> {
  factory $UserSettingsCopyWith(
          UserSettings value, $Res Function(UserSettings) then) =
      _$UserSettingsCopyWithImpl<$Res, UserSettings>;
  @useResult
  $Res call(
      {@Id(assignable: true) int? id,
      bool remindersEnabled,
      bool alertsEnabled,
      int notificationHour,
      int notificationMinute,
      String defaultFrequency});
}

/// @nodoc
class _$UserSettingsCopyWithImpl<$Res, $Val extends UserSettings>
    implements $UserSettingsCopyWith<$Res> {
  _$UserSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? remindersEnabled = null,
    Object? alertsEnabled = null,
    Object? notificationHour = null,
    Object? notificationMinute = null,
    Object? defaultFrequency = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      remindersEnabled: null == remindersEnabled
          ? _value.remindersEnabled
          : remindersEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      alertsEnabled: null == alertsEnabled
          ? _value.alertsEnabled
          : alertsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationHour: null == notificationHour
          ? _value.notificationHour
          : notificationHour // ignore: cast_nullable_to_non_nullable
              as int,
      notificationMinute: null == notificationMinute
          ? _value.notificationMinute
          : notificationMinute // ignore: cast_nullable_to_non_nullable
              as int,
      defaultFrequency: null == defaultFrequency
          ? _value.defaultFrequency
          : defaultFrequency // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserSettingsImplCopyWith<$Res>
    implements $UserSettingsCopyWith<$Res> {
  factory _$$UserSettingsImplCopyWith(
          _$UserSettingsImpl value, $Res Function(_$UserSettingsImpl) then) =
      __$$UserSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@Id(assignable: true) int? id,
      bool remindersEnabled,
      bool alertsEnabled,
      int notificationHour,
      int notificationMinute,
      String defaultFrequency});
}

/// @nodoc
class __$$UserSettingsImplCopyWithImpl<$Res>
    extends _$UserSettingsCopyWithImpl<$Res, _$UserSettingsImpl>
    implements _$$UserSettingsImplCopyWith<$Res> {
  __$$UserSettingsImplCopyWithImpl(
      _$UserSettingsImpl _value, $Res Function(_$UserSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? remindersEnabled = null,
    Object? alertsEnabled = null,
    Object? notificationHour = null,
    Object? notificationMinute = null,
    Object? defaultFrequency = null,
  }) {
    return _then(_$UserSettingsImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      remindersEnabled: null == remindersEnabled
          ? _value.remindersEnabled
          : remindersEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      alertsEnabled: null == alertsEnabled
          ? _value.alertsEnabled
          : alertsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationHour: null == notificationHour
          ? _value.notificationHour
          : notificationHour // ignore: cast_nullable_to_non_nullable
              as int,
      notificationMinute: null == notificationMinute
          ? _value.notificationMinute
          : notificationMinute // ignore: cast_nullable_to_non_nullable
              as int,
      defaultFrequency: null == defaultFrequency
          ? _value.defaultFrequency
          : defaultFrequency // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@Entity(realClass: UserSettings)
class _$UserSettingsImpl extends _UserSettings {
  _$UserSettingsImpl(
      {@Id(assignable: true) this.id,
      this.remindersEnabled = true,
      this.alertsEnabled = true,
      this.notificationHour = 7,
      this.notificationMinute = 0,
      this.defaultFrequency = ContactFrequency.defaultValue})
      : super._();

  factory _$UserSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSettingsImplFromJson(json);

  @override
  @Id(assignable: true)
  final int? id;
  @override
  @JsonKey()
  final bool remindersEnabled;
  @override
  @JsonKey()
  final bool alertsEnabled;
  @override
  @JsonKey()
  final int notificationHour;
  @override
  @JsonKey()
  final int notificationMinute;
  @override
  @JsonKey()
  final String defaultFrequency;

  @override
  String toString() {
    return 'UserSettings(id: $id, remindersEnabled: $remindersEnabled, alertsEnabled: $alertsEnabled, notificationHour: $notificationHour, notificationMinute: $notificationMinute, defaultFrequency: $defaultFrequency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSettingsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.remindersEnabled, remindersEnabled) ||
                other.remindersEnabled == remindersEnabled) &&
            (identical(other.alertsEnabled, alertsEnabled) ||
                other.alertsEnabled == alertsEnabled) &&
            (identical(other.notificationHour, notificationHour) ||
                other.notificationHour == notificationHour) &&
            (identical(other.notificationMinute, notificationMinute) ||
                other.notificationMinute == notificationMinute) &&
            (identical(other.defaultFrequency, defaultFrequency) ||
                other.defaultFrequency == defaultFrequency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, remindersEnabled,
      alertsEnabled, notificationHour, notificationMinute, defaultFrequency);

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSettingsImplCopyWith<_$UserSettingsImpl> get copyWith =>
      __$$UserSettingsImplCopyWithImpl<_$UserSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSettingsImplToJson(
      this,
    );
  }
}

abstract class _UserSettings extends UserSettings {
  factory _UserSettings(
      {@Id(assignable: true) final int? id,
      final bool remindersEnabled,
      final bool alertsEnabled,
      final int notificationHour,
      final int notificationMinute,
      final String defaultFrequency}) = _$UserSettingsImpl;
  _UserSettings._() : super._();

  factory _UserSettings.fromJson(Map<String, dynamic> json) =
      _$UserSettingsImpl.fromJson;

  @override
  @Id(assignable: true)
  int? get id;
  @override
  bool get remindersEnabled;
  @override
  bool get alertsEnabled;
  @override
  int get notificationHour;
  @override
  int get notificationMinute;
  @override
  String get defaultFrequency;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSettingsImplCopyWith<_$UserSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
