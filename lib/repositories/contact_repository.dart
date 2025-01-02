import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:recall/models/contact.dart'; // Import the Contact model
import 'package:logger/logger.dart';

var contactRepoLogger = Logger();

class ContactRepository {
  final List<Contact> _contacts = []; // Private list to store contacts

  // Initialize the repository
  ContactRepository() {
    _initializeStorage();
  }

  //Other methods here ...
  Future<void> updateContact(Contact updatedContact) async {
    final index =
        _contacts.indexWhere((contact) => contact.id == updatedContact.id);
    if (index != -1) {
      _contacts[index] = updatedContact;
    }
  }

  Future<Contact> getContactById(int contactId) async {
    return _contacts.firstWhere((contact) => contact.id == contactId);
  }

  Future<List<Contact>> loadContacts() async {
    return _contacts;
  }

  Future<void> _initializeStorage() async {
    try {
      // 1. Check for persistent storage
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/contacts.json');
      if (await file.exists()) {
        // 2. Load existing data from file
        final String contents = await file.readAsString();
        final List<dynamic> jsonContacts = json.decode(contents);
        for (final jsonContact in jsonContacts) {
          _contacts.add(Contact.fromJson(jsonContact));
        }
      } else {
        // 3. Initialize with dummy data if the file doesn't exist
        contactRepoLogger.i("LOG: No file found.  Initializing with dummy data...");
        // Add some dummy contacts to _contacts
        _contacts.addAll(InMemoryContactRepository.createDummyContacts());

        // Save the dummy data to create the file for future loads.
        await saveContacts(_contacts);
      }
    } catch (e) {
      contactRepoLogger.e("LOG: Error initializing storage: $e");
      // Fallback to in-memory data
      contactRepoLogger
          .i("Initializing with dummy data due to initialization error...");
      _contacts.addAll(InMemoryContactRepository.createDummyContacts());
    }
  }

  Future<void> saveContacts(List<Contact> contacts) async {
    //Save contacts to a file
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/contacts.json');
      final String jsonString = jsonEncode(contacts);
      await file.writeAsString(jsonString);
    } catch (e) {
      contactRepoLogger.e("LOG: Error saving contacts: $e");
    }
  }

    Future<void> deleteContact(int contactId) async {
    // 1. Load existing contacts from storage.
    final contacts = await loadContacts();
    // 2. Remove the contact with the matching ID.
    contacts.removeWhere((contact) => contact.id == contactId);
    try {
      await saveContacts(contacts);
    } catch (e) {
      // Handle the error appropriately, e.g., log the error, show a message to the user.
      contactRepoLogger.i("LOG:Error saving contacts: $e");
    }
  }

}


  // other methods (deleteContact, getContactById, loadContacts, etc.)


/*
Future<void> addContact(Contact contact) async {
  final contacts = await loadContacts();
  int nextId = 1;
  if (contacts.isNotEmpty) {
    nextId = contacts.map((c) => c.id).reduce(max) + 1;
  }
  final newContact = contact.copyWith(id: nextId);
  contacts.add(newContact);
  try {
    await saveContacts(contacts);
  } catch (e) {
    // Handle the error appropriately, e.g., log the error, show a message to the user.
    contactRepoLogger.i("LOG:Error saving contacts: $e");
  }
}
*/


class InMemoryContactRepository {
  static List<Contact> createDummyContacts() {
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
