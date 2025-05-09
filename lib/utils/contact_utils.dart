import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/models/enums.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:recall/utils/logger.dart';
import 'package:recall/models/contact.dart' as app_contact;
import 'package:flutter_contacts/flutter_contacts.dart' as fc;

/// Contact-related utility functions
class ContactUtils {
  /// Clean a phone number by removing all non-digit characters
  static String sanitizePhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
  }

  /// Launch a URL with error handling
  // MARK: LAUNCH URL
  static Future<void> launchUniversalLink(BuildContext context, Uri url) async {
    try {
      final bool canLaunch = await canLaunchUrl(url);

      // Check if widget is still in the tree
      if (!context.mounted) return;

      if (canLaunch) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch $url')),
          );
        }
        logger.w('Could not launch $url');
      }
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching link: $e')),
      );
      logger.e('Error launching link: $e');
    }
  }
  // MARK: URIs
  /// Create a phone call URI
  static Uri createPhoneUri(String phoneNumber) {
    final String cleanPhoneNumber = sanitizePhoneNumber(phoneNumber);
    return Uri.parse('tel:$cleanPhoneNumber');
  }

  /// Create an SMS URI
  static Uri createSmsUri(String phoneNumber) {
    final String cleanPhoneNumber = sanitizePhoneNumber(phoneNumber);
    return Uri.parse('sms:$cleanPhoneNumber');
  }

  /// Create an email URI
  static Uri createEmailUri(String email) {
    return Uri.parse('mailto:$email');
  }

  // MARK: MAPs
  /// Maps a FlutterContacts Contact to the app's Contact model.
  static app_contact.Contact mapContactDeviceToApp(
      fc.Contact fcContact, String defaultFrequency) {
    // Map phone numbers
    final String? phoneNumber = fcContact.phones.isNotEmpty
        ? fcContact.phones.first.number.trim()
        : null;

    // Map emails
    final List<String> emails =
        fcContact.emails.map((email) => email.address.trim()).toList();

    // Map birthday and anniversary
    DateTime? birthday;
    DateTime? anniversary;
    for (final event in fcContact.events) {
      try {
        final date = DateTime(event.year ?? 1900, event.month, event.day);
        if (event.label == fc.EventLabel.birthday) {
          birthday = date;
        } else if (event.label == fc.EventLabel.anniversary) {
          anniversary = date;
        }
      } catch (e) {
        logger.w("Could not parse date for event (${event.label}): $e");
      }
    }

    // Map notes
    final String? notes =
        fcContact.notes.isNotEmpty ? fcContact.notes.first.note : null;

    // Create and return the app's Contact model
    return app_contact.Contact(
      firstName: fcContact.name.first,
      lastName: fcContact.name.last,
      nickname: fcContact.name.nickname,
      phoneNumber: phoneNumber,
      emails: emails,
      birthday: birthday,
      anniversary: anniversary,
      frequency: defaultFrequency,
      notes: notes,
      isActive: true,
    );
  }
}

// MARK: CALCs

// This function remains the core logic for calculating the next contact date.
DateTime calculateNextContactDate(Contact contact) {
  DateTime baseDate = contact.lastContactDate ?? DateTime.now();
  ContactFrequency freq = ContactFrequency.fromString(contact.frequency);

  if (freq == ContactFrequency.never) {
    // For "never", return a date far in the future to sort them last.
    return DateTime(9999, 12, 31);
  }

  // figure out the next contact date from baseDate + frequency
  DateTime nextDate;
  switch (freq) {
    case ContactFrequency.daily:
      nextDate = baseDate.add(const Duration(days: 1));
      break;
    case ContactFrequency.weekly:
      nextDate = baseDate.add(const Duration(days: 7));
      break;
    case ContactFrequency.biweekly:
      nextDate = baseDate.add(const Duration(days: 14));
      break;
    case ContactFrequency.monthly:
      nextDate = DateTime(baseDate.year, baseDate.month + 1, baseDate.day);
      break;
    case ContactFrequency.quarterly:
      nextDate = DateTime(baseDate.year, baseDate.month + 3, baseDate.day);
      break;
    case ContactFrequency.yearly:
      nextDate = DateTime(baseDate.year + 1, baseDate.month, baseDate.day);
      break;
    case ContactFrequency.rarely:
      // Define "rarely" as, for example, 6 months for calculation purposes
      nextDate = DateTime(baseDate.year, baseDate.month + 6, baseDate.day);
      break;
    default: // Should not happen if frequency is validated
      nextDate = DateTime(9999, 12, 31);
  }
  // Return only the date part, time set to midnight
  return DateTime(nextDate.year, nextDate.month, nextDate.day);
}

// formats the next contact date for display
String calculateNextContactDateDisplay(
    DateTime? nextContactDate, String frequencyValue) {
  if (ContactFrequency.fromString(frequencyValue) == ContactFrequency.never ||
      nextContactDate == null) {
    return 'Never';
  }

  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);
  final DateTime tomorrow = today.add(const Duration(days: 1));
  final DateTime nextContactDay = DateTime(
      nextContactDate.year, nextContactDate.month, nextContactDate.day);

  if (nextContactDay.isAtSameMomentAs(today)) {
    return 'Today';
  } else if (nextContactDay.isAtSameMomentAs(tomorrow)) {
    return 'Tomorrow';
  } else if (nextContactDay.isBefore(today)) {
    return 'Overdue'; // Or format the date if preferred for overdue
  } else {
    return DateFormat.yMMMd().format(nextContactDay); // e.g., "Sep 3, 2023"
  }
}

// determines if the next contact date is overdue
bool isOverdue(Contact contact) {
  // If the contact's frequency is "never" or nextContact is null, it's not overdue
  if (ContactFrequency.fromString(contact.frequency) ==
          ContactFrequency.never ||
      contact.nextContactDate == null) {
    return false;
  }

  // Get the current date (without time)
  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);

  // Check if the nextContact date is before today
  return contact.nextContactDate!.isBefore(today);
}

// determines if the next contact date is due soon (today or tomorrow)
bool isDueSoon(Contact contact) {
  // If the nextContact is null, the contact is not due soon
  if (contact.nextContactDate == null) {
    return false;
  }

  // Get today's and tomorrow's dates (without time)
  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);
  final DateTime tomorrow = today.add(const Duration(days: 1));

  // Get the nextContact date (without time)
  final DateTime nextContactDay = DateTime(
    contact.nextContactDate!.year,
    contact.nextContactDate!.month,
    contact.nextContactDate!.day,
  );

  // Check if the nextContact date is today or tomorrow
  return nextContactDay.isAtSameMomentAs(today) ||
      nextContactDay.isAtSameMomentAs(tomorrow);
}

// set the color for the next contact date based on its status
Color? getContactDateColor(
    DateTime? nextContactDate, String frequencyValue, BuildContext context) {
  if (ContactFrequency.fromString(frequencyValue) == ContactFrequency.never ||
      nextContactDate == null) {
    return Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6);
  }

  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);
  final DateTime tomorrow = today.add(const Duration(days: 1));
  final DateTime nextContactDay = DateTime(
      nextContactDate.year, nextContactDate.month, nextContactDate.day);

  if (nextContactDay.isBefore(today)) {
    return Colors.red.shade700; // Overdue
  } else if (nextContactDay.isAtSameMomentAs(today)) {
    return Colors.orange.shade800; // Today
  } else if (nextContactDay.isAtSameMomentAs(tomorrow)) {
    return Colors.blue.shade700; // Tomorrow
  }
  return Theme.of(context)
      .textTheme
      .bodySmall
      ?.color; // Default color for future dates
}

// formats the last contacted date for display
String formatLastContacted(DateTime? lastContactDateDate) {
  if (lastContactDateDate == null) {
    return 'Never';
  }

  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);
  final DateTime yesterday = today.subtract(const Duration(days: 1));
  final DateTime lastContactDay = DateTime(
      lastContactDateDate.year, lastContactDateDate.month, lastContactDateDate.day);

  if (lastContactDay.isAtSameMomentAs(today)) {
    return 'Today';
  } else if (lastContactDay.isAtSameMomentAs(yesterday)) {
    return 'Yesterday';
  } else {
    // Check if it's within the last week to show day name
    if (now.difference(lastContactDay).inDays < 7) {
      return DateFormat('EEEE').format(lastContactDay); // e.g., "Monday"
    }
    return DateFormat.yMMMd().format(lastContactDay); // e.g., "Sep 3, 2023"
  }
}
