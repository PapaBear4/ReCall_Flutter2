// lib/repositories/user_settings_repository.dart
import 'package:recall/models/usersettings.dart';
import 'package:recall/utils/logger.dart'; // Adjust path if needed
import 'package:objectbox/objectbox.dart';
import 'package:recall/sources/usersettings_ob_source.dart';
import 'package:recall/sources/usersettings_sp_source.dart';
import 'package:recall/sources/data_source.dart';
import 'repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class UserSettingsRepository implements Repository<UserSettings> {
  late final Store? _store;
  late final Box<UserSettings>? _userSettingsBox;
  late DataSource<UserSettings> _source;
  // UserSettings typically only has one entry, but use Map for consistency
  final Map<int, UserSettings> _userSettings = {};

  UserSettingsRepository(this._store) {
    if (!kIsWeb) {
      try {
        _userSettingsBox = _store!.box<UserSettings>();
        _source = UserSettingsObjectBoxSource(_userSettingsBox!);
      } catch (e) {
        logger.i("Error opening ObjectBox store: $e");
        _source = _createInMemorySource();
      }
    } else {
      _source = _createInMemorySource();
      try {
        _source = UserSettingsSharedPreferencesSource();
      } catch (e) {
        logger.i("Error opening shared preferences: $e");
      }
    }
  }

  DataSource<UserSettings> _createInMemorySource() {
    return _InMemoryUserSettingsSource(userSettings: _userSettings);
  }

  @override
  Future<List<UserSettings>> getAll() async {
    try {
      final userSettings = await _source.getAll();
      _userSettings.clear();
      for (final setting in userSettings) {
        if (setting.id != null) {
          _userSettings[setting.id!] = setting;
        }
      }
      return userSettings;
    } catch (e) {
      logger.i("Error getting all user settings: $e");
      return _userSettings.values.toList();
    }
  }

  @override
  Future<UserSettings?> getById(int id) async {
    if (_userSettings.containsKey(id)) {
      return _userSettings[id];
    }
    try {
      return await _source.getById(id);
    } catch (e) {
      logger.i("Error getting user settings by id: $e");
      return null;
    }
  }

  @override
  Future<UserSettings> add(UserSettings item) async {
    try {
      final usersettings = await _source.add(item);
      if (item.id != null) {
        _userSettings[item.id!] = item;
      }
      return usersettings;
    } catch (e) {
      logger.i("Error adding user settings: $e");
      return item;
    }
  }

  @override
  Future<UserSettings> update(UserSettings item) async {
    try {
      final usersettings = await _source.update(item);
      if (item.id != null) {
        _userSettings[item.id!] = item;
      }
      return usersettings;
    } catch (e) {
      logger.i("Error updating user settings: $e");
      return item;
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      await _source.delete(id);
      _userSettings.remove(id);
    } catch (e) {
      logger.i("Error deleting user settings: $e");
    }
  }

  @override
  Future<List<UserSettings>> addMany(List<UserSettings> items) async {
     try {
      final addedItems = await _source.addMany(items);
      // Update cache with items returned from source (which have IDs)
      for (final item in addedItems) {
        if (item.id != null) {
          _userSettings[item.id!] = item;
        }
      }
      return addedItems;
    } catch (e) {
      logger.i("Error adding many user settings: $e");
      return []; // Or handle error appropriately
    }
  }

  @override
  Future<void> deleteAll() async {
     try {
      await _source.deleteAll();
      _userSettings.clear(); // Clear cache
    } catch (e) {
      logger.i("Error deleting all user settings: $e");
    }
  }
}

class _InMemoryUserSettingsSource implements DataSource<UserSettings> {
  final Map<int, UserSettings> userSettings;
  int _nextId = 1; // Add ID tracking

  _InMemoryUserSettingsSource({required this.userSettings}) {
     // Initialize _nextId based on existing items if any
     if (userSettings.isNotEmpty) {
       _nextId = userSettings.keys.reduce((a, b) => a > b ? a : b) + 1;
     }
  }

  @override
  Future<UserSettings> add(UserSettings item) async {
    final newItem = item.copyWith(id: _nextId++);
    userSettings[newItem.id!] = newItem;
    return newItem;
  }

  @override
  Future<List<UserSettings>> addMany(List<UserSettings> items) async {
    final updatedItems = <UserSettings>[];
    for (final item in items) {
      final newItem = item.copyWith(id: _nextId++);
      userSettings[newItem.id!] = newItem;
      updatedItems.add(newItem);
    }
    return updatedItems;
  }

  @override
  Future<void> delete(int id) async {
    userSettings.remove(id);
  }

  @override
  Future<void> deleteMany(List<int> ids) async {
    for (final id in ids) {
      userSettings.remove(id);
    }
  }

  @override
  Future<int> count() async {
    return userSettings.length;
  }

  @override
  Future<List<UserSettings>> getAll() async {
    return userSettings.values.toList();
  }

  @override
  Future<UserSettings?> getById(int id) async {
    return userSettings[id];
  }

  @override
  Future<UserSettings> update(UserSettings item) async {
    if (item.id == null) return item;
    userSettings[item.id!] = item;
    return item;
  }

  @override
  Future<void> deleteAll() async {
    userSettings.clear();
    _nextId = 1; // Reset ID counter
  }
}
