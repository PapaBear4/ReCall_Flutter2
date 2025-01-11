// lib/repositories/contactrepository.dart
import 'package:recall/models/contact.dart'; // Import the Contact model
import 'package:logger/logger.dart';
import 'package:objectbox/objectbox.dart';
import 'package:recall/models/contact_frequency.dart';
import 'package:recall/sources/data_source.dart';
import 'repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

var contactRepoLogger = Logger();

class ContactRepository implements Repository<Contact> {
  late final Store? _store;
  late final Box<Contact>? _contactBox;
  late final DataSource<Contact> _source;
  final Map<int, Contact> _contacts = {}; 

  // Initialize the repository
  ContactRepository(this._store, this._source) {
    if (!kIsWeb) {
      try {
        //_store = openStore();
        _contactBox = _store!.box<Contact>();
        _initializeData();
      } catch (e) {
        contactRepoLogger.i("Erro opening ObjectBox store: $e");
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
        contactRepoLogger.i("LOG contact sent for save $item");
        final newId = _contactBox.put(item);
        contactRepoLogger.i("LOG SUCCESS id returned $newId");
        return item.copyWith(id: newId);
      } catch (e) {
        contactRepoLogger.i("Error saving to store: $e");
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
