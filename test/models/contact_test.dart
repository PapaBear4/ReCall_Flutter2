import 'package:flutter_test/flutter_test.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/models/contact_enums.dart';

void main() {
  group('Contact Model', () {
    final testDate = DateTime(2023, 10, 26);
    final testContact = Contact(
      id: 1,
      firstName: 'John',
      lastName: 'Doe',
      nickname: 'Johnny',
      frequency: ContactFrequency.weekly.value,
      birthday: testDate,
      lastContacted: testDate,
      nextContact: testDate.add(const Duration(days: 7)),
      anniversary: testDate,
      phoneNumber: '123-456-7890',
      emails: ['john.doe@example.com'],
      notes: 'Test notes',
      isActive: true,
    );

    test('Constructor creates object with default values', () {
      final contact = Contact(firstName: 'Jane');
      expect(contact.firstName, 'Jane');
      expect(contact.lastName, '');
      expect(contact.frequency, ContactFrequency.defaultValue);
      expect(contact.isActive, true);
      expect(contact.id, isNull);
      expect(contact.nickname, isNull);
      expect(contact.birthday, isNull);
      expect(contact.lastContacted, isNull);
      expect(contact.nextContact, isNull);
      expect(contact.anniversary, isNull);
      expect(contact.phoneNumber, isNull);
      expect(contact.emails, isNull);
      expect(contact.notes, isNull);
    });

    test('Constructor creates object with all fields', () {
      expect(testContact.id, 1);
      expect(testContact.firstName, 'John');
      expect(testContact.lastName, 'Doe');
      expect(testContact.nickname, 'Johnny');
      expect(testContact.frequency, ContactFrequency.weekly.value);
      expect(testContact.birthday, testDate);
      expect(testContact.lastContacted, testDate);
      expect(testContact.nextContact, testDate.add(const Duration(days: 7)));
      expect(testContact.anniversary, testDate);
      expect(testContact.phoneNumber, '123-456-7890');
      expect(testContact.emails, ['john.doe@example.com']);
      expect(testContact.notes, 'Test notes');
      expect(testContact.isActive, true);
    });

    test('copyWith creates a copy with updated fields', () {
      final updatedContact = testContact.copyWith(
        firstName: 'Jane',
        isActive: false,
        notes: null, // Test setting a field to null, shouldn't work.
      );

      expect(updatedContact.id, testContact.id);
      expect(updatedContact.firstName, 'Jane'); // Updated
      expect(updatedContact.lastName, testContact.lastName);
      expect(updatedContact.nickname, testContact.nickname);
      expect(updatedContact.frequency, testContact.frequency);
      expect(updatedContact.birthday, testContact.birthday);
      expect(updatedContact.lastContacted, testContact.lastContacted);
      expect(updatedContact.nextContact, testContact.nextContact);
      expect(updatedContact.anniversary, testContact.anniversary);
      expect(updatedContact.phoneNumber, testContact.phoneNumber);
      expect(updatedContact.emails, testContact.emails);
      expect(updatedContact.notes, testContact.notes); // Updated to null
      expect(updatedContact.isActive, false); // Updated
    });

    test('copyWith preserves existing null fields when not specified', () {
      // Create a contact where some fields are initially null
      final contactWithNulls = Contact(
        firstName: 'Null',
        lastName: 'Test',
        nickname: null, // Initially null
        notes: null,     // Initially null
      );

      // Call copyWith without specifying nickname or notes
      final copiedContact = contactWithNulls.copyWith(
        lastName: 'Tested', // Update a different field
      );

      expect(copiedContact.firstName, 'Null');
      expect(copiedContact.lastName, 'Tested'); // Updated
      expect(copiedContact.nickname, isNull); // Should remain null
      expect(copiedContact.notes, isNull);     // Should remain null
      // Check other fields remain default or null as expected
      expect(copiedContact.frequency, ContactFrequency.defaultValue);
      expect(copiedContact.isActive, true);
      expect(copiedContact.id, isNull);
      expect(copiedContact.birthday, isNull);
      expect(copiedContact.lastContacted, isNull);
      expect(copiedContact.nextContact, isNull);
      expect(copiedContact.anniversary, isNull);
      expect(copiedContact.phoneNumber, isNull);
      expect(copiedContact.emails, isNull);
    });

    test('Equatable implementation works correctly', () {
      final contact1 = Contact(firstName: 'Test');
      final contact2 = Contact(firstName: 'Test');
      final contact3 = Contact(firstName: 'Different');

      expect(contact1, equals(contact2));
      expect(contact1 == contact2, isTrue);
      expect(contact1.hashCode, equals(contact2.hashCode));

      expect(contact1, isNot(equals(contact3)));
      expect(contact1 == contact3, isFalse);
      expect(contact1.hashCode, isNot(equals(contact3.hashCode)));

      // Test with all fields
      final fullContactCopy = testContact.copyWith();
      expect(testContact, equals(fullContactCopy));
      expect(testContact == fullContactCopy, isTrue);
      expect(testContact.hashCode, equals(fullContactCopy.hashCode));
    });

    test('fromJson and toJson work correctly', () {
      final json = testContact.toJson();
      final contactFromJson = Contact.fromJson(json);

      // Need to compare DateTime objects carefully due to potential precision issues
      // Convert DateTime to ISO8601 string for reliable comparison in JSON context
      final testJson = {
        'id': 1,
        'firstName': 'John',
        'lastName': 'Doe',
        'nickname': 'Johnny',
        'frequency': 'weekly',
        'birthday': testDate.toIso8601String(),
        'lastContacted': testDate.toIso8601String(),
        'nextContact': testDate.add(const Duration(days: 7)).toIso8601String(),
        'anniversary': testDate.toIso8601String(),
        'phoneNumber': '123-456-7890',
        'emails': ['john.doe@example.com'],
        'notes': 'Test notes',
        'isActive': true,
      };

      expect(json, equals(testJson));
      expect(contactFromJson, equals(testContact));
    });

     test('fromJson handles missing optional fields', () {
      final json = {
        'firstName': 'Minimal',
        // All other fields are missing
      };
      final contactFromJson = Contact.fromJson(json);

      expect(contactFromJson.firstName, 'Minimal');
      expect(contactFromJson.lastName, ''); // Default
      expect(contactFromJson.frequency, ContactFrequency.defaultValue); // Default
      expect(contactFromJson.isActive, true); // Default
      expect(contactFromJson.id, isNull);
      expect(contactFromJson.nickname, isNull);
      expect(contactFromJson.birthday, isNull);
      expect(contactFromJson.lastContacted, isNull);
      expect(contactFromJson.nextContact, isNull);
      expect(contactFromJson.anniversary, isNull);
      expect(contactFromJson.phoneNumber, isNull);
      expect(contactFromJson.emails, isNull);
      expect(contactFromJson.notes, isNull);
    });
  });
}
