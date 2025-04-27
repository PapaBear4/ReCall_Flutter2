import 'package:flutter_test/flutter_test.dart';
import 'package:recall/models/usersettings.dart';
import 'package:recall/models/contact_enums.dart'; // Import needed for defaultValue

void main() {
  group('UserSettings Model', () {
    final testSettings = UserSettings(
      id: 1,
      remindersEnabled: false,
      alertsEnabled: false,
      notificationHour: 10,
      notificationMinute: 30,
      defaultFrequency: ContactFrequency.weekly.value,
    );

    test('Constructor creates object with default values', () {
      final settings = UserSettings();
      expect(settings.id, isNull);
      expect(settings.remindersEnabled, true);
      expect(settings.alertsEnabled, true);
      expect(settings.notificationHour, 7);
      expect(settings.notificationMinute, 0);
      expect(settings.defaultFrequency, ContactFrequency.defaultValue);
    });

    test('Constructor creates object with all fields', () {
      expect(testSettings.id, 1);
      expect(testSettings.remindersEnabled, false);
      expect(testSettings.alertsEnabled, false);
      expect(testSettings.notificationHour, 10);
      expect(testSettings.notificationMinute, 30);
      expect(testSettings.defaultFrequency, ContactFrequency.weekly.value);
    });

    test('copyWith creates a copy with updated fields', () {
      final updatedSettings = testSettings.copyWith(
        remindersEnabled: true,
        notificationHour: 8,
      );

      expect(updatedSettings.id, testSettings.id);
      expect(updatedSettings.remindersEnabled, true); // Updated
      expect(updatedSettings.alertsEnabled, testSettings.alertsEnabled);
      expect(updatedSettings.notificationHour, 8); // Updated
      expect(updatedSettings.notificationMinute, testSettings.notificationMinute);
      expect(updatedSettings.defaultFrequency, testSettings.defaultFrequency);
    });

    test('Equatable implementation works correctly', () {
      final settings1 = UserSettings(notificationHour: 9);
      final settings2 = UserSettings(notificationHour: 9);
      final settings3 = UserSettings(notificationHour: 10);

      expect(settings1, equals(settings2));
      expect(settings1 == settings2, isTrue);
      expect(settings1.hashCode, equals(settings2.hashCode));

      expect(settings1, isNot(equals(settings3)));
      expect(settings1 == settings3, isFalse);
      expect(settings1.hashCode, isNot(equals(settings3.hashCode)));

      // Test with all fields
      final fullSettingsCopy = testSettings.copyWith();
      expect(testSettings, equals(fullSettingsCopy));
      expect(testSettings == fullSettingsCopy, isTrue);
      expect(testSettings.hashCode, equals(fullSettingsCopy.hashCode));
    });

    test('fromJson and toJson work correctly', () {
      final json = testSettings.toJson();
      final settingsFromJson = UserSettings.fromJson(json);

      final testJson = {
        'id': 1,
        'remindersEnabled': false,
        'alertsEnabled': false,
        'notificationHour': 10,
        'notificationMinute': 30,
        'defaultFrequency': 'weekly',
      };

      expect(json, equals(testJson));
      expect(settingsFromJson, equals(testSettings));
    });

    test('fromJson applies defaults for missing or null fields', () {
      // Test Case 1: Completely empty JSON map
      final Map<String, dynamic> emptyJson = {};
      final settingsFromEmptyJson = UserSettings.fromJson(emptyJson);

      // Verify defaults defined in usersettings.g.dart _$UserSettingsFromJson
      expect(settingsFromEmptyJson.id, isNull, reason: "ID has no default in fromJson, should be null");
      expect(settingsFromEmptyJson.remindersEnabled, isTrue, reason: "remindersEnabled defaults to true");
      expect(settingsFromEmptyJson.alertsEnabled, isTrue, reason: "alertsEnabled defaults to true");
      expect(settingsFromEmptyJson.notificationHour, 7, reason: "notificationHour defaults to 7");
      expect(settingsFromEmptyJson.notificationMinute, 0, reason: "notificationMinute defaults to 0");
      expect(settingsFromEmptyJson.defaultFrequency, ContactFrequency.defaultValue, reason: "defaultFrequency defaults to ContactFrequency.defaultValue");

      // Test Case 2: JSON map with some fields present, some missing, some explicitly null
      final Map<String, dynamic> partialJson = {
        'id': 10, // Provide an ID
        'remindersEnabled': false, // Provide a non-default value
        'alertsEnabled': null, // Explicitly null
        // notificationHour is missing
        'notificationMinute': null, // Explicitly null
        // defaultFrequency is missing
      };
      final settingsFromPartialJson = UserSettings.fromJson(partialJson);

      expect(settingsFromPartialJson.id, 10, reason: "ID should be taken from JSON");
      expect(settingsFromPartialJson.remindersEnabled, isFalse, reason: "remindersEnabled should be taken from JSON");
      expect(settingsFromPartialJson.alertsEnabled, isTrue, reason: "alertsEnabled should default to true when JSON value is null");
      expect(settingsFromPartialJson.notificationHour, 7, reason: "notificationHour should default to 7 when missing");
      expect(settingsFromPartialJson.notificationMinute, 0, reason: "notificationMinute should default to 0 when JSON value is null");
      expect(settingsFromPartialJson.defaultFrequency, ContactFrequency.defaultValue, reason: "defaultFrequency should default when missing");
    });
  });
}
