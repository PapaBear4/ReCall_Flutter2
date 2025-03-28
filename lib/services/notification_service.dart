// lib/services/notification_service.dart
import 'package:flutter/foundation.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/models/contact_frequency.dart';
import 'package:recall/services/notification_helper.dart';
import 'package:recall/utils/last_contacted_utils.dart'; // Import the new utils file

class NotificationService extends ChangeNotifier {
  final NotificationHelper _notificationHelper;

  NotificationService(this._notificationHelper);

  //schedule a notification based on contact.frequency and contact.lastContacted
  Future<void> scheduleReminder(Contact contact) async {
    if (contact.id == null) {
      notificationLogger.e('LOG: Cannot schedule notification for contact with null ID.');
      return;
    }
    if (contact.frequency == ContactFrequency.never.value) {
         notificationLogger.i('LOG: Not scheduling notification for contact ${contact.id} with frequency "never". Cancelling any existing.');
         await _notificationHelper.cancelNotification(contact.id!); // Cancel if frequency is set to never
         return;
    }


    DateTime nextDueDate;
    String baseTitle;
    String baseBody;

    if (contact.lastContacted == null) {
      // Never contacted: Due immediately (schedule for ~now, helper will push to tomorrow if needed)
      nextDueDate = DateTime.now();
      baseTitle = "Contact ${contact.firstName} ${contact.lastName}";
      baseBody = "You haven't contacted ${contact.firstName} yet.";
       notificationLogger.i('LOG: Contact ${contact.id} never contacted. Due date calculated as now.');
    } else {
      // Previously contacted: Calculate next due date
      nextDueDate = calculateNextDueDate(contact); // Calculate the ideal date
      baseTitle = "Contact ${contact.firstName} ${contact.lastName}";
      baseBody = "${contact.firstName} is due for contact."; // Simpler body
       notificationLogger.i('LOG: Contact ${contact.id} previously contacted. Next due date calculated as $nextDueDate.');
    }

    // Call the helper, passing the calculated date and the contact
    await _notificationHelper.scheduleNotification(
      id: contact.id!,
      title: baseTitle,
      body: baseBody,
      calculatedDueDate: nextDueDate, // Pass the ideal date
      contact: contact, // Pass the contact object
    );
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
