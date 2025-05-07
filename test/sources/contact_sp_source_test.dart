import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/models/contact_frequency.dart';
import 'package:recall/sources/contact_sp_source.dart';

void main() {
  group('ContactsSharedPreferencesSource Tests', () {
    late ContactsSharedPreferencesSource dataSource;
    const String spKey = 'contacts';

    final contact1 = Contact(id: 1, firstName: 'John', lastName: 'Doe', frequency: ContactFrequency.daily.value);
    final contact2 = Contact(id: 2, firstName: 'Jane', lastName: 'Doe', frequency: ContactFrequency.weekly.value);
    final contact3 = Contact(firstName: 'Peter', lastName: 'Pan'); // No ID initially

    setUp(() {
      dataSource = ContactsSharedPreferencesSource();
      // Initialize with empty values for each test
      SharedPreferences.setMockInitialValues({});
    });

    Future<List<Contact>> getStoredContacts() async {
      final prefs = await SharedPreferences.getInstance();
      final encoded = prefs.getStringList(spKey) ?? [];
      return encoded.map((e) => Contact.fromJson(jsonDecode(e))).toList();
    }

    test('add - should add a contact and assign an ID', () async {
      final addedContact = await dataSource.add(contact3);
      expect(addedContact.id, isNotNull);
      expect(addedContact.id, 1);
      expect(addedContact.firstName, contact3.firstName);

      final storedContacts = await getStoredContacts();
      expect(storedContacts.length, 1);
      expect(storedContacts.first.id, 1);
      expect(storedContacts.first.firstName, contact3.firstName);
    });

    test('add - should assign incremental IDs', () async {
      await dataSource.add(contact3.copyWith(firstName: "First"));
      final addedContact2 = await dataSource.add(contact3.copyWith(firstName: "Second"));
      
      expect(addedContact2.id, 2);
      final storedContacts = await getStoredContacts();
      expect(storedContacts.length, 2);
      expect(storedContacts.map((c) => c.id).toList(), [1, 2]);
    });

    test('addMany - should add multiple contacts and assign IDs', () async {
      final itemsToAdd = [
        Contact(firstName: 'Alice', lastName: 'Smith'),
        Contact(firstName: 'Bob', lastName: 'Johnson'),
      ];
      final addedContacts = await dataSource.addMany(itemsToAdd);

      expect(addedContacts.length, 2);
      expect(addedContacts[0].id, 1);
      expect(addedContacts[0].firstName, 'Alice');
      expect(addedContacts[1].id, 2);
      expect(addedContacts[1].firstName, 'Bob');

      final storedContacts = await getStoredContacts();
      expect(storedContacts.length, 2);
      expect(storedContacts.map((c) => c.id).toList(), [1, 2]);
    });
    
    test('addMany - with existing contacts, should assign correct next IDs', () async {
      SharedPreferences.setMockInitialValues({
        spKey: [jsonEncode(contact1.toJson())]
      });
      final itemsToAdd = [
        Contact(firstName: 'Alice', lastName: 'Smith'),
        Contact(firstName: 'Bob', lastName: 'Johnson'),
      ];
      final addedContacts = await dataSource.addMany(itemsToAdd);
      expect(addedContacts.length, 2);
      expect(addedContacts[0].id, 2); // contact1.id is 1, so next is 2
      expect(addedContacts[1].id, 3);

      final storedContacts = await getStoredContacts();
      expect(storedContacts.length, 3);
       expect(storedContacts.map((c) => c.id).toSet(), {1, 2, 3});
    });


    test('getAll - should return all stored contacts', () async {
      SharedPreferences.setMockInitialValues({
        spKey: [jsonEncode(contact1.toJson()), jsonEncode(contact2.toJson())]
      });
      final contacts = await dataSource.getAll();
      expect(contacts.length, 2);
      expect(contacts.any((c) => c.id == contact1.id), isTrue);
      expect(contacts.any((c) => c.id == contact2.id), isTrue);
    });

    test('getAll - should return empty list if no contacts', () async {
      final contacts = await dataSource.getAll();
      expect(contacts, isEmpty);
    });

    test('getById - should return contact with matching ID', () async {
      SharedPreferences.setMockInitialValues({
        spKey: [jsonEncode(contact1.toJson()), jsonEncode(contact2.toJson())]
      });
      final foundContact = await dataSource.getById(contact1.id!);
      expect(foundContact, isNotNull);
      expect(foundContact!.id, contact1.id);
      expect(foundContact.firstName, contact1.firstName);
    });

    test('getById - should return null if contact not found', () async {
      SharedPreferences.setMockInitialValues({
        spKey: [jsonEncode(contact1.toJson())]
      });
      final foundContact = await dataSource.getById(99);
      expect(foundContact, isNull);
    });

    test('update - should update existing contact', () async {
      SharedPreferences.setMockInitialValues({
        spKey: [jsonEncode(contact1.toJson())]
      });
      final updatedContactData = contact1.copyWith(firstName: 'Johnny');
      final result = await dataSource.update(updatedContactData);

      expect(result.firstName, 'Johnny');
      final storedContacts = await getStoredContacts();
      expect(storedContacts.length, 1);
      expect(storedContacts.first.firstName, 'Johnny');
      expect(storedContacts.first.id, contact1.id);
    });
    
    test('update - should not add if contact does not exist (as per current implementation)', () async {
      SharedPreferences.setMockInitialValues({
        spKey: [jsonEncode(contact1.toJson())]
      });
      final nonExistingContact = Contact(id: 99, firstName: "Ghost", lastName: "Writer");
      final result = await dataSource.update(nonExistingContact);

      expect(result.id, 99); // Returns the item passed
      final storedContacts = await getStoredContacts();
      expect(storedContacts.length, 1); // No new contact added
      expect(storedContacts.first.id, contact1.id);
    });


    test('delete - should remove contact with matching ID', () async {
      SharedPreferences.setMockInitialValues({
        spKey: [jsonEncode(contact1.toJson()), jsonEncode(contact2.toJson())]
      });
      await dataSource.delete(contact1.id!);
      final storedContacts = await getStoredContacts();
      expect(storedContacts.length, 1);
      expect(storedContacts.first.id, contact2.id);
    });

    test('deleteMany - should remove multiple contacts', () async {
      final contactExtra = Contact(id:3, firstName: "Extra", lastName: "Person");
       SharedPreferences.setMockInitialValues({
        spKey: [jsonEncode(contact1.toJson()), jsonEncode(contact2.toJson()), jsonEncode(contactExtra.toJson())]
      });
      await dataSource.deleteMany([contact1.id!, contactExtra.id!]);
      final storedContacts = await getStoredContacts();
      expect(storedContacts.length, 1);
      expect(storedContacts.first.id, contact2.id);
    });

    test('count - should return number of contacts', () async {
       SharedPreferences.setMockInitialValues({
        spKey: [jsonEncode(contact1.toJson()), jsonEncode(contact2.toJson())]
      });
      final count = await dataSource.count();
      expect(count, 2);
    });
    
    test('count - should return 0 if no contacts', () async {
      final count = await dataSource.count();
      expect(count, 0);
    });

    test('deleteAll - should remove all contacts', () async {
      SharedPreferences.setMockInitialValues({
        spKey: [jsonEncode(contact1.toJson()), jsonEncode(contact2.toJson())]
      });
      await dataSource.deleteAll();
      final storedContacts = await getStoredContacts();
      expect(storedContacts, isEmpty);
      final count = await dataSource.count();
      expect(count, 0);
    });
  });
}
