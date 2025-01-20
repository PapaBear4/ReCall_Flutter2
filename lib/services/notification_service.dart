// lib/services/notification_service.dart
import 'package:flutter/foundation.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/services/notification_helper.dart';
import 'package:recall/utils/last_contacted_utils.dart'; // Import the new utils file

class NotificationService extends ChangeNotifier {
  final NotificationHelper _notificationHelper;

  NotificationService(this._notificationHelper);

  Future<void> scheduleNotificationIfNeeded(Contact contact) async {
    if (isOverdue(contact.frequency, contact.lastContacted)) {
      final nextDueDate = calculateNextDueDate(contact);
      await _notificationHelper.scheduleDailyNotification(
        id: contact.id!,
        title: "Contact ${contact.firstName} ${contact.lastName}",
        body:
            "${contact.firstName} ${contact.lastName} is due to be contacted. Frequency: ${contact.frequency}",
        dueDate: nextDueDate,
      );
    }
  }

  Future<void> cancelNotification(int contactId) async {
    await _notificationHelper.cancelNotification(contactId);
  }

  Future<void> scheduleNotificationsForDueContacts(
      List<Contact> contacts) async {
    for (final contact in contacts) {
      await scheduleNotificationIfNeeded(contact);
    }
  }
}