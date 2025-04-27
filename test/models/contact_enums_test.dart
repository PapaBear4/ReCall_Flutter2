import 'package:flutter_test/flutter_test.dart';
import 'package:recall/models/contact_enums.dart';

void main() {
  group('ContactFrequency', () {
    test('fromString should return correct enum for valid strings', () {
      expect(ContactFrequency.fromString('daily'), ContactFrequency.daily);
      expect(ContactFrequency.fromString('weekly'), ContactFrequency.weekly);
      expect(ContactFrequency.fromString('biweekly'), ContactFrequency.biweekly);
      expect(ContactFrequency.fromString('monthly'), ContactFrequency.monthly);
      expect(ContactFrequency.fromString('quarterly'), ContactFrequency.quarterly);
      expect(ContactFrequency.fromString('yearly'), ContactFrequency.yearly);
      expect(ContactFrequency.fromString('rarely'), ContactFrequency.rarely);
      expect(ContactFrequency.fromString('never'), ContactFrequency.never);
    });

    test('fromString should return default value for invalid string', () {
      expect(ContactFrequency.fromString('invalid_frequency'), ContactFrequency.monthly);
      expect(ContactFrequency.fromString(''), ContactFrequency.monthly);
      // Consider testing null if applicable, though the current signature doesn't allow null.
    });

    test('defaultValue should be monthly', () {
      expect(ContactFrequency.defaultValue, 'monthly');
      expect(ContactFrequency.fromString(ContactFrequency.defaultValue), ContactFrequency.monthly);
    });

    test('enum values should match their string representation', () {
      expect(ContactFrequency.daily.value, 'daily');
      expect(ContactFrequency.weekly.value, 'weekly');
      expect(ContactFrequency.biweekly.value, 'biweekly');
      expect(ContactFrequency.monthly.value, 'monthly');
      expect(ContactFrequency.quarterly.value, 'quarterly');
      expect(ContactFrequency.yearly.value, 'yearly');
      expect(ContactFrequency.rarely.value, 'rarely');
      expect(ContactFrequency.never.value, 'never');
    });
  });

  // Tests for other enums (ContactListSortField, ContactListFilter) could be added here
  // if needed, but they don't have complex logic like fromString.
}
