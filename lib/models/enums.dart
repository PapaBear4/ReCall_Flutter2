// lib/models/contact_frequency.dart
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

  // Helper method to get the enum from a string value
  static ContactFrequency fromString(String value) {
    return ContactFrequency.values.firstWhere(
      (element) => element.value == value,
      orElse: () =>
          ContactFrequency.daily, // Or throw an exception if not found
    );
  }

  // Default value to be used when creating new instances
  static const String defaultValue = 'never';
}
