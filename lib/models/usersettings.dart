// lib/models/usersettings.dart
import 'package:objectbox/objectbox.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:recall/models/contact_enums.dart';

part 'usersettings.g.dart';

/// User preferences and configuration settings for the application.
///
/// This class represents user-configurable settings including notification
/// preferences and default values. It's stored in the ObjectBox database
/// and used throughout the app to provide a consistent user experience.
@JsonSerializable()
@Entity()
class UserSettings extends Equatable {
  /// Unique identifier for the settings record.
  ///
  /// Can be assigned manually which is useful for imports/migrations.
  @Id(assignable: true)
  int? id;
  
  /// Whether contact reminder notifications are enabled.
  ///
  /// When true, the app will generate notifications based on contact frequency.
  final bool remindersEnabled;
  
  /// Whether system alerts are enabled.
  ///
  /// System alerts include notifications about the app's status and important updates.
  final bool alertsEnabled;
  
  /// The hour component (0-23) of when daily notifications should be delivered.
  final int notificationHour;
  
  /// The minute component (0-59) of when daily notifications should be delivered.
  final int notificationMinute;
  
  /// The default contact frequency for new contacts.
  ///
  /// This value comes from the options defined in [ContactFrequency].
  final String defaultFrequency;

  /// Creates a new UserSettings instance with the specified properties.
  ///
  /// All parameters have sensible defaults if not provided:
  /// - reminders and alerts are enabled by default
  /// - default notification time is set to 7:00 AM
  /// - default frequency is taken from [ContactFrequency.defaultValue]
  UserSettings({
    this.id,
    this.remindersEnabled = true,
    this.alertsEnabled = true,
    this.notificationHour = 7,
    this.notificationMinute = 0,
    this.defaultFrequency = ContactFrequency.defaultValue,
  });

  /// Returns the notification time as a Flutter [TimeOfDay] object.
  ///
  /// This is convenient for UI components that work with TimeOfDay.
  TimeOfDay get notificationTimeOfDay => 
      TimeOfDay(hour: notificationHour, minute: notificationMinute);

  /// Creates a new instance of UserSettings with optional updated properties.
  ///
  /// This method allows for immutable updates to UserSettings objects.
  /// Any parameters not provided will retain their original values.
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

  /// Properties used for equality comparison through Equatable.
  ///
  /// Two UserSettings objects with the same property values will be considered equal.
  @override
  List<Object?> get props => [
    id,
    remindersEnabled,
    alertsEnabled,
    notificationHour,
    notificationMinute,
    defaultFrequency,
  ];

  /// Creates a UserSettings instance from a JSON map.
  ///
  /// This factory is used for deserializing settings from JSON data.
  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
  
  /// Converts this UserSettings instance to a JSON map.
  ///
  /// Used for serializing settings for storage or API communications.
  Map<String, dynamic> toJson() => _$UserSettingsToJson(this);
}
