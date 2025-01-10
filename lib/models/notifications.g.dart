// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationSettingsImpl _$$NotificationSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationSettingsImpl(
      id: (json['id'] as num?)?.toInt(),
      remindersEnabled: json['remindersEnabled'] as bool? ?? true,
      alertsEnabled: json['alertsEnabled'] as bool? ?? true,
    );

Map<String, dynamic> _$$NotificationSettingsImplToJson(
        _$NotificationSettingsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'remindersEnabled': instance.remindersEnabled,
      'alertsEnabled': instance.alertsEnabled,
    };

_$LocalNotificationImpl _$$LocalNotificationImplFromJson(
        Map<String, dynamic> json) =>
    _$LocalNotificationImpl(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      body: json['body'] as String,
      payload: json['payload'] as String?,
    );

Map<String, dynamic> _$$LocalNotificationImplToJson(
        _$LocalNotificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'payload': instance.payload,
    };
