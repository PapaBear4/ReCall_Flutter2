// lib/repositories/contact_repository.dart
import 'package:recall/models/contact.dart'; // Import the Contact model
import 'package:logger/logger.dart';
import 'package:objectbox/objectbox.dart';
import 'package:recall/sources/contact_ob_source.dart';
import 'package:recall/sources/contact_sp_source.dart';
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
  ContactRepository(this._store) {
    if (!kIsWeb) {
      try {
        _contactBox = _store!.box<Contact>();

        _source = ContactObjectBoxSource(_contactBox!);
      } catch (e) {
        contactRepoLogger.i("Error opening ObjectBox store: $e");
        _source = _createInMemorySource();
      }
    } else {
      _source = _createInMemorySource();
      try {
        _source = ContactsSharedPreferencesSource();
      } catch (e) {
        contactRepoLogger.i("Error opening shared preferences: $e");

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
      return _contacts[id];
    }
    return _source.getById(id);
  }

  @override
  Future<Contact> add(Contact item) async {

    final contact = await _source.add(item);
    if (item.id != null) {
      _contacts[item.id!] = item;

    }
    return contact;
  }

  @override
  Future<Contact> update(Contact item) async {
    final contact =await _source.update(item);
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
}

class _InMemoryContactSource implements DataSource<Contact> {
  final Map<int, Contact> contacts;

  _InMemoryContactSource({required this.contacts});

  @override
  Future<Contact> add(Contact item) async {
    final id = contacts.keys.length + 1;
    final newItem = item.copyWith(id: id);
    contacts[id] = newItem;
    return newItem;
  }

  @override
  Future<List<Contact>> addMany(List<Contact> items) async {
    final updatedItems = <Contact>[];
    for (final item in items) {
      final id = contacts.keys.length + 1;
      final newItem = item.copyWith(id: id);
      contacts[id] = newItem;
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
}
