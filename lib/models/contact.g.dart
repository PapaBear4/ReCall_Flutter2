// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contact _$ContactFromJson(Map<String, dynamic> json) => Contact(
      id: (json['id'] as num?)?.toInt(),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      nickname: json['nickname'] as String?,
      frequency: json['frequency'] as String? ?? ContactFrequency.defaultValue,
      birthday: json['birthday'] == null
          ? null
          : DateTime.parse(json['birthday'] as String),
      lastContacted: json['lastContacted'] == null
          ? null
          : DateTime.parse(json['lastContacted'] as String),
      nextContact: json['nextContact'] == null
          ? null
          : DateTime.parse(json['nextContact'] as String),
      anniversary: json['anniversary'] == null
          ? null
          : DateTime.parse(json['anniversary'] as String),
      phoneNumber: json['phoneNumber'] as String?,
      emails:
          (json['emails'] as List<dynamic>?)?.map((e) => e as String).toList(),
      notes: json['notes'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$ContactToJson(Contact instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'nickname': instance.nickname,
      'frequency': instance.frequency,
      'birthday': instance.birthday?.toIso8601String(),
      'lastContacted': instance.lastContacted?.toIso8601String(),
      'nextContact': instance.nextContact?.toIso8601String(),
      'anniversary': instance.anniversary?.toIso8601String(),
      'phoneNumber': instance.phoneNumber,
      'emails': instance.emails,
      'notes': instance.notes,
      'isActive': instance.isActive,
    };
