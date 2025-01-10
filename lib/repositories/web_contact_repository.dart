// lib/repositories/web_contact_repository.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/contact.dart';
import 'repository.dart';

class WebContactRepository implements Repository<Contact> {
  static const String _contactsKey = 'contacts';
  final List<Contact> _inMemoryContacts = [];

  @override
  Future<List<Contact>> getAll() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final contactsJson = prefs.getStringList(_contactsKey) ?? [];
      _inMemoryContacts.clear();
      _inMemoryContacts.addAll(contactsJson.map((json) => Contact.fromJson(jsonDecode(json))));
      return _inMemoryContacts;
    } else {
      return _inMemoryContacts;
    }
  }

  @override
  Future<Contact?> getById(int id) async {
    if (kIsWeb) {
      await getAll();
      try {
        return _inMemoryContacts.firstWhere((element) => element.id == id);
      } catch (e) {
        return null;
      }
    } else {
      try {
        return _inMemoryContacts.firstWhere((element) => element.id == id);
      } catch (e) {
        return null;
      }
    }
  }

  @override
  Future<Contact> add(Contact item) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      int newId = _inMemoryContacts.isNotEmpty ? _inMemoryContacts.last.id! + 1 : 1;
      final newContact = item.copyWith(id: newId);
      _inMemoryContacts.add(newContact);
      _saveContactsToPrefs(prefs);
      return newContact;
    } else {
       int newId = _inMemoryContacts.isNotEmpty ? _inMemoryContacts.last.id! + 1 : 1;
      final newContact = item.copyWith(id: newId);
      _inMemoryContacts.add(newContact);
      return newContact;
    }
  }

  @override
  Future<void> update(Contact item) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final index = _inMemoryContacts.indexWhere((c) => c.id == item.id);
      if (index != -1) {
        _inMemoryContacts[index] = item;
        _saveContactsToPrefs(prefs);
      }
    } else {
      final index = _inMemoryContacts.indexWhere((c) => c.id == item.id);
      if (index != -1) {
        _inMemoryContacts[index] = item;
      }
    }
  }

  @override
  Future<void> delete(int id) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      _inMemoryContacts.removeWhere((c) => c.id == id);
      _saveContactsToPrefs(prefs);
    } else {
      _inMemoryContacts.removeWhere((c) => c.id == id);
    }
  }

  Future<void> _saveContactsToPrefs(SharedPreferences prefs) async {
    final contactsJson = _inMemoryContacts.map((contact) => jsonEncode(contact.toJson())).toList();
    await prefs.setStringList(_contactsKey, contactsJson);
  }
}