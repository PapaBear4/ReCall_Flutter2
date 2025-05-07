import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:recall/models/contact.dart'; // Adjust import path as necessary
import 'package:recall/models/contact_frequency.dart';

void main() {
  group('Contact Model Tests', () {
    final DateTime testDate = DateTime(2023, 1, 1);
    final DateTime testDate2 = DateTime(2024, 1, 1);

    test('Contact instantiation with required fields', () {
      final contact = Contact(
        firstName: 'John',
        lastName: 'Doe',
      );
      expect(contact.firstName, 'John');
      expect(contact.lastName, 'Doe');
      expect(contact.frequency, ContactFrequency.defaultValue); // This is 'never' (String)
      expect(contact.isActive, true);
      expect(contact.nickname, isNull);
      expect(contact.birthday, isNull);
      expect(contact.lastContacted, isNull);
      expect(contact.nextContact, isNull);
      expect(contact.anniversary, isNull);
      expect(contact.phoneNumber, isNull);
      expect(contact.emails, isNull);
      expect(contact.notes, isNull);
    });

    test('Contact instantiation with all fields', () {
      final contact = Contact(
        id: 1,
        firstName: 'Jane',
        lastName: 'Doe',
        nickname: 'Janie',
        frequency: ContactFrequency.monthly.value, // Use .value for String
        birthday: testDate,
        lastContacted: testDate,
        nextContact: testDate2,
        anniversary: testDate,
        phoneNumber: '123-456-7890',
        emails: ['jane.doe@example.com'],
        notes: 'Test notes',
        isActive: false,
      );

      expect(contact.id, 1);
      expect(contact.firstName, 'Jane');
      expect(contact.lastName, 'Doe');
      expect(contact.nickname, 'Janie');
      expect(contact.frequency, ContactFrequency.monthly.value); // Check against .value
      expect(contact.birthday, testDate);
      expect(contact.lastContacted, testDate);
      expect(contact.nextContact, testDate2);
      expect(contact.anniversary, testDate);
      expect(contact.phoneNumber, '123-456-7890');
      expect(contact.emails, ['jane.doe@example.com']);
      expect(contact.notes, 'Test notes');
      expect(contact.isActive, false);
    });

    test('Contact copyWith changes specified fields', () {
      final originalContact = Contact(
        firstName: 'Original',
        lastName: 'Name',
        nickname: 'OG',
        frequency: ContactFrequency.yearly.value, // Use .value
        nextContact: testDate,
      );
      final updatedContact = originalContact.copyWith(
        firstName: 'Updated',
        nickname: 'NewNick',
        frequency: ContactFrequency.quarterly.value, // Use .value
        nextContact: testDate2,
      );

      expect(updatedContact.firstName, 'Updated');
      expect(updatedContact.lastName, 'Name'); // Unchanged
      expect(updatedContact.nickname, 'NewNick');
      expect(updatedContact.frequency, ContactFrequency.quarterly.value); // Check against .value
      expect(updatedContact.nextContact, testDate2);
    });

    test('Contact copyWith clears nullable fields', () {
      final originalContact = Contact(
        firstName: 'Original',
        lastName: 'Name',
        nickname: 'OG',
        birthday: testDate,
        lastContacted: testDate,
        nextContact: testDate,
        anniversary: testDate,
        phoneNumber: '111-222-3333',
        emails: ['test@example.com'],
        notes: 'Some notes',
      );

      final updatedContact = originalContact.copyWith(
        clearNickname: true,
        clearBirthday: true,
        clearLastContacted: true,
        // Not clearing nextContact to test it remains
        clearAnniversary: true,
        clearPhoneNumber: true,
        clearEmails: true,
        clearNotes: true,
      );

      expect(updatedContact.nickname, isNull);
      expect(updatedContact.birthday, isNull);
      expect(updatedContact.lastContacted, isNull);
      expect(updatedContact.nextContact, testDate); // Should remain
      expect(updatedContact.anniversary, isNull);
      expect(updatedContact.phoneNumber, isNull);
      expect(updatedContact.emails, isNull);
      expect(updatedContact.notes, isNull);
    });

    test('Contact JSON serialization and deserialization', () {
      final contact = Contact(
        id: 1,
        firstName: 'Json',
        lastName: 'Test',
        nickname: 'JSONy',
        frequency: ContactFrequency.yearly.value, // Use .value for String
        birthday: DateTime.utc(1990, 5, 15),
        lastContacted: DateTime.utc(2023, 1, 10),
        nextContact: DateTime.utc(2024, 1, 10),
        anniversary: DateTime.utc(2020, 6, 20),
        phoneNumber: '987-654-3210',
        emails: ['json@example.com', 'test@example.com'],
        notes: 'JSON serialization test',
        isActive: true,
      );

      final json = contact.toJson();
      final deserializedContact = Contact.fromJson(json);

      expect(deserializedContact.id, contact.id);
      expect(deserializedContact.firstName, contact.firstName);
      expect(deserializedContact.lastName, contact.lastName);
      expect(deserializedContact.nickname, contact.nickname);
      expect(deserializedContact.frequency, contact.frequency); // Already a string
      expect(deserializedContact.birthday, contact.birthday);
      expect(deserializedContact.lastContacted, contact.lastContacted);
      expect(deserializedContact.nextContact, contact.nextContact);
      expect(deserializedContact.anniversary, contact.anniversary);
      expect(deserializedContact.phoneNumber, contact.phoneNumber);
      expect(listEquals(deserializedContact.emails, contact.emails), isTrue);
      expect(deserializedContact.notes, contact.notes);
      expect(deserializedContact.isActive, contact.isActive);
    });

    test('Contact equality', () {
      final contact1 = Contact(
        id: 1,
        firstName: 'Equal',
        lastName: 'Test',
        nickname: 'EQ',
        frequency: ContactFrequency.daily.value, // Use .value for String
        birthday: testDate,
        lastContacted: testDate,
        nextContact: testDate2,
        anniversary: testDate,
        phoneNumber: '555-555-5555',
        emails: ['equal@example.com'],
        notes: 'Equality test',
        isActive: true,
      );

      final contact2 = Contact(
        id: 1,
        firstName: 'Equal',
        lastName: 'Test',
        nickname: 'EQ',
        frequency: ContactFrequency.daily.value, // Use .value for String
        birthday: testDate,
        lastContacted: testDate,
        nextContact: testDate2,
        anniversary: testDate,
        phoneNumber: '555-555-5555',
        emails: ['equal@example.com'],
        notes: 'Equality test',
        isActive: true,
      );

      final contact3 = Contact(
        id: 2, // Different ID
        firstName: 'Equal',
        lastName: 'Test',
        nickname: 'EQ',
        frequency: ContactFrequency.daily.value, // Use .value for String
        birthday: testDate,
        lastContacted: testDate,
        nextContact: testDate2,
        anniversary: testDate,
        phoneNumber: '555-555-5555',
        emails: ['equal@example.com'],
        notes: 'Equality test',
        isActive: true,
      );
      
      final contact4 = Contact(
        id: 1,
        firstName: 'Equal',
        lastName: 'Test',
        nickname: 'EQ',
        frequency: ContactFrequency.weekly.value, // Different frequency
        birthday: testDate,
        lastContacted: testDate,
        nextContact: testDate, // Different nextContact
        anniversary: testDate,
        phoneNumber: '555-555-5555',
        emails: ['equal@example.com'],
        notes: 'Equality test',
        isActive: true,
      );


      expect(contact1 == contact2, isTrue);
      expect(contact1 == contact3, isFalse);
      expect(contact1 == contact4, isFalse);
      expect(contact1.hashCode == contact2.hashCode, isTrue);
      expect(contact1.hashCode == contact3.hashCode, isFalse);
      expect(contact1.hashCode == contact4.hashCode, isFalse);
    });

    test('Contact toString()', () {
      final contact = Contact(
        id: 10,
        firstName: 'ToString',
        lastName: 'Test',
        nickname: 'Str',
        frequency: ContactFrequency.weekly.value, // Use .value for String
        isActive: false,
        nextContact: DateTime(2025,1,1)
      );
      final expectedString = 'Contact(id: 10, firstName: ToString, lastName: Test, nickname: Str, frequency: ${ContactFrequency.weekly.value}, isActive: false, nextContact: ${DateTime(2025,1,1)}, ...)';
      expect(contact.toString(), expectedString);
    });
  });
}
