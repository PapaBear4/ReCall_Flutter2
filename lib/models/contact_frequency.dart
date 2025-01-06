// contact_frequency.dart

import 'package:recall/models/contact.dart';

enum ContactFrequency {
  daily,
  weekly,
  biWeekly,
  monthly,
  quarterly,
  yearly,
  rarely,
  never,
}

// Helper function to get the string representation
String getContactFrequencyString(int frequencyValue) {
  switch (frequencyValue) {
    case 1:
      return 'Daily';
    case 2:
      return 'Weekly';
    case 3:
      return 'Bi-Weekly';
    case 4:
      return 'Monthly';
    case 5:
      return 'Quarterly';
    case 6:
      return 'Yearly';
    case 7:
      return 'Rarely';
    case 8:
      return 'Never';
    default:
      return 'Unknown'; // Handle unexpected values
  }
}

int getContactFrequencyIndex(ContactFrequency frequency) {
  switch (frequency) {
    case ContactFrequency.daily:
      return 1;
    case ContactFrequency.weekly:
      return 2;
          case ContactFrequency.biWeekly:
      return 3;
    case ContactFrequency.monthly:
      return 4;
    case ContactFrequency.quarterly:
      return 5;
    case ContactFrequency.yearly:
      return 6;
    case ContactFrequency.rarely:
      return 7;
    case ContactFrequency.never:
      return 8;
    default:
      return 8;
  }
}
