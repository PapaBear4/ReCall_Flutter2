// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usersettings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserSettingsImpl _$$UserSettingsImplFromJson(Map<String, dynamic> json) =>
    _$UserSettingsImpl(
      id: (json['id'] as num?)?.toInt(),
      remindersEnabled: json['remindersEnabled'] as bool? ?? true,
      alertsEnabled: json['alertsEnabled'] as bool? ?? true,
      notificationHour: (json['notificationHour'] as num?)?.toInt() ?? 7,
      notificationMinute: (json['notificationMinute'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserSettingsImplToJson(_$UserSettingsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'remindersEnabled': instance.remindersEnabled,
      'alertsEnabled': instance.alertsEnabled,
      'notificationHour': instance.notificationHour,
      'notificationMinute': instance.notificationMinute,
    };
