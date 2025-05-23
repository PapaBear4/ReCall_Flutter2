// lib/models/contact_frequency.dart
enum ContactFrequency {
  daily('daily'),
  weekly('weekly'),
  biweekly('biweekly'),
  monthly('monthly'),
  // quarterly('quarterly'),
  // yearly('yearly'),
  // rarely('rarely'),
  never('never');

  final String value;

  const ContactFrequency(this.value);

  // Helper method to get the enum from a string value
  static ContactFrequency fromString(String value) {
    return ContactFrequency.values.firstWhere(
      (element) => element.value == value,
      orElse: () {
        // If the value is one of the "disabled" ones, default to monthly.
        // Otherwise, default to daily (or consider throwing an error).
        if (value == 'quarterly' || value == 'yearly' || value == 'rarely') {
          return ContactFrequency.monthly;
        }
        return ContactFrequency.daily; // Default for truly unknown values
      },
    );
  }

  // Default value to be used when creating new instances
  static const String defaultValue = 'weekly';
}
