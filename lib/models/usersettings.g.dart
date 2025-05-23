// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usersettings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) => UserSettings(
      id: (json['id'] as num?)?.toInt(),
      remindersEnabled: json['remindersEnabled'] as bool? ?? true,
      alertsEnabled: json['alertsEnabled'] as bool? ?? true,
      notificationHour: (json['notificationHour'] as num?)?.toInt() ?? 7,
      notificationMinute: (json['notificationMinute'] as num?)?.toInt() ?? 0,
      defaultFrequency:
          json['defaultFrequency'] as String? ?? ContactFrequency.defaultValue,
    );

Map<String, dynamic> _$UserSettingsToJson(UserSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'remindersEnabled': instance.remindersEnabled,
      'alertsEnabled': instance.alertsEnabled,
      'notificationHour': instance.notificationHour,
      'notificationMinute': instance.notificationMinute,
      'defaultFrequency': instance.defaultFrequency,
    };
