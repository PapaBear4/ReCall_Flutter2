// lib/sources/usersettings_sp_source.dart
import 'package:recall/models/usersettings.dart';
import 'package:recall/sources/data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserSettingsSharedPreferencesSource implements DataSource<UserSettings> {
  final String _key = 'userSettings';

  @override
  Future<UserSettings> add(UserSettings item) async {
    final prefs = await SharedPreferences.getInstance();
    final settings = await getAll();
      int nextId = 1;
    if (settings.isNotEmpty) {
      nextId = settings.map((e) => e.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
    }
    final newItem = item.copyWith(id: nextId);
     settings.add(newItem);
    final encoded = settings.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, encoded);
    return newItem;
  }

  @override
  Future<List<UserSettings>> addMany(List<UserSettings> items) async {
    final prefs = await SharedPreferences.getInstance();
    final settings = await getAll();
    int nextId = 1;
    if (settings.isNotEmpty) {
      nextId = settings.map((e) => e.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
    }
      final updatedItems = <UserSettings>[];
    for(final item in items){
      final newItem = item.copyWith(id: nextId++);
      settings.add(newItem);
      updatedItems.add(newItem);
    }
     final encoded = settings.map((e) => jsonEncode(e.toJson())).toList();
     await prefs.setStringList(_key, encoded);
    return updatedItems;
  }


  @override
  Future<void> delete(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final settings = await getAll();
     settings.removeWhere((element) => element.id == id);
    final encoded = settings.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, encoded);
  }

  @override
  Future<void> deleteMany(List<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    final settings = await getAll();
    settings.removeWhere((element) => ids.contains(element.id));
    final encoded = settings.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, encoded);
  }
    @override
  Future<int> count() async {
    final settings = await getAll();
    return settings.length;
  }


  @override
  Future<List<UserSettings>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getStringList(_key) ?? [];
    return encoded.map((e) => UserSettings.fromJson(jsonDecode(e))).toList();
  }

  @override
  Future<UserSettings?> getById(int id) async {
    final settings = await getAll();
    try {
      return settings.firstWhere((element) => element.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserSettings> update(UserSettings item) async {
    final prefs = await SharedPreferences.getInstance();
    final settings = await getAll();
    final index = settings.indexWhere((element) => element.id == item.id);
    if (index != -1) {
      settings[index] = item;
    }
    final encoded = settings.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, encoded);
    return item;
  }

  @override
  Future<void> deleteAll() async {
     final prefs = await SharedPreferences.getInstance();
     await prefs.setStringList(_key, []); // Add this implementation (clear the list)
  }
}
