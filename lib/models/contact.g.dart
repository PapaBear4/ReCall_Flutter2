// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContactImpl _$$ContactImplFromJson(Map<String, dynamic> json) =>
    _$ContactImpl(
      id: (json['id'] as num).toInt(),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      birthday: json['birthday'] == null
          ? null
          : DateTime.parse(json['birthday'] as String),
      frequency: $enumDecode(_$ContactFrequencyEnumMap, json['frequency']),
      lastContacted: json['lastContacted'] == null
          ? null
          : DateTime.parse(json['lastContacted'] as String),
    );

Map<String, dynamic> _$$ContactImplToJson(_$ContactImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'birthday': instance.birthday?.toIso8601String(),
      'frequency': _$ContactFrequencyEnumMap[instance.frequency]!,
      'lastContacted': instance.lastContacted?.toIso8601String(),
    };

const _$ContactFrequencyEnumMap = {
  ContactFrequency.daily: 'daily',
  ContactFrequency.weekly: 'weekly',
  ContactFrequency.biWeekly: 'biWeekly',
  ContactFrequency.monthly: 'monthly',
  ContactFrequency.quarterly: 'quarterly',
  ContactFrequency.yearly: 'yearly',
  ContactFrequency.rarely: 'rarely',
  ContactFrequency.never: 'never',
};
