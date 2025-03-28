// lib/services/notification_service.dart
import 'package:flutter/foundation.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/services/notification_helper.dart';
import 'package:recall/utils/last_contacted_utils.dart'; // Import the new utils file

class NotificationService extends ChangeNotifier {
  final NotificationHelper _notificationHelper;

  NotificationService(this._notificationHelper);

  //schedule a notification based on contact.frequency and contact.lastContacted
  Future<void> scheduleReminder(Contact contact) async {
    //notificationLogger.i('LOG: scheduler called');
    //if the contact has never been contacted, immediately fire a notification
    if (contact.lastContacted == null) {
      await _notificationHelper.scheduleNotification(
        id: contact.id!,
        title: "Immediately Contact ${contact.firstName} ${contact.lastName}",
        body: "You've never contacted ${contact.firstName} ${contact.lastName}",
        dueDate: DateTime.now(),
        contactId: contact.id!, //pass contact.id to notification helper
      );
      return;
    } else {
      final nextDueDate = calculateNextDueDate(contact);
      notificationLogger.i('LOG: nextDueDate = $nextDueDate');
      //notificationLogger.i('LOG: Call helper function');
      await _notificationHelper.scheduleNotification(
        id: contact.id!,
        title: "Scheduled Contact ${contact.firstName} ${contact.lastName}",
        body:
            "${contact.firstName} ${contact.lastName} is due to be contacted on $nextDueDate.",
        dueDate: nextDueDate,
        contactId: contact.id!, //pass contact.id to notification helper
      );
    }
  }

  Future<void> cancelNotification(int contactId) async {
    await _notificationHelper.cancelNotification(contactId);
  }

  Future<void> scheduleNotificationsForDueContacts(
      List<Contact> contacts) async {
    for (final contact in contacts) {
      await scheduleReminder(contact);
    }
  }
}
