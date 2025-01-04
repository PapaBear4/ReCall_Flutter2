import 'dart:math';
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

  /// Updates an existing contact in the repository.
  ///
  /// Finds the contact with the matching ID and replaces it with the
  /// `updatedContact` object.
  Future<void> updateContact(Contact updatedContact) async {
    final index =
        _contacts.indexWhere((contact) => contact.id == updatedContact.id);
    if (index != -1) {
      _contacts[index] = updatedContact;
    }
  }

  /// Retrieves a contact from the repository by its ID.
  ///
  /// Searches the contact list for a contact with the given `contactId` and
  /// returns it. Throws an exception if no contact is found with that ID.
  Future<Contact> getContactById(int contactId) async {
    try {
      return _contacts.firstWhere((contact) => contact.id == contactId);
    } catch (e) {
      // If no contact is found, return null
      return Contact(
        id: 0,
        firstName:'',
        lastName:'',
        birthday: null,
        frequency: ContactFrequency.never,
        lastContacted: null,
      ) ; 
    }
  }

  /// Loads all contacts from the repository.
  ///
  /// Returns a list of all contacts stored in memory.
  // They were put there in the repository initialization.
  // in the future this may need adjusted to account for local storage
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
        contactRepoLogger
            .i("LOG: No file found.  Initializing with dummy data...");
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

  /// Saves the current list of contacts to persistent storage.
  ///
  /// Encodes the contacts as JSON and writes them to a file in the
  /// application's documents directory.
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

  /// Deletes a contact from the repository by its ID.
  ///
  /// Removes the contact with the matching `contactId` from the list and
  /// updates the persistent storage.
  Future<void> deleteContact(int contactId) async {
    contactRepoLogger.i("LOG: ID for deltion: $contactId");
    // 2. Remove the contact with the matching ID.
    _contacts.removeWhere((contact) => contact.id == contactId);
    try {
      //await saveContacts(_contacts);
    } catch (e) {
      // Handle the error appropriately, e.g., log the error, show a message to the user.
      contactRepoLogger.i("LOG:Error saving contacts: $e");
    }
  }

    Future<void> updateLastContacted(int contactId) async {
    try {
      final index = _contacts.indexWhere((contact) => contact.id == contactId);
        if(index != -1){
          _contacts[index] = _contacts[index].copyWith(lastContacted: DateTime.now());
        }
    } catch (e) {
      // Handle the error appropriately, e.g., log the error, show a message to the user.
    }
  }


  /// Adds a new contact to the repository.
  ///
  /// Generates a unique ID for the new contact, adds it to the list, and
  /// updates the persistent storage.
  Future<void> addContact(Contact contact) async {
    // Generate a unique ID for the new contact
    int nextId = 0;
    if (_contacts.isNotEmpty) {
      nextId = _contacts.map((c) => c.id).reduce(max) + 1;
    }
    final newContact = contact.copyWith(id: nextId);

    // Add the new contact to the list and save
    _contacts.add(newContact);
    try {
      await saveContacts(_contacts);
    } catch (e) {
      contactRepoLogger.e("LOG: Error saving contacts: $e");
    }
  }
}

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
