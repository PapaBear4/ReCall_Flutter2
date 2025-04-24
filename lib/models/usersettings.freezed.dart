// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'usersettings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserSettings {
  @Id(assignable: true)
  int? get id;
  bool get remindersEnabled;
  bool get alertsEnabled;
  int get notificationHour;
  int get notificationMinute;
  String get defaultFrequency;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserSettingsCopyWith<UserSettings> get copyWith =>
      _$UserSettingsCopyWithImpl<UserSettings>(
          this as UserSettings, _$identity);

  /// Serializes this UserSettings to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserSettings &&
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

  @override
  String toString() {
    return 'UserSettings(id: $id, remindersEnabled: $remindersEnabled, alertsEnabled: $alertsEnabled, notificationHour: $notificationHour, notificationMinute: $notificationMinute, defaultFrequency: $defaultFrequency)';
  }
}

/// @nodoc
abstract mixin class $UserSettingsCopyWith<$Res> {
  factory $UserSettingsCopyWith(
          UserSettings value, $Res Function(UserSettings) _then) =
      _$UserSettingsCopyWithImpl;
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
class _$UserSettingsCopyWithImpl<$Res> implements $UserSettingsCopyWith<$Res> {
  _$UserSettingsCopyWithImpl(this._self, this._then);

  final UserSettings _self;
  final $Res Function(UserSettings) _then;

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
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      remindersEnabled: null == remindersEnabled
          ? _self.remindersEnabled
          : remindersEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      alertsEnabled: null == alertsEnabled
          ? _self.alertsEnabled
          : alertsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationHour: null == notificationHour
          ? _self.notificationHour
          : notificationHour // ignore: cast_nullable_to_non_nullable
              as int,
      notificationMinute: null == notificationMinute
          ? _self.notificationMinute
          : notificationMinute // ignore: cast_nullable_to_non_nullable
              as int,
      defaultFrequency: null == defaultFrequency
          ? _self.defaultFrequency
          : defaultFrequency // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@Entity(realClass: UserSettings)
class _UserSettings extends UserSettings {
  _UserSettings(
      {@Id(assignable: true) this.id,
      this.remindersEnabled = true,
      this.alertsEnabled = true,
      this.notificationHour = 7,
      this.notificationMinute = 0,
      this.defaultFrequency = ContactFrequency.defaultValue})
      : super._();
  factory _UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);

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

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserSettingsCopyWith<_UserSettings> get copyWith =>
      __$UserSettingsCopyWithImpl<_UserSettings>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserSettingsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserSettings &&
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

  @override
  String toString() {
    return 'UserSettings(id: $id, remindersEnabled: $remindersEnabled, alertsEnabled: $alertsEnabled, notificationHour: $notificationHour, notificationMinute: $notificationMinute, defaultFrequency: $defaultFrequency)';
  }
}

/// @nodoc
abstract mixin class _$UserSettingsCopyWith<$Res>
    implements $UserSettingsCopyWith<$Res> {
  factory _$UserSettingsCopyWith(
          _UserSettings value, $Res Function(_UserSettings) _then) =
      __$UserSettingsCopyWithImpl;
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
class __$UserSettingsCopyWithImpl<$Res>
    implements _$UserSettingsCopyWith<$Res> {
  __$UserSettingsCopyWithImpl(this._self, this._then);

  final _UserSettings _self;
  final $Res Function(_UserSettings) _then;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? remindersEnabled = null,
    Object? alertsEnabled = null,
    Object? notificationHour = null,
    Object? notificationMinute = null,
    Object? defaultFrequency = null,
  }) {
    return _then(_UserSettings(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      remindersEnabled: null == remindersEnabled
          ? _self.remindersEnabled
          : remindersEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      alertsEnabled: null == alertsEnabled
          ? _self.alertsEnabled
          : alertsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationHour: null == notificationHour
          ? _self.notificationHour
          : notificationHour // ignore: cast_nullable_to_non_nullable
              as int,
      notificationMinute: null == notificationMinute
          ? _self.notificationMinute
          : notificationMinute // ignore: cast_nullable_to_non_nullable
              as int,
      defaultFrequency: null == defaultFrequency
          ? _self.defaultFrequency
          : defaultFrequency // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
