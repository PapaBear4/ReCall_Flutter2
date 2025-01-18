// lib/utils/last_contacted_helper.dart
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
