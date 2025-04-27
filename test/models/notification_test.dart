import 'package:flutter_test/flutter_test.dart';
import 'package:recall/models/notification.dart';


void main() {
  group('Notification Model', () {
    final testTime = DateTime(2023, 10, 26, 10, 30, 0);
    final testNotification = Notification(
      id: 1,
      title: 'Test Title',
      body: 'Test Body',
      payload: 'Test Payload',
      scheduledTime: testTime,
    );

    test('Constructor creates object with required fields', () {
      final notification = Notification(title: 'Required Title', body: 'Required Body');
      expect(notification.title, 'Required Title');
      expect(notification.body, 'Required Body');
      expect(notification.id, isNull);
      expect(notification.payload, isNull);
      expect(notification.scheduledTime, isNull);
    });

    test('Constructor creates object with all fields', () {
      expect(testNotification.id, 1);
      expect(testNotification.title, 'Test Title');
      expect(testNotification.body, 'Test Body');
      expect(testNotification.payload, 'Test Payload');
      expect(testNotification.scheduledTime, testTime);
    });

    test('copyWith creates a copy with updated fields', () {
      final newTime = testTime.add(const Duration(hours: 1));
      final updatedNotification = testNotification.copyWith(
        title: 'Updated Title',
        scheduledTime: newTime,
        payload: null, // Test setting a field to null, should not work.
      );

      expect(updatedNotification.id, testNotification.id);
      expect(updatedNotification.title, 'Updated Title'); // Updated
      expect(updatedNotification.body, testNotification.body);
      expect(updatedNotification.payload, testNotification.payload); // Updated to null
      expect(updatedNotification.scheduledTime, newTime); // Updated
    });

    test('Equatable implementation works correctly', () {
      final notification1 = Notification(title: 'Title', body: 'Body');
      final notification2 = Notification(title: 'Title', body: 'Body');
      final notification3 = Notification(title: 'Different', body: 'Body');

      expect(notification1, equals(notification2));
      expect(notification1 == notification2, isTrue);
      expect(notification1.hashCode, equals(notification2.hashCode));

      expect(notification1, isNot(equals(notification3)));
      expect(notification1 == notification3, isFalse);
      expect(notification1.hashCode, isNot(equals(notification3.hashCode)));

      // Test with all fields
      final fullNotificationCopy = testNotification.copyWith();
      expect(testNotification, equals(fullNotificationCopy));
      expect(testNotification == fullNotificationCopy, isTrue);
      expect(testNotification.hashCode, equals(fullNotificationCopy.hashCode));
    });

    test('fromJson and toJson work correctly', () {
      final json = testNotification.toJson();
      final notificationFromJson = Notification.fromJson(json);

      // Convert DateTime to ISO8601 string for reliable comparison
      final testJson = {
        'id': 1,
        'title': 'Test Title',
        'body': 'Test Body',
        'payload': 'Test Payload',
        'scheduledTime': testTime.toIso8601String(),
      };

      expect(json, equals(testJson));
      expect(notificationFromJson, equals(testNotification));
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'title': 'Minimal Title',
        'body': 'Minimal Body',
        // All other fields are missing
      };
      final notificationFromJson = Notification.fromJson(json);

      expect(notificationFromJson.title, 'Minimal Title');
      expect(notificationFromJson.body, 'Minimal Body');
      expect(notificationFromJson.id, isNull);
      expect(notificationFromJson.payload, isNull);
      expect(notificationFromJson.scheduledTime, isNull);
    });
  });
}
