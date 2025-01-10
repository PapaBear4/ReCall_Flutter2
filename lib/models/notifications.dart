import 'package:objectbox/objectbox.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'notifications.freezed.dart';
part 'notifications.g.dart';

// This class represents the user's notification preferences.
// It is stored in the local database using ObjectBox.
// Properties can be added or removed as needed to reflect different notification settings.
@freezed
class NotificationSettings with _$NotificationSettings {
  const NotificationSettings._();

  @Entity(realClass: NotificationSettings)
  factory NotificationSettings({
    @Id(assignable: true) int? id,
    @Default(true) bool remindersEnabled,
    @Default(true) bool alertsEnabled,
  }) = _NotificationSettings;

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);

}

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
  }) = _LocalNotification;


    factory LocalNotification.fromJson(Map<String, dynamic> json) =>
      _$LocalNotificationFromJson(json);


}
