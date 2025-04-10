// lib/repositories/contact_repository.dart
import 'package:recall/models/contact.dart'; // Import the Contact model
import 'package:recall/utils/logger.dart'; // Adjust path if needed
import 'package:objectbox/objectbox.dart';
import 'package:recall/sources/contact_ob_source.dart';
import 'package:recall/sources/contact_sp_source.dart';
import 'package:recall/sources/data_source.dart';
import 'repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ContactRepository implements Repository<Contact> {
  late final Store? _store;
  late final Box<Contact>? _contactBox;
  late final DataSource<Contact> _source;
  final Map<int, Contact> _contacts = {};

  // Initialize the repository
  ContactRepository(this._store) {
    if (!kIsWeb) {
      try {
        _contactBox = _store!.box<Contact>();
        _source = ContactObjectBoxSource(_contactBox!);
      } catch (e) {
        logger.i("Error opening ObjectBox store: $e");
        _source = _createInMemorySource();
      }
    } else {
      _source = _createInMemorySource();
      try {
        _source = ContactsSharedPreferencesSource();
      } catch (e) {
        logger.i("Error opening shared preferences: $e");
      }
    }
  }

  DataSource<Contact> _createInMemorySource() {
    return _InMemoryContactSource(contacts: _contacts);
  }

  @override
  Future<List<Contact>> getAll() async {
    final contacts = await _source.getAll();
    _contacts.clear();
    for (final contact in contacts) {
      if (contact.id != null) {
        _contacts[contact.id!] = contact;
      }
    }
    return contacts;
  }

  @override
  Future<Contact?> getById(int id) async {
    if (_contacts.containsKey(id)) {
      final foundContact = _contacts[id];
      return foundContact;
    }
    final foundContact = _source.getById(id);
    return foundContact;
  }

  @override
  Future<Contact> add(Contact item) async {
    logger.i('LOG: repo received from call: $item');
    final contact = await _source.add(item);
    logger.i('LOG: repo got back from source: $contact');
    final addedContact = await _source.getById(contact.id!);
    logger.i('LOG: repo retrieved: $addedContact');

    if (item.id != null) {
      _contacts[item.id!] = item;
    }
    return contact;
  }

  @override
  Future<Contact> update(Contact item) async {
    final contact = await _source.update(item);
    if (item.id != null) {
      _contacts[item.id!] = item;
    }
    return contact;
  }

  @override
  Future<void> delete(int id) async {
    await _source.delete(id);
    _contacts.remove(id);
  }

  @override
  Future<List<Contact>> addMany(List<Contact> items) async {
    // We expect items here NOT to have IDs yet,
    // the source should assign them.
    final addedContacts = await _source.addMany(items);
    // Update cache with the contacts returned from the source (which now have IDs)
    for (final contact in addedContacts) {
      if (contact.id != null) {
        _contacts[contact.id!] = contact;
      }
    }
    return addedContacts;
  }

  Future<void> deleteMany(List<int> ids) async {
    try {
      await _source.deleteMany(ids); // Call the data source's deleteMany
      // Remove deleted contacts from the cache
      for (final id in ids) {
        _contacts.remove(id);
      }
      logger.i(
          "Successfully deleted ${ids.length} contacts from repository and cache.");
    } catch (e) {
      logger.e("Error deleting multiple contacts (${ids.join(', ')}): $e");
      // Optionally re-throw the error if the caller needs to handle it
      rethrow;
    }
  }

  @override
  Future<void> deleteAll() async {
    await _source.deleteAll();
    _contacts.clear(); // Clear the cache
  }
}

class _InMemoryContactSource implements DataSource<Contact> {
  final Map<int, Contact> contacts;

  // Keep track of the next ID for in-memory source
  int _nextId = 1;

  _InMemoryContactSource({required this.contacts}) {
    // Initialize _nextId based on existing contacts if any
    if (contacts.isNotEmpty) {
      _nextId = contacts.keys.reduce((a, b) => a > b ? a : b) + 1;
    }
  }

  @override
  Future<Contact> add(Contact item) async {
    // Use and increment _nextId
    final newItem = item.copyWith(id: _nextId++);
    contacts[newItem.id!] = newItem;
    return newItem;
  }

  @override
  Future<List<Contact>> addMany(List<Contact> items) async {
    final updatedItems = <Contact>[];
    for (final item in items) {
      // Use and increment _nextId for each item
      final newItem = item.copyWith(id: _nextId++);
      contacts[newItem.id!] = newItem;
      updatedItems.add(newItem);
    }
    return updatedItems;
  }

  @override
  Future<void> delete(int id) async {
    contacts.remove(id);
  }

  @override
  Future<void> deleteMany(List<int> ids) async {
    for (final id in ids) {
      contacts.remove(id);
    }
  }

  @override
  Future<int> count() async {
    return contacts.length;
  }

  @override
  Future<List<Contact>> getAll() async {
    return contacts.values.toList();
  }

  @override
  Future<Contact?> getById(int id) async {
    return contacts[id];
  }

  @override
  Future<Contact> update(Contact item) async {
    if (item.id == null) return item;
    contacts[item.id!] = item;
    return item;
  }

  @override
  Future<void> deleteAll() async {
    contacts.clear();
    _nextId = 1; // Reset ID counter for in-memory
  }
}
