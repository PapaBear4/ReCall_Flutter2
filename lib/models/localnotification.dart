// lib/models/localnotification.dart
import 'package:objectbox/objectbox.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'localnotification.freezed.dart';
part 'localnotification.g.dart';

// This class represents a single notification that will be displayed to the user.
// It contains information such as the title, body, and optional payload data.
@freezed
class LocalNotification with _$LocalNotification {
  const LocalNotification._();

  @Entity(realClass: LocalNotification)
  factory LocalNotification({
    @Id(assignable: true) int? id,
    required String title,
    required String body,
    String? payload,
    @Property(type: PropertyType.date) DateTime? scheduledTime,
  }) = _LocalNotification;


    factory LocalNotification.fromJson(Map<String, dynamic> json) =>
      _$LocalNotificationFromJson(json);


}
