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
  Future<void> add(UserSettings item) async {
    try {
      await _source.add(item);
      if (item.id != null) {
        _userSettings[item.id!] = item;
      }
    } catch (e) {
      userSettingsRepoLogger.i("Error adding user settings: $e");
    }
  }

  @override
  Future<void> update(UserSettings item) async {
    try {
      await _source.update(item);
      if (item.id != null) {
        _userSettings[item.id!] = item;
      }
    } catch (e) {
      userSettingsRepoLogger.i("Error updating user settings: $e");
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
  Future<List<UserSettings>> getAll() async {
    return userSettings.values.toList();
  }

  @override
  Future<UserSettings?> getById(int id) async {
    return userSettings[id];
  }

  @override
  Future<void> add(UserSettings item) async {
    final id = userSettings.keys.length + 1;
    userSettings[id] = item.copyWith(id: id);
  }

  @override
  Future<void> update(UserSettings item) async {
    if (item.id == null) return;
    userSettings[item.id!] = item;
  }

  @override
  Future<void> delete(int id) async {
    userSettings.remove(id);
  }
}
