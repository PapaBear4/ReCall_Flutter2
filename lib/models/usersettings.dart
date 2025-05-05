// lib/models/usersettings.dart
import 'package:objectbox/objectbox.dart';
import 'package:flutter/material.dart';
import 'package:recall/models/contact_frequency.dart';

@Entity(realClass: UserSettings)
class UserSettings {
  @Id(assignable: true)
  int? id;
  bool remindersEnabled;
  bool alertsEnabled;
  int notificationHour;
  int notificationMinute;
  String defaultFrequency;

  UserSettings({
    this.id,
    this.remindersEnabled = true,
    this.alertsEnabled = true,
    this.notificationHour = 7,
    this.notificationMinute = 0,
    this.defaultFrequency = ContactFrequency.defaultValue,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      id: json['id'] as int?,
      remindersEnabled: json['remindersEnabled'] as bool,
      alertsEnabled: json['alertsEnabled'] as bool,
      notificationHour: json['notificationHour'] as int,
      notificationMinute: json['notificationMinute'] as int,
      defaultFrequency: json['defaultFrequency'] as String,
    );
  }

  UserSettings copyWith({
    int? id,
    bool? remindersEnabled,
    bool? alertsEnabled,
    int? notificationHour,
    int? notificationMinute,
    String? defaultFrequency,
  }) {
    return UserSettings(
      id: id ?? this.id,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      alertsEnabled: alertsEnabled ?? this.alertsEnabled,
      notificationHour: notificationHour ?? this.notificationHour,
      notificationMinute: notificationMinute ?? this.notificationMinute,
      defaultFrequency: defaultFrequency ?? this.defaultFrequency,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettings &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          remindersEnabled == other.remindersEnabled &&
          alertsEnabled == other.alertsEnabled &&
          notificationHour == other.notificationHour &&
          notificationMinute == other.notificationMinute &&
          defaultFrequency == other.defaultFrequency;

  @override
  int get hashCode =>
      id.hashCode ^
      remindersEnabled.hashCode ^
      alertsEnabled.hashCode ^
      notificationHour.hashCode ^
      notificationMinute.hashCode ^
      defaultFrequency.hashCode;

  @override
  String toString() {
    return 'UserSettings{id: $id, remindersEnabled: $remindersEnabled, alertsEnabled: $alertsEnabled, notificationHour: $notificationHour, notificationMinute: $notificationMinute, defaultFrequency: $defaultFrequency}';
  }

  TimeOfDay get notificationTimeOfDay =>
      TimeOfDay(hour: notificationHour, minute: notificationMinute);
      
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'remindersEnabled': remindersEnabled,
      'alertsEnabled': alertsEnabled,
      'notificationHour': notificationHour,
      'notificationMinute': notificationMinute,
      'defaultFrequency': defaultFrequency,
    };
  }
}
