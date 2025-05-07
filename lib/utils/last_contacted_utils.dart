// lib/utils/last_contacted_utils.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/models/enums.dart';

// This function remains the core logic for calculating the next contact date.
DateTime calculateNextDueDate(Contact contact) {
  DateTime baseDate = contact.lastContacted ?? DateTime.now();
  ContactFrequency freq = ContactFrequency.fromString(contact.frequency);

  if (freq == ContactFrequency.never) {
    // For "never", return a date far in the future to sort them last.
    return DateTime(9999, 12, 31);
  }

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

// Refactored to use nextContactDate primarily
String calculateNextDueDateDisplay(DateTime? nextContactDate, String frequencyValue) {
  if (ContactFrequency.fromString(frequencyValue) == ContactFrequency.never || nextContactDate == null) {
    return 'Never';
  }

  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);
  final DateTime tomorrow = today.add(const Duration(days: 1));
  final DateTime nextContactDay = DateTime(nextContactDate.year, nextContactDate.month, nextContactDate.day);

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

// Refactored to use nextContactDate
bool isOverdue(DateTime? nextContactDate, String frequencyValue) {
  if (ContactFrequency.fromString(frequencyValue) == ContactFrequency.never || nextContactDate == null) {
    return false;
  }
  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);
  return nextContactDate.isBefore(today);
}

// Refactored to use nextContactDate
Color? getDueDateColor(DateTime? nextContactDate, String frequencyValue, BuildContext context) {
  if (ContactFrequency.fromString(frequencyValue) == ContactFrequency.never || nextContactDate == null) {
    return Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6);
  }

  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);
  final DateTime tomorrow = today.add(const Duration(days: 1));
  final DateTime nextContactDay = DateTime(nextContactDate.year, nextContactDate.month, nextContactDate.day);

  if (nextContactDay.isBefore(today)) {
    return Colors.red.shade700; // Overdue
  } else if (nextContactDay.isAtSameMomentAs(today)) {
    return Colors.orange.shade800; // Today
  } else if (nextContactDay.isAtSameMomentAs(tomorrow)) {
    return Colors.blue.shade700; // Tomorrow
  }
  return Theme.of(context).textTheme.bodySmall?.color; // Default color for future dates
}

String formatLastContacted(DateTime? lastContactedDate) {
  if (lastContactedDate == null) {
    return 'Never';
  }

  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);
  final DateTime yesterday = today.subtract(const Duration(days: 1));
  final DateTime lastContactDay = DateTime(lastContactedDate.year, lastContactedDate.month, lastContactedDate.day);

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
