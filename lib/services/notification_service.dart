// lib/services/notification_service.dart
import 'package:flutter/foundation.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/models/contact_frequency.dart';
import 'package:recall/models/usersettings.dart';
import 'package:recall/repositories/usersettings_repository.dart';
import 'package:recall/services/notification_helper.dart';
import 'package:recall/utils/last_contacted_utils.dart'; // Import the new utils file
import 'package:recall/utils/logger.dart'; // Adjust path if needed

class NotificationService extends ChangeNotifier {
  final NotificationHelper _notificationHelper;
  final UserSettingsRepository _userSettingsRepository;

  NotificationService(this._notificationHelper, this._userSettingsRepository);

  //schedule a notification based on contact.frequency and contact.lastContacted
  Future<void> scheduleReminder(Contact contact) async {
    if (contact.id == null) {
      logger.e('LOG: Cannot schedule notification for contact with null ID.');
      return;
    }
    if (contact.frequency == ContactFrequency.never.value) {
         logger.i('LOG: Not scheduling notification for contact ${contact.id} with frequency "never". Cancelling any existing.');
         await _notificationHelper.cancelNotification(contact.id!); // Cancel if frequency is set to never
         return;
    }

    // Assuming settings are stored with ID 1, as in settings_screen.dart
    // Provide default time (e.g., 7:00 AM) if settings not found
    UserSettings? settings = await _userSettingsRepository.getById(1);
    final int notificationHour = settings?.notificationHour ?? 7; // Default hour 7
    final int notificationMinute = settings?.notificationMinute ?? 0; // Default minute 0
    
    DateTime nextDueDate;
    String baseTitle;
    String baseBody;

    if (contact.lastContacted == null) {
      // Never contacted: Due immediately (schedule for ~now, helper will push to tomorrow if needed)
      nextDueDate = DateTime.now();
      baseTitle = "Contact ${contact.firstName} ${contact.lastName}";
      baseBody = "You haven't contacted ${contact.firstName} yet.";
       logger.i('LOG: Contact ${contact.id} never contacted. Due date calculated as now.');
    } else {
      // Previously contacted: Calculate next due date
      nextDueDate = calculateNextDueDate(contact); // Calculate the ideal date
      baseTitle = "Contact ${contact.firstName} ${contact.lastName}";
      baseBody = "${contact.firstName} is due for contact."; // Simpler body
       logger.i('LOG: Contact ${contact.id} previously contacted. Next due date calculated as $nextDueDate.');
    }

    // Call the helper, passing the calculated date and the contact
    await _notificationHelper.scheduleNotification(
      id: contact.id!,
      title: baseTitle,
      body: baseBody,
      calculatedDueDate: nextDueDate, // Pass the ideal date
      contact: contact, // Pass the contact object
      notificationHour: notificationHour, // Pass the loaded hour
      notificationMinute: notificationMinute, // Pass the loaded minute
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
