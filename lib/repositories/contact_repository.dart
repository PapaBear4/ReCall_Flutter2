// lib/repositories/contactrepository.dart
import 'package:recall/models/contact.dart'; // Import the Contact model
import 'package:logger/logger.dart';
import 'package:objectbox/objectbox.dart';
import 'package:recall/models/contact_frequency.dart';
import 'package:recall/repositories/web_contact_repository.dart';
import 'repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

var contactRepoLogger = Logger();

class ContactRepository implements Repository<Contact> {
  late final Store? _store;
  late final Box<Contact>? _contactBox;
  final WebContactRepository _webContactRepository = WebContactRepository();

  // Initialize the repository
  ContactRepository(this._store) {
    if (!kIsWeb) {
      try {
        //_store = openStore();
        _contactBox = _store!.box<Contact>();
        //_initializeData();
      } catch (e) {
        contactRepoLogger.e("Error opening ObjectBox store: $e");
      }
    }
  }

  Future<void> _initializeData() async {
    if (_store != null && _contactBox != null && _contactBox.isEmpty()) {
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

//
  @override
  Future<List<Contact>> getAll() async {
    if (!kIsWeb && _store != null && _contactBox != null) {
      return _contactBox.getAll();
    } else {
      return await _webContactRepository.getAll();
    }
  }

  @override
  Future<Contact?> getById(int id) async {
    if (!kIsWeb && _store != null && _contactBox != null) {
      return _contactBox.get(id);
    } else {
      return await _webContactRepository.getById(id);
    }
  }

  @override
  Future<Contact> add(Contact item) async {
    //TODO: need something here to handle the id value
    if (!kIsWeb && _store != null && _contactBox != null) {
      try {
        //contactRepoLogger.i("LOG contact sent for save $item");
        final newId = _contactBox.put(item);
        //contactRepoLogger.i("LOG SUCCESS id returned $newId");
        return item.copyWith(id: newId);
      } catch (e) {
        //contactRepoLogger.i("Error saving to store: $e");
      }
      return item.copyWith(firstName: 'FAILED');
    } else {
      final newContact = await _webContactRepository.add(item);
      return newContact;
    }
  }

  @override
  Future<void> update(Contact item) async {
    if (!kIsWeb && _store != null && _contactBox != null) {
      _contactBox.put(item);
    } else {
      await _webContactRepository.update(item);
    }
  }

  @override
  Future<void> delete(int id) async {
    if (!kIsWeb && _store != null && _contactBox != null) {
      _contactBox.remove(id);
    } else {
      await _webContactRepository.delete(id);
    }
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
        frequency: (ContactFrequency.biweekly.value),
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
        frequency: (ContactFrequency.biweekly.value),
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
