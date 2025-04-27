import 'dart:async';
import 'package:recall/models/usersettings.dart';
import 'package:recall/utils/logger.dart';
import 'package:recall/sources/usersettings_ob_source.dart';
import 'package:recall/sources/data_source.dart';
import 'data_repository.dart';

/// Repository for accessing and managing user settings data
/// 
/// This class provides a clean API for the rest of the application to interact
/// with user settings data, delegating the actual storage operations to the
/// ObjectBox data source.
class UserSettingsRepository implements Repository<UserSettings> {
  final DataSource<UserSettings> _source;
  
  /// Creates a new user settings repository with the specified data source
  ///
  /// Uses dependency injection to get the data source
  UserSettingsRepository(this._source);

  // MARK: - Basic CRUD Operations

  /// Retrieves all user settings
  @override
  Future<List<UserSettings>> getAll() async {
    try {
      return await _source.getAll();
    } catch (e) {
      logger.e("Error getting all user settings: $e");
      rethrow;
    }
  }

  /// Gets a user settings object by ID
  @override
  Future<UserSettings?> getById(int id) async {
    try {
      return await _source.getById(id);
    } catch (e) {
      logger.e("Error getting user settings by id: $e");
      rethrow;
    }
  }

  /// Adds a new user settings object to the data source
  @override
  Future<UserSettings> add(UserSettings item) async {
    try {
      return await _source.add(item);
    } catch (e) {
      logger.e("Error adding user settings: $e");
      rethrow;
    }
  }

  /// Updates an existing user settings object
  @override
  Future<UserSettings> update(UserSettings item) async {
    try {
      return await _source.update(item);
    } catch (e) {
      logger.e("Error updating user settings: $e");
      rethrow;
    }
  }

  /// Updates multiple user settings objects at once
  @override
  Future<List<UserSettings>> updateMany(List<UserSettings> items) async {
    try {
      return await _source.updateMany(items);
    } catch (e) {
      logger.e("Error updating many user settings: $e");
      rethrow;
    }
  }

  /// Deletes a user settings object by ID
  @override
  Future<void> delete(int id) async {
    try {
      await _source.delete(id);
    } catch (e) {
      logger.e("Error deleting user settings: $e");
      rethrow;
    }
  }

  /// Deletes multiple user settings objects by their IDs
  @override
  Future<void> deleteMany(List<int> ids) async {
    try {
      await _source.deleteMany(ids);
    } catch (e) {
      logger.e("Error deleting multiple user settings: $e");
      rethrow;
    }
  }

  /// Adds multiple user settings objects at once
  @override
  Future<List<UserSettings>> addMany(List<UserSettings> items) async {
    try {
      return await _source.addMany(items);
    } catch (e) {
      logger.e("Error adding many user settings: $e");
      rethrow;
    }
  }

  /// Deletes all user settings
  @override
  Future<void> deleteAll() async {
    try {
      await _source.deleteAll();
    } catch (e) {
      logger.e("Error deleting all user settings: $e");
      rethrow;
    }
  }

  /// Gets the count of user settings objects
  @override
  Future<int> count() async {
    try {
      return await _source.count();
    } catch (e) {
      logger.e("Error counting user settings: $e");
      rethrow;
    }
  }

  // MARK: - Stream Methods
  
  /// Returns a filtered stream of user settings based on query name
  @override
  Stream<List<UserSettings>> getAllStream() {
    return _source.getAllStream();
  }
  
  /// Returns a count stream based on query name
  @override
  Stream<int> getCountStream(String queryName) {
    return _source.getCountStream(queryName);
  }
    
  /// Returns a stream with the count of settings
  Stream<int> getSettingsCount() {
    return _source.getCountStream(UserSettingsQueryNames.all);
  }
  
  // MARK: - Convenience Methods
  
  /// Gets the first user settings object, creating one if none exists
  Future<UserSettings> getFirstOrCreate() async {
    final settings = await getAll();
    if (settings.isNotEmpty) {
      return settings.first;
    }
    
    // Create default settings if none exist
    final newSettings = UserSettings();
    return add(newSettings);
  }
  
  // MARK: - Resource Management
  
  /// Releases resources used by this repository
  void dispose() {
    _source.dispose();
  }
}
