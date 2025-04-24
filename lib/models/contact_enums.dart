// lib/models/contact_enums.dart

/// Defines how frequently a user wants to be reminded to contact someone.
/// 
/// Used for scheduling reminders and calculating when contacts are overdue.
enum ContactFrequency {
  daily('daily'),
  weekly('weekly'),
  biweekly('biweekly'),
  monthly('monthly'),
  quarterly('quarterly'),
  yearly('yearly'),
  rarely('rarely'),
  never('never');

  final String value;
  const ContactFrequency(this.value);

  /// Default frequency for new contacts.
  static const String defaultValue = 'monthly';

  /// Creates a ContactFrequency enum from its string representation.
  static ContactFrequency fromString(String frequencyStr) {
    return ContactFrequency.values.firstWhere(
      (e) => e.value == frequencyStr,
      orElse: () => ContactFrequency.monthly,
    );
  }
}

/// Enum defining the available fields for sorting contacts in the UI.
enum ContactListSortField {
  dueDate,
  lastName,
  lastContacted,
  birthday,
  contactFrequency,
  nextContact,
}

/// Enum defining the available filters to apply to the contact list.
enum ContactListFilter {
  none,     // Show all contacts
  overdue,  // Show only overdue contacts
  dueSoon,  // Show contacts due for communication soon
}
