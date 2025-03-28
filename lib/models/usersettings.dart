// lib/models/usersettings.dart
import 'package:objectbox/objectbox.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'usersettings.freezed.dart';
part 'usersettings.g.dart';

@freezed
// Add 'abstract' here
abstract class UserSettings with _$UserSettings {
  const UserSettings._();

  @Entity(realClass: UserSettings)
  factory UserSettings({
    @Id(assignable: true) int? id,
    @Default(true) bool remindersEnabled,
    @Default(true) bool alertsEnabled,
    @Default(7) int notificationHour,
    @Default(0) int notificationMinute,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);

  TimeOfDay get notificationTimeOfDay => TimeOfDay(hour: notificationHour, minute: notificationMinute);
}