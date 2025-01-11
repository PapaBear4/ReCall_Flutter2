// lib/sources/contact_sp_source.dart
import 'package:recall/models/contact.dart';
import 'package:recall/sources/data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class ContactsSharedPreferencesSource implements DataSource<Contact> {
  final String _key = 'contacts';

  @override
  Future<Contact> add(Contact item) async {
    final prefs = await SharedPreferences.getInstance();
    final contacts = await getAll();
    int nextId = 1;
    if (contacts.isNotEmpty) {
      nextId = contacts.map((e) => e.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
    }
    final newItem = item.copyWith(id: nextId);
    contacts.add(newItem);
    final encoded = contacts.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, encoded);
    return newItem;
  }

  @override
  Future<List<Contact>> addMany(List<Contact> items) async {
    final prefs = await SharedPreferences.getInstance();
    final contacts = await getAll();
    int nextId = 1;
    if (contacts.isNotEmpty) {
      nextId = contacts.map((e) => e.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
    }
    final updatedItems = <Contact>[];
    for(final item in items){
      final newItem = item.copyWith(id: nextId++);
      contacts.add(newItem);
      updatedItems.add(newItem);
    }
     final encoded = contacts.map((e) => jsonEncode(e.toJson())).toList();
     await prefs.setStringList(_key, encoded);
    return updatedItems;
  }


  @override
  Future<void> delete(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final contacts = await getAll();
    contacts.removeWhere((element) => element.id == id);
     final encoded = contacts.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, encoded);
  }

  @override
  Future<void> deleteMany(List<int> ids) async {
     final prefs = await SharedPreferences.getInstance();
    final contacts = await getAll();
    contacts.removeWhere((element) => ids.contains(element.id));
    final encoded = contacts.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, encoded);
  }

  @override
  Future<int> count() async {
    final contacts = await getAll();
    return contacts.length;
  }

  @override
  Future<List<Contact>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getStringList(_key) ?? [];
    return encoded.map((e) => Contact.fromJson(jsonDecode(e))).toList();
  }

  @override
  Future<Contact?> getById(int id) async {
    final contacts = await getAll();
    try {
      return contacts.firstWhere((element) => element.id == id);
    } catch (e) {
      return null;
    }
  }


  @override
  Future<Contact> update(Contact item) async {
    final prefs = await SharedPreferences.getInstance();
    final contacts = await getAll();
    final index = contacts.indexWhere((element) => element.id == item.id);
    if (index != -1) {
      contacts[index] = item;
    }
     final encoded = contacts.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, encoded);
    return item;
  }
}
