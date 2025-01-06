// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContactImpl _$$ContactImplFromJson(Map<String, dynamic> json) =>
    _$ContactImpl(
      id: (json['id'] as num?)?.toInt(),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      frequency: json['frequency'] as String? ?? ContactFrequency.defaultValue,
      birthday: json['birthday'] == null
          ? null
          : DateTime.parse(json['birthday'] as String),
      lastContacted: json['lastContacted'] == null
          ? null
          : DateTime.parse(json['lastContacted'] as String),
    );

Map<String, dynamic> _$$ContactImplToJson(_$ContactImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'frequency': instance.frequency,
      'birthday': instance.birthday?.toIso8601String(),
      'lastContacted': instance.lastContacted?.toIso8601String(),
    };
