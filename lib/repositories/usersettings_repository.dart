// lib/repositories/user_settings_repository.dart
import 'package:recall/models/usersettings.dart';
import 'package:logger/logger.dart';
import 'package:objectbox/objectbox.dart';
import 'package:recall/sources/usersettings_ob_source.dart';
import 'package:recall/sources/usersettings_sp_source.dart';
import 'package:recall/sources/data_source.dart';
import 'repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

var userSettingsRepoLogger = Logger();

class UserSettingsRepository implements Repository<UserSettings> {
  late final Store? _store;
  late final Box<UserSettings>? _userSettingsBox;
  late DataSource<UserSettings> _source;
  final Map<int, UserSettings> _userSettings = {};

  UserSettingsRepository(this._store) {
    if (!kIsWeb) {
      try {
        _userSettingsBox = _store!.box<UserSettings>();
        _source = UserSettingsObjectBoxSource(_userSettingsBox!);
      } catch (e) {
        userSettingsRepoLogger.i("Error opening ObjectBox store: $e");
        _source = _createInMemorySource();
      }
    } else {
      _source = _createInMemorySource();
      try {
        _source = UserSettingsSharedPreferencesSource();
      } catch (e) {
        userSettingsRepoLogger.i("Error opening shared preferences: $e");
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
      userSettingsRepoLogger.i("Error getting all user settings: $e");
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
      userSettingsRepoLogger.i("Error getting user settings by id: $e");
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
      userSettingsRepoLogger.i("Error adding user settings: $e");
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
      userSettingsRepoLogger.i("Error updating user settings: $e");
      return item;
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      await _source.delete(id);
      _userSettings.remove(id);
    } catch (e) {
      userSettingsRepoLogger.i("Error deleting user settings: $e");
    }
  }
}

class _InMemoryUserSettingsSource implements DataSource<UserSettings> {
  final Map<int, UserSettings> userSettings;

  _InMemoryUserSettingsSource({required this.userSettings});

  @override
  Future<UserSettings> add(UserSettings item) async {
    final id = userSettings.keys.length + 1;
    final newItem = item.copyWith(id: id);
    userSettings[id] = newItem;
    return newItem;
  }

  @override
  Future<List<UserSettings>> addMany(List<UserSettings> items) async {
    final updatedItems = <UserSettings>[];
    for (final item in items) {
      final id = userSettings.keys.length + 1;
      final newItem = item.copyWith(id: id);
      userSettings[id] = newItem;
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
}
