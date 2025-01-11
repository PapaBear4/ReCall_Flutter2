// lib/models/usersettings.dart
import 'package:objectbox/objectbox.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'usersettings.freezed.dart';
part 'usersettings.g.dart';



// This class represents the user's notification preferences.
// It is stored in the local database using ObjectBox.
// Properties can be added or removed as needed to reflect different notification UserSettings.
@freezed
class UserSettings with _$UserSettings {
  const UserSettings._();

  @Entity(realClass: UserSettings)
  factory UserSettings({
    @Id(assignable: true) int? id,
    @Default(true) bool remindersEnabled,
    @Default(true) bool alertsEnabled,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);

}
