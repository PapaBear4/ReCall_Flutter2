import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:recall/models/contact.dart'; // Import the Contact model
import 'package:logger/logger.dart';

var contactRepoLogger = Logger();

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
      contactRepoLogger.i("loading dummy contacts");
      return [
        Contact(
            id: 1,
            firstName: 'John',
            lastName: 'Doe',
            frequency: ContactFrequency.weekly,
            birthday: DateTime(1980, 4, 4),
            lastContacted: DateTime(2024, 12, 20)),
        Contact(
            id: 2,
            firstName: 'Jane',
            lastName: 'Smith',
            frequency: ContactFrequency.daily,
            birthday: DateTime(1995, 5, 10),
            lastContacted: DateTime(2023, 12, 20)),
        Contact(
            id: 3,
            firstName: 'Peter',
            lastName: 'Jones',
            frequency: ContactFrequency.quarterly,
            birthday: DateTime(1988, 2, 22),
            lastContacted: DateTime(2024, 1, 5)),
        Contact(
            id: 4,
            firstName: 'Alice',
            lastName: 'Johnson',
            frequency: ContactFrequency.never),
        Contact(
            id: 5,
            firstName: 'Bob',
            lastName: 'Williams',
            frequency: ContactFrequency.yearly,
            birthday: DateTime(1992, 8, 15),
            lastContacted: DateTime(2023, 11, 10)),
        Contact(
            id: 6,
            firstName: 'Charlie',
            lastName: 'Brown',
            frequency: ContactFrequency.quarterly,
            lastContacted: DateTime(2024, 12, 31)),
        Contact(
            id: 7,
            firstName: 'David',
            lastName: 'Miller',
            frequency: ContactFrequency.monthly),
        Contact(
            id: 8,
            firstName: 'Emily',
            lastName: 'Davis',
            frequency: ContactFrequency.never,
            birthday: DateTime(1990, 11, 3),
            lastContacted: DateTime(2023, 12, 31)),
        Contact(
            id: 9,
            firstName: 'Frank',
            lastName: 'Garcia',
            frequency: ContactFrequency.biWeekly),
        Contact(
            id: 10,
            firstName: 'Grace',
            lastName: 'Rodriguez',
            frequency: ContactFrequency.monthly),
        Contact(
            id: 11,
            firstName: 'Henry',
            lastName: 'Wilson',
            frequency: ContactFrequency.rarely),
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
    int nextId = 1;
    if (contacts.isNotEmpty) {
      nextId = contacts.map((c) => c.id).reduce(max) + 1;
    }
    final newContact = contact.copyWith(id: nextId);
    contacts.add(newContact);
    await saveContacts(contacts);
  }

  Future<void> deleteContact(int contactId) async {
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

  Future<Contact> getContactById(int contactId) async {
    contactRepoLogger.i(
        'Searching for contact with ID: $contactId in ContactRepository'); // <-- Add this
    final contacts = await loadContacts();
    contactRepoLogger.i('Loaded contacts: ${contacts.map((e) => e.id)}');

    final contact = contacts.firstWhere(
      (contact) => contact.id == contactId,
      orElse: () {
        contactRepoLogger.i('Contact with ID $contactId not found'); // <-- Add this
        throw Exception('Contact not found');
      },
    );
    return contact;
  }
}
