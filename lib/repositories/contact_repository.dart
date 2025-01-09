import 'package:recall/models/contact.dart'; // Import the Contact model
import 'package:logger/logger.dart';
import 'package:objectbox/objectbox.dart';
import 'package:recall/models/contact_frequency.dart';

var contactRepoLogger = Logger();

class ContactRepository {
  final Store _store;
  late final Box<Contact> _contactBox;

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
      //1. create a single contact
      final firstContact = Contact(
        id: null,
        firstName: 'Delete',
        lastName: 'Me',
        frequency: ContactFrequency.never.value,
        birthday: null,
        lastContacted: null,
      ); // first dummy contact
      //2. add it to the box
      final firstId = _contactBox.put(firstContact);
      //3. update the contact
      final firstSavedContact = firstContact.copyWith(id: firstId);
      //get the dummy contacts
      //final dummyContacts = InMemoryContactRepository.createDummyContacts();
      //create more dummy contacts
      final secondContact = Contact(
        id: null,
        firstName: 'Delete',
        lastName: 'Me 2',
        frequency: ContactFrequency.never.value,
        birthday: null,
        lastContacted: null,
      ); // second dummy contact
      final thirdContact = Contact(
        id: 0,
        firstName: 'Delete',
        lastName: 'Me 3',
        frequency: ContactFrequency.never.value,
        birthday: null,
        lastContacted: null,
      ); // third dummy contact
      final fourthContact = Contact(
        id: 0,
        firstName: 'Delete',
        lastName: 'Me 4',
        frequency: ContactFrequency.never.value,
        birthday: null,
        lastContacted: null,
      ); // fourth dummy contact
      // add a second contact
      final secondId = _contactBox.put(secondContact);
      //3. update the contact
      final secondSavedContact = secondContact.copyWith(id: secondId);


      final contactsToPut = [thirdContact, fourthContact];
      final addedIds =
          _contactBox.putMany(contactsToPut); // Add dummy contacts to ObjectBox
      contactRepoLogger.i("LOG added IDs: $addedIds");
    }
  }

  /// Updates an existing contact in the repository.
  ///
  /// Finds the contact with the matching ID and replaces it with the
  /// `updatedContact` object.
  Future<void> updateContact(Contact updatedContact) async {
    _contactBox.put(updatedContact);
  }

  /// Retrieves a contact from the repository by its ID.
  ///
  /// Searches the contact list for a contact with the given `contactId` and
  /// returns it. Throws an exception if no contact is found with that ID.
  Future<Contact> getContactById(int contactId) async {
    return _contactBox.get(contactId) ??
        Contact(
          id: 0,
          firstName: '',
          lastName: '',
          frequency: ContactFrequency.never.value,
          birthday: null,
          lastContacted: null,
        ); // Return null if not found
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
  Future<Contact> addContact(Contact contact) async {
    final newId = _contactBox.put(contact);
    return contact.copyWith(id: newId);
  }
}

class InMemoryContactRepository {
  static List<Contact> createDummyContacts() {
    return [
      // Superheroes
      Contact(
        id: 0,
        firstName: 'Clark',
        lastName: 'Kent',
        frequency: (ContactFrequency.daily.value),
        birthday: DateTime(1938, 6, 18), // Superman's birthday
        lastContacted: DateTime(2024, 12, 20),
      ),
      Contact(
        id: 0,
        firstName: 'Bruce',
        lastName: 'Wayne',
        frequency: (ContactFrequency.weekly.value),
        birthday: DateTime(1939, 5, 27), // Batman's birthday
        lastContacted: DateTime(2024, 12, 15),
      ),
      Contact(
        id: 0,
        firstName: 'Diana',
        lastName: 'Prince',
        frequency: (ContactFrequency.monthly.value),
        birthday: DateTime(1941, 12, 7), // Wonder Woman's birthday
        lastContacted: DateTime(2024, 12, 1),
      ),
      Contact(
        id: 0,
        firstName: 'Peter',
        lastName: 'Parker',
        frequency: (ContactFrequency.biWeekly.value),
        birthday: DateTime(1962, 8, 10), // Spider-Man's birthday
        lastContacted: DateTime(2024, 11, 25),
      ),
      Contact(
        id: 0,
        firstName: 'Tony',
        lastName: 'Stark',
        frequency: (ContactFrequency.rarely.value),
        birthday: DateTime(1970, 5, 29), // Iron Man's birthday
        lastContacted: DateTime(2024, 10, 15),
      ),

      // Famous people
      Contact(
        id: 0,
        firstName: 'Albert',
        lastName: 'Einstein',
        frequency: (ContactFrequency.yearly.value),
        birthday: DateTime(1879, 3, 14),
        lastContacted: DateTime(2024, 9, 1),
      ),
      Contact(
        id: 0,
        firstName: 'Marie',
        lastName: 'Curie',
        frequency: (ContactFrequency.quarterly.value),
        birthday: DateTime(1867, 11, 7),
        lastContacted: DateTime(2024, 8, 15),
      ),
      Contact(
        id: 0,
        firstName: 'Leonardo',
        lastName: 'da Vinci',
        frequency: (ContactFrequency.never.value),
        birthday: DateTime(1452, 4, 15),
        lastContacted: DateTime(2024, 7, 1),
      ),
      Contact(
        id: 0,
        firstName: 'William',
        lastName: 'Shakespeare',
        frequency: (ContactFrequency.monthly.value),
        birthday: DateTime(1564, 4, 26),
        lastContacted: DateTime(2024, 6, 15),
      ),
      Contact(
        id: 0,
        firstName: 'Nelson',
        lastName: 'Mandela',
        frequency: (ContactFrequency.weekly.value),
        birthday: DateTime(1918, 7, 18),
        lastContacted: DateTime(2024, 5, 20),
      ),
      Contact(
        id: 0,
        firstName: 'Oprah',
        lastName: 'Winfrey',
        frequency: (ContactFrequency.daily.value),
        birthday: DateTime(1954, 1, 29),
        lastContacted: DateTime(2024, 4, 10),
      ),
      Contact(
        id: 0,
        firstName: 'Stephen',
        lastName: 'Hawking',
        frequency: (ContactFrequency.biWeekly.value),
        birthday: DateTime(1942, 1, 8),
        lastContacted: DateTime(2024, 3, 25),
      ),
      Contact(
        id: 0,
        firstName: 'Malala',
        lastName: 'Yousafzai',
        frequency: (ContactFrequency.rarely.value),
        birthday: DateTime(1997, 7, 12),
        lastContacted: DateTime(2024, 2, 15),
      ),
      Contact(
        id: 0,
        firstName: 'Elon',
        lastName: 'Musk',
        frequency: (ContactFrequency.never.value),
        birthday: DateTime(1971, 6, 28),
        lastContacted: DateTime(2024, 1, 5),
      ),
      Contact(
        id: 0,
        firstName: 'Beyoncé',
        lastName: 'Knowles',
        frequency: (ContactFrequency.yearly.value),
        birthday: DateTime(1981, 9, 4),
        lastContacted: DateTime(2023, 12, 20),
      ),
      Contact(
        id: 0,
        firstName: 'Michelle',
        lastName: 'Obama',
        frequency: (ContactFrequency.quarterly.value),
        birthday: DateTime(1964, 1, 17),
        lastContacted: DateTime(2023, 11, 10),
      ),
      Contact(
        id: 0,
        firstName: 'Bill',
        lastName: 'Gates',
        frequency: (ContactFrequency.monthly.value),
        birthday: DateTime(1955, 10, 28),
        lastContacted: DateTime(2023, 10, 1),
      ),
      Contact(
        id: 0,
        firstName: 'Steve',
        lastName: 'Jobs',
        frequency: (ContactFrequency.never.value),
        birthday: DateTime(1955, 2, 24),
        lastContacted: DateTime(2023, 9, 15),
      ),
      Contact(
        id: 0,
        firstName: 'J.K.',
        lastName: 'Rowling',
        frequency: (ContactFrequency.weekly.value),
        birthday: DateTime(1965, 7, 31),
        lastContacted: DateTime(2023, 8, 25),
      ),
      Contact(
        id: 0,
        firstName: 'Taylor',
        lastName: 'Swift',
        frequency: (ContactFrequency.daily.value),
        birthday: DateTime(1989, 12, 13),
        lastContacted: DateTime(2023, 7, 15),
      ),
    ];
  }
}
