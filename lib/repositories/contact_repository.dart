import 'package:recall/models/contact.dart'; // Import the Contact model
import 'package:logger/logger.dart';
import 'package:objectbox/objectbox.dart';
import 'package:recall/models/contact_frequency.dart';

var contactRepoLogger = Logger();

class ContactRepository {
  final Store _store;
  late final Box<Contact> _contactBox;
  final List<Contact> _contacts = []; // Private list to store contacts

  // Initialize the repository
  ContactRepository(this._store) {
    _contactBox = _store.box<Contact>();
    _initializeData();
  }

  Future<void> _initializeData() async {
    if (_contactBox.isEmpty()) {
      // Check if the database is empty
      contactRepoLogger
          .i("LOG: No contacts found.  Initializing with dummy data...");
      final dummyContacts = InMemoryContactRepository.createDummyContacts();
      _contactBox.putMany(dummyContacts); // Add dummy contacts to ObjectBox
    }
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
        firstName: '',
        lastName: '',
        birthday: null,
        frequencyValue: 8,
        lastContacted: null,
      );
    }
  }

  /// Loads all contacts from the repository.
  ///
  /// Returns a list of all contacts stored in memory.
  // They were put there in the repository initialization.
  // in the future this may need adjusted to account for local storage
  Future<List<Contact>> loadContacts() async {
    return _contactBox.getAll();
  }

  /// Deletes a contact from the repository by its ID.
  ///
  /// Removes the contact with the matching `contactId` from the list and
  /// updates the persistent storage.
  Future<void> deleteContact(int contactId) async {
    _contactBox.remove(contactId);
  }

  Future<void> updateLastContacted(int contactId) async {
    final contact = _contactBox.get(contactId);
    if (contact != null) {
      final updatedContact =
          contact.copyWith(lastContacted: DateTime.now()); // Use copyWith
      _contactBox.put(updatedContact); // Store the updated contact
    }
  }

  /// Adds a new contact to the repository.
  ///
  /// Generates a unique ID for the new contact, adds it to the list, and
  /// updates the persistent storage.
  Future<void> addContact(Contact contact) async {
    _contactBox.put(contact);
  }
}

class InMemoryContactRepository {
  static List<Contact> createDummyContacts() {
    return [
      // Superheroes
      Contact(
        id: 1,
        firstName: 'Clark',
        lastName: 'Kent',
        frequencyValue: getContactFrequencyIndex(ContactFrequency.daily),
        birthday: DateTime(1938, 6, 18), // Superman's birthday
        lastContacted: DateTime(2024, 12, 20),
      ),
      Contact(
        id: 2,
        firstName: 'Bruce',
        lastName: 'Wayne',
        frequencyValue: getContactFrequencyIndex(ContactFrequency.weekly),
        birthday: DateTime(1939, 5, 27), // Batman's birthday
        lastContacted: DateTime(2024, 12, 15),
      ),
      Contact(
        id: 3,
        firstName: 'Diana',
        lastName: 'Prince',
        frequencyValue: getContactFrequencyIndex(ContactFrequency.monthly),
        birthday: DateTime(1941, 12, 7), // Wonder Woman's birthday
        lastContacted: DateTime(2024, 12, 1),
      ),
      Contact(
        id: 4,
        firstName: 'Peter',
        lastName: 'Parker',
        frequencyValue: getContactFrequencyIndex(ContactFrequency.biWeekly),
        birthday: DateTime(1962, 8, 10), // Spider-Man's birthday
        lastContacted: DateTime(2024, 11, 25),
      ),
      Contact(
        id: 5,
        firstName: 'Tony',
        lastName: 'Stark',
        frequencyValue: getContactFrequencyIndex(ContactFrequency.rarely),
        birthday: DateTime(1970, 5, 29), // Iron Man's birthday
        lastContacted: DateTime(2024, 10, 15),
      ),

      // Famous people
      Contact(
        id: 6,
        firstName: 'Albert',
        lastName: 'Einstein',
        frequencyValue: getContactFrequencyIndex(ContactFrequency.yearly),
        birthday: DateTime(1879, 3, 14),
        lastContacted: DateTime(2024, 9, 1),
      ),
      Contact(
        id: 7,
        firstName: 'Marie',
        lastName: 'Curie',
        frequencyValue: getContactFrequencyIndex(ContactFrequency.quarterly),
        birthday: DateTime(1867, 11, 7),
        lastContacted: DateTime(2024, 8, 15),
      ),
      Contact(
        id: 8,
        firstName: 'Leonardo',
        lastName: 'da Vinci',
        frequencyValue: getContactFrequencyIndex(ContactFrequency.never),
        birthday: DateTime(1452, 4, 15),
        lastContacted: DateTime(2024, 7, 1),
      ),
      Contact(
        id: 9,
        firstName: 'William',
        lastName: 'Shakespeare',
        frequencyValue: getContactFrequencyIndex(ContactFrequency.monthly),
        birthday: DateTime(1564, 4, 26),
        lastContacted: DateTime(2024, 6, 15),
      ),
      Contact(
        id: 10,
        firstName: 'Nelson',
        lastName: 'Mandela',
        frequencyValue: getContactFrequencyIndex(ContactFrequency.weekly),
        birthday: DateTime(1918, 7, 18),
        lastContacted: DateTime(2024, 5, 20),
      ),
      Contact(
        id: 11,
        firstName: 'Oprah',
        lastName: 'Winfrey',
        frequencyValue: getContactFrequencyIndex(ContactFrequency.daily),
        birthday: DateTime(1954, 1, 29),
        lastContacted: DateTime(2024, 4, 10),
      ),
      Contact(
        id: 12,
        firstName: 'Stephen',
        lastName: 'Hawking',
        frequencyValue: getContactFrequencyIndex(ContactFrequency.biWeekly),
        birthday: DateTime(1942, 1, 8),
        lastContacted: DateTime(2024, 3, 25),
      ),
      Contact(
        id: 13,
        firstName: 'Malala',
        lastName: 'Yousafzai',
        frequencyValue: getContactFrequencyIndex(ContactFrequency.rarely),
        birthday: DateTime(1997, 7, 12),
        lastContacted: DateTime(2024, 2, 15),
      ),
      Contact(
        id: 14,
        firstName: 'Elon',
        lastName: 'Musk',
        frequencyValue: getContactFrequencyIndex(ContactFrequency.never),
        birthday: DateTime(1971, 6, 28),
        lastContacted: DateTime(2024, 1, 5),
      ),
      Contact(
        id: 15,
        firstName: 'Beyoncé',
        lastName: 'Knowles',
        frequencyValue: getContactFrequencyIndex(ContactFrequency.yearly),
        birthday: DateTime(1981, 9, 4),
        lastContacted: DateTime(2023, 12, 20),
      ),
      Contact(
        id: 16,
        firstName: 'Michelle',
        lastName: 'Obama',
        frequencyValue: getContactFrequencyIndex(ContactFrequency.quarterly),
        birthday: DateTime(1964, 1, 17),
        lastContacted: DateTime(2023, 11, 10),
      ),
      Contact(
        id: 17,
        firstName: 'Bill',
        lastName: 'Gates',
        frequencyValue: getContactFrequencyIndex(ContactFrequency.monthly),
        birthday: DateTime(1955, 10, 28),
        lastContacted: DateTime(2023, 10, 1),
      ),
      Contact(
        id: 18,
        firstName: 'Steve',
        lastName: 'Jobs',
        frequencyValue: getContactFrequencyIndex(ContactFrequency.never),
        birthday: DateTime(1955, 2, 24),
        lastContacted: DateTime(2023, 9, 15),
      ),
      Contact(
        id: 19,
        firstName: 'J.K.',
        lastName: 'Rowling',
        frequencyValue: getContactFrequencyIndex(ContactFrequency.weekly),
        birthday: DateTime(1965, 7, 31),
        lastContacted: DateTime(2023, 8, 25),
      ),
      Contact(
        id: 20,
        firstName: 'Taylor',
        lastName: 'Swift',
        frequencyValue: getContactFrequencyIndex(ContactFrequency.daily),
        birthday: DateTime(1989, 12, 13),
        lastContacted: DateTime(2023, 7, 15),
      ),
    ];
  }
}