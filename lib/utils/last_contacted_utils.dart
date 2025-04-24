// lib/utils/last_contacted_utils.dart
import 'package:recall/models/contact.dart';
import 'package:recall/models/contact_enums.dart';

/// Formats the last contacted date into a human-readable string.
///
/// Returns relative time expressions like "Today", "2 days ago", 
/// "3 weeks ago", or "4 months ago" based on the difference between
/// the provided date and now.
/// 
/// Returns an empty string if [lastContacted] is null.
String formatLastContacted(DateTime? lastContacted) {
  if (lastContacted == null) {
    return '';
  }

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final lastContactedDate =
      DateTime(lastContacted.year, lastContacted.month, lastContacted.day);

  if (lastContactedDate == today) {
    return 'Today';
  }

  final difference = now.difference(lastContacted);

  if (difference.inDays <= 13) {
    final days = difference.inDays;
    return '$days day${days == 1 ? '' : 's'} ago';
  } else if (difference.inDays <= 56) {
    final weeks = difference.inDays ~/ 7;
    return '$weeks week${weeks == 1 ? '' : 's'} ago';
  } else {
    final months = difference.inDays ~/ 30;
    return '$months month${months == 1 ? '' : 's'} ago';
  }
}

/// Determines if a contact is overdue for communication based on frequency.
///
/// Checks if the time elapsed since [lastContacted] exceeds the expected
/// interval defined by [frequency]. Returns false if frequency is "never"
/// or if the contact has never been contacted before.
///
/// @param frequency The contact frequency string from ContactFrequency
/// @param lastContacted The last time the contact was communicated with
/// @return true if contact is overdue, false otherwise
bool isOverdue(String frequency, DateTime? lastContacted) {
  if (frequency == ContactFrequency.never.value || lastContacted == null) {
    return false;
  }

  final now = DateTime.now();
  final duration = now.difference(lastContacted);

  switch (frequency) {
    case 'daily':
      return duration.inDays >= 1;
    case 'weekly':
      return duration.inDays >= 7;
    case 'biweekly':
      return duration.inDays >= 14;
    case 'monthly':
      return duration.inDays >= 30;
    case 'quarterly':
      return duration.inDays >= 90;
    case 'yearly':
      return duration.inDays >= 365;
    case 'rarely':
      return duration.inDays >= 750;

    default:
      return false;
  }
}

/// Calculates the next contact date based on contact frequency.
///
/// Takes a contact's last contacted date and frequency setting to determine
/// when they should next be contacted. The returned date is normalized to 7 AM
/// on the calculated day.
///
/// For "never" frequency, returns a date far in the future.
/// For null lastContacted, returns the current date.
///
/// @param contact The contact with lastContacted and frequency information
/// @return DateTime representing when the contact should next be contacted
DateTime calculateNextContact(Contact contact) {
  if (contact.lastContacted == null) {
    return DateTime.now(); // Or some other default behavior
  }

  final frequency = ContactFrequency.fromString(contact.frequency);
  final lastContacted = DateTime(
    contact.lastContacted!.year,
    contact.lastContacted!.month,
    contact.lastContacted!.day,
    7, // Set to 7 AM;
    0, // Set to 0 minutes;
    0, // Set to 0 seconds; 
  );

  switch (frequency) {
    case ContactFrequency.daily:
      return lastContacted.add(const Duration(days: 1));
    case ContactFrequency.weekly:
      return lastContacted.add(const Duration(days: 7));
    case ContactFrequency.biweekly:
      return lastContacted.add(const Duration(days: 14));
    case ContactFrequency.monthly:
      return lastContacted.add(const Duration(days: 30));
    case ContactFrequency.quarterly:
      return lastContacted.add(const Duration(days: 90));
    case ContactFrequency.yearly:
      return lastContacted.add(const Duration(days: 365));
    case ContactFrequency.rarely:
      return lastContacted.add(const Duration(days: 750));
    case ContactFrequency.never:
      return DateTime.now()
          .add(const Duration(days: 365 * 10)); // A long time in the future
  }
}

/// Formats the next due contact date into a human-readable string.
///
/// Returns expressions like "Overdue", "Today", "Tomorrow", or "In X days"
/// based on when the next contact is due relative to today.
///
/// If [lastContacted] is null, returns "Never Contacted".
///
/// @param lastContacted When the contact was last communicated with
/// @param frequency The communication frequency string
/// @return A human-readable string representing when contact is due
String calculateNextDueDateDisplay(DateTime? lastContacted, String frequency) {
  if (lastContacted == null) return 'Never Contacted';
  final nextDueDate = calculateNextContact(Contact(
      firstName: '',
      frequency: frequency,
      id: 0,
      lastName: '',
      lastContacted: lastContacted));
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));
  final nextDueDateDate =
      DateTime(nextDueDate.year, nextDueDate.month, nextDueDate.day);

  if (nextDueDateDate.isBefore(today)) {
    return 'Overdue';
  } else if (nextDueDateDate == today) {
    return 'Today';
  } else if (nextDueDateDate == tomorrow) {
    return 'Tomorrow';
  } else {
    final difference = nextDueDate.difference(today).inDays;
    return 'In $difference day${difference == 1 ? '' : 's'}';
  }
}
