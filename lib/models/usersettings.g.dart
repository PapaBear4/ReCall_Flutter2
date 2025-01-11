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
    );

Map<String, dynamic> _$$UserSettingsImplToJson(_$UserSettingsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'remindersEnabled': instance.remindersEnabled,
      'alertsEnabled': instance.alertsEnabled,
    };
