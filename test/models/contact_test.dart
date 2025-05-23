import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:recall/models/contact.dart'; // Adjust import path as necessary
import 'package:recall/models/enums.dart';

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
      expect(contact.lastContactDate, isNull);
      expect(contact.nextContactDate, isNull);
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
        lastContactDate: testDate,
        nextContactDate: testDate2,
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
      expect(contact.lastContactDate, testDate);
      expect(contact.nextContactDate, testDate2);
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
        frequency: ContactFrequency.monthly.value, // Use .value
        nextContactDate: testDate,
      );
      final updatedContact = originalContact.copyWith(
        firstName: 'Updated',
        nickname: 'NewNick',
        frequency: ContactFrequency.monthly.value, // Use .value
        nextContactDate: testDate2,
      );

      expect(updatedContact.firstName, 'Updated');
      expect(updatedContact.lastName, 'Name'); // Unchanged
      expect(updatedContact.nickname, 'NewNick');
      expect(updatedContact.frequency, ContactFrequency.monthly.value); // Check against .value
      expect(updatedContact.nextContactDate, testDate2);
    });

    test('Contact copyWith clears nullable fields', () {
      final originalContact = Contact(
        firstName: 'Original',
        lastName: 'Name',
        nickname: 'OG',
        birthday: testDate,
        lastContactDate: testDate,
        nextContactDate: testDate,
        anniversary: testDate,
        phoneNumber: '111-222-3333',
        emails: ['test@example.com'],
        notes: 'Some notes',
      );

      final updatedContact = originalContact.copyWith(
        clearNickname: true,
        clearBirthday: true,
        clearLastContactDate: true,
        // Not clearing nextContactDate to test it remains
        clearAnniversary: true,
        clearPhoneNumber: true,
        clearEmails: true,
        clearNotes: true,
      );

      expect(updatedContact.nickname, isNull);
      expect(updatedContact.birthday, isNull);
      expect(updatedContact.lastContactDate, isNull);
      expect(updatedContact.nextContactDate, testDate); // Should remain
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
        frequency: ContactFrequency.monthly.value, // Use .value for String
        birthday: DateTime.utc(1990, 5, 15),
        lastContactDate: DateTime.utc(2023, 1, 10),
        nextContactDate: DateTime.utc(2024, 1, 10),
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
      expect(deserializedContact.lastContactDate, contact.lastContactDate);
      expect(deserializedContact.nextContactDate, contact.nextContactDate);
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
        lastContactDate: testDate,
        nextContactDate: testDate2,
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
        lastContactDate: testDate,
        nextContactDate: testDate2,
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
        lastContactDate: testDate,
        nextContactDate: testDate2,
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
        lastContactDate: testDate,
        nextContactDate: testDate, // Different nextContactDate
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
        nextContactDate: DateTime(2025,1,1)
      );
      final expectedString = 'Contact(id: 10, firstName: ToString, lastName: Test, nickname: Str, frequency: ${ContactFrequency.weekly.value}, isActive: false, nextContactDate: ${DateTime(2025,1,1)}, ...)';
      expect(contact.toString(), expectedString);
    });
  });
}
