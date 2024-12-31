import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:myapp/models/contact.dart'; // Import the Contact model

class ContactRepository {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/contacts.json');
  }

  Future<List<Contact>> loadContacts() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.map((json) => Contact.fromMap(json)).toList();
    } catch (e) {
      // If encountering an error, return dummy data for now.
      // In a production app, you would return an empty list or handle the error appropriately.
      return [
        Contact(firstName: 'John', lastName: 'Doe', frequency: ContactFrequency.weekly),
        Contact(
            firstName: 'Jane',
            lastName: 'Smith',
            frequency: ContactFrequency.daily,
            birthday: DateTime(1995, 5, 10),
            lastContacted: DateTime(2023, 12, 20)),
        Contact(
            firstName: 'Peter',
            lastName: 'Jones',
            frequency: ContactFrequency.quarterly,
            birthday: DateTime(1988, 2, 22),
            lastContacted: DateTime(2024, 1, 5)),
        Contact(firstName: 'Alice', lastName: 'Johnson', frequency: ContactFrequency.never),
        Contact(
            firstName: 'Bob',
            lastName: 'Williams',
            frequency: ContactFrequency.yearly,
            birthday: DateTime(1992, 8, 15),
            lastContacted: DateTime(2023, 11, 10)),
        Contact(firstName: 'Charlie', lastName: 'Brown', frequency: ContactFrequency.quarterly),
        Contact(firstName: 'David', lastName: 'Miller', frequency: ContactFrequency.monthly),
        Contact(
            firstName: 'Emily',
            lastName: 'Davis',
            frequency: ContactFrequency.never,
            birthday: DateTime(1990, 11, 3),
            lastContacted: DateTime(2023, 12, 31)),
        Contact(firstName: 'Frank', lastName: 'Garcia', frequency: ContactFrequency.biWeekly),
        Contact(firstName: 'Grace', lastName: 'Rodriguez', frequency: ContactFrequency.monthly),
        Contact(firstName: 'Henry', lastName: 'Wilson', frequency: ContactFrequency.rarely),
      ];
    }
  }

  Future<void> saveContacts(List<Contact> contacts) async {
    final file = await _localFile;
    final List<Map<String, dynamic>> jsonList =
        contacts.map((contact) => contact.toMap()).toList();
    await file.writeAsString(json.encode(jsonList));
  }

  Future<void> addContact(Contact contact) async {
    final contacts = await loadContacts();
    contacts.add(contact);
    await saveContacts(contacts);
  }

  Future<void> deleteContact(String contactId) async {
    final contacts = await loadContacts();
    contacts.removeWhere((contact) => contact.id == contactId);
    await saveContacts(contacts);
  }

  Future<void> updateContact(Contact updatedContact) async {
    final contacts = await loadContacts();
    final index =
        contacts.indexWhere((contact) => contact.id == updatedContact.id);
    if (index != -1) {
      contacts[index] = updatedContact;
      await saveContacts(contacts);
    }
  }
}
