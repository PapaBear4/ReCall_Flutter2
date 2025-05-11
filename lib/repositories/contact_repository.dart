// lib/repositories/contact_repository.dart
import 'package:recall/models/contact.dart'; // Import the Contact model
import 'package:recall/models/enums.dart';
import 'package:recall/objectbox.g.dart';
import 'package:recall/utils/contact_utils.dart'; // Import the utils
import 'package:recall/utils/logger.dart'; // Adjust path if needed
import 'package:objectbox/objectbox.dart';
import 'package:recall/sources/contact_ob_source.dart';
import 'package:recall/sources/data_source.dart';
import 'repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';
// TODO: Update delete functions to also cancel notifications for that contact

class ContactRepository implements Repository<Contact> {
  late final Store? _store;
  late final Box<Contact>? _contactBox;
  late final DataSource<Contact> _source;
  final Map<int, Contact> _contacts = {};
  final StreamController<List<Contact>> _contactStreamController =
      StreamController.broadcast();

  // MARK: STREAMS
  // Expose the stream for external listeners
  Stream<List<Contact>> get contactStream => _contactStreamController.stream;

  // Emit the current list of contacts to the stream
  void _emitContacts() async {
    try {
      final contacts = await getAll(); // Fetch the latest contacts
      _contactStreamController.add(contacts); // Emit the updated list
    } catch (e) {
      logger.e("Error emitting contacts: $e");
    }
  }

  // Dispose of the StreamController when no longer needed
  void dispose() {
    _contactStreamController.close();
  }

  // MARK: INIT
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
    }
  }

  DataSource<Contact> _createInMemorySource() {
    return _InMemoryContactSource(contacts: _contacts);
  }

  // MARK: GET
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

  // MARK: ADD
  /// Adds a valid contact to the repository and updates the cache.
  @override
  Future<Contact> add(Contact contact) async {
    // Check if the contact is new (ID is null or 0)
    if (contact.id == null || contact.id == 0) {
      try {
        final Contact addedContact =
            await _source.add(contact); // Use the passed 'contact' directly

        // Verify that the data source returned a contact with a valid ID
        if (addedContact.id != null && addedContact.id != 0) {
          // Update the in-memory cache
          _contacts[addedContact.id!] = addedContact;
          // Notify listeners about the change
          _emitContacts();
          // Return the contact, now with its ID
          return addedContact;
        } else {
          // This indicates an issue with the data source if ID wasn't assigned
          final errorMessage =
              "Failed to add contact: Data source did not assign a valid ID.";
          logger.e(errorMessage);
          throw Exception(errorMessage);
        }
      } catch (e) {
        logger.e("Error adding contact in repository: $e");
        rethrow; // Rethrow the exception to be handled by the caller
      }
    } else {
      // If the contact already has an ID, it's not a new contact.
      // This method is specifically for adding new contacts.
      final errorMessage =
          "Attempted to add a contact that already has an ID (${contact.id}). Use update() method instead.";
      logger.w(errorMessage);
      throw ArgumentError(errorMessage);
    }
  }

  /// Adds a list of valid contacts to the repository and updates the cache.
  @override
  Future<List<Contact>> addMany(List<Contact> contacts) async {
    // Check if all contacts are new (ID is null or 0)
    for (final contact in contacts) {
      if (contact.id != null && contact.id != 0) {
        final errorMessage =
            "Attempted to add a list of contacts where one or more contacts already have an ID (${contact.id}). Use update() or a different method for mixed operations.";
        logger.w(errorMessage);
        throw ArgumentError(errorMessage);
      }
    }

    final List<Contact> addedContacts = await _source.addMany(contacts);

    // Update cache with the contacts returned from the source (which now have IDs or are updated)
    for (final contact in addedContacts) {
      if (contact.id != null && contact.id != 0) {
        // Ensure valid ID before caching
        _contacts[contact.id!] = contact;
      } else {
        // Log if a contact came back from the source without a valid ID after addMany
        logger.w(
            "Contact returned from _source.addMany without a valid ID: ${contact.firstName} ${contact.lastName}");
      }
    }
    _emitContacts();
    return addedContacts; // Renamed back to addedContacts as per the new check
  }

  // MARK: UPDATE
  @override
  Future<Contact> update(Contact contact) async {
    final updatedContact = await _source.add(contact);
    if (updatedContact.id != null) {
      _contacts[updatedContact.id!] = updatedContact;
    }
    _emitContacts();
    return updatedContact;
  }

  // MARK: DELETE
  @override // Delete a contact by ID
  Future<void> delete(int id) async {
    await _source.delete(id);
    _contacts.remove(id);
    _emitContacts();
  }

  // delete contact by ID and remove from cache
  Future<void> deleteMany(List<int> ids) async {
    try {
      await _source.deleteMany(ids); // Call the data source's deleteMany
      // Remove deleted contacts from the cache
      for (final id in ids) {
        _contacts.remove(id);
      }
      logger.i(
          "Successfully deleted ${ids.length} contacts from repository and cache.");
      _emitContacts();
    } catch (e) {
      logger.e("Error deleting multiple contacts (${ids.join(', ')}): $e");
      // Optionally re-throw the error if the caller needs to handle it
      rethrow;
    }
  }

  @override // Delete all contacts
  Future<void> deleteAll() async {
    await _source.deleteAll();
    _contacts.clear(); // Clear the cache
    _emitContacts();
  }

  // MARK: COUNT
  /// Returns the total number of contacts in the data source.
  Future<int> getContactsCount() async {
    try {
      // Delegates the call to the active data source's count method.
      return await _source.count();
    } catch (e) {
      logger.e("Error getting contact count from repository: $e");
      // Return 0 or rethrow, depending on how you want to handle errors.
      return 0;
    }
  }
}

// MARK: CACHE
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
