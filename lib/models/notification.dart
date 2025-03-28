// lib/models/notification.dart
import 'package:objectbox/objectbox.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

// This class represents a single notification that will be displayed to the user.
// It contains information such as the title, body, and optional payload data.
@freezed
abstract class Notification with _$Notification {
  const Notification._();

  @Entity(realClass: Notification)
  factory Notification({
    @Id(assignable: true) int? id,
    required String title,
    required String body,
    String? payload,
    @Property(type: PropertyType.date) DateTime? scheduledTime,
  }) = _Notification;


    factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);


}
