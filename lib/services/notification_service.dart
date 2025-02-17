// lib/services/notification_service.dart
import 'package:flutter/foundation.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/services/notification_helper.dart';
import 'package:recall/utils/last_contacted_utils.dart'; // Import the new utils file

class NotificationService extends ChangeNotifier {
  final NotificationHelper _notificationHelper;

  NotificationService(this._notificationHelper);

  Future<void> scheduleNotificationIfNeeded(Contact contact) async {
    //notificationLogger.i('LOG: scheduler called');
    if (contact.lastContacted == null) {
      await _notificationHelper.scheduleImmediateNotification(
        id: contact.id!,
        title: "Contact ${contact.firstName} ${contact.lastName}",
        body: "SCHEDULED IMMEDIATE You've never contacted ${contact.firstName} ${contact.lastName}",
        //dueDate: nextDueDate,
        contactId: contact.id!, //TODO: fill this in later if needed
      );
      return;
    }
        
    final nextDueDate = calculateNextDueDate(contact);
    //notificationLogger.i('LOG: nextDueDate = $nextDueDate');
    //notificationLogger.i('LOG: Call helper function');
    await _notificationHelper.scheduleNotification(
      id: contact.id!,
      title: "Contact ${contact.firstName} ${contact.lastName}",
      body:
          "${contact.firstName} ${contact.lastName} is due to be contacted. Frequency: ${contact.frequency}",
      dueDate: nextDueDate,
      contactId: contact.id!, //TODO: fill this in later if needed
    );
    
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
