// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localnotification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LocalNotificationImpl _$$LocalNotificationImplFromJson(
        Map<String, dynamic> json) =>
    _$LocalNotificationImpl(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      body: json['body'] as String,
      payload: json['payload'] as String?,
      scheduledTime: json['scheduledTime'] == null
          ? null
          : DateTime.parse(json['scheduledTime'] as String),
    );

Map<String, dynamic> _$$LocalNotificationImplToJson(
        _$LocalNotificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'payload': instance.payload,
      'scheduledTime': instance.scheduledTime?.toIso8601String(),
    };
