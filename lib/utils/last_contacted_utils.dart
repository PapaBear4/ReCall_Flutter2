import 'package:recall/models/contact.dart';
import 'package:recall/models/contact_frequency.dart';

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

DateTime calculateNextDueDate(Contact contact) {
  if (contact.lastContacted == null) {
    return DateTime.now(); // Or some other default behavior
  }

  final frequency = ContactFrequency.fromString(contact.frequency);
  final lastContacted = contact.lastContacted!;

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

String calculateNextDueDateDisplay(DateTime? lastContacted, String frequency) {
    if (lastContacted == null) return 'Never Contacted';
    final nextDueDate = calculateNextDueDate(Contact(firstName: '', frequency: frequency, id: 0, lastName: '', lastContacted: lastContacted));
  final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));
  final nextDueDateDate = DateTime(nextDueDate.year, nextDueDate.month, nextDueDate.day);

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
