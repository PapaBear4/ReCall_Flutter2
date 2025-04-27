import 'dart:async';
import 'package:recall/models/usersettings.dart';
import 'package:objectbox/objectbox.dart';
import 'package:recall/sources/data_source.dart';

/// Standard query names for filtering user settings
/// 
/// These constants provide a standardized way to refer to common
/// query types throughout the application.
class UserSettingsQueryNames {
  /// Returns all user settings
  static const String all = 'all';
  
  // Add more query names as needed
}

/// Implements the data source for UserSettings using ObjectBox database
///
/// This class provides CRUD operations and reactive streams for user settings data,
/// allowing the application to efficiently access and monitor changes to settings.
class UserSettingsObjectBoxSource implements DataSource<UserSettings> {
  final Box<UserSettings> _userSettingsBox;
  
  // MARK: - STREAMS
  
  /// Stream controller for settings data
  ///
  /// This controller emits new lists of settings whenever the underlying data changes.
  final _settingsController = StreamController<List<UserSettings>>.broadcast();
  
  /// Stream controller for settings count
  ///
  /// This controller emits updated counts whenever the underlying data changes.
  final _countController = StreamController<int>.broadcast();

  /// Creates a new user settings data source with the specified ObjectBox box
  ///
  /// Initializes the essential streams and prepares them with initial data.
  UserSettingsObjectBoxSource(this._userSettingsBox) {
    // Initialize streams with data on creation
    _refreshSettings();
    _refreshCount();
  }
  
  // MARK: - PRI Stream
  
  /// Updates the settings stream with all settings
  void _refreshSettings() {
    _settingsController.add(_userSettingsBox.getAll());
  }
  
  /// Updates the count stream
  void _refreshCount() {
    _countController.add(_userSettingsBox.count());
  }
  
  /// Refreshes all streams with fresh data
  void _refreshAllStreams() {
    _refreshSettings();
    _refreshCount();
  }

  // MARK: - PUB Stream
  
/// Returns a stream that emits all settings
@override
Stream<List<UserSettings>> getAllStream() {
  // Refresh settings to ensure the stream has the latest data
  _refreshSettings();
  // Return the broadcast stream from our controller
  return _settingsController.stream;
}

  /// Returns a stream that emits a count based on the provided query name
  @override
  Stream<int> getCountStream(String queryName) {
    switch (queryName) {
      case UserSettingsQueryNames.all:
        _refreshCount();
        return _countController.stream;
      default:
        return Stream.value(0);
    }
  }

  /// Returns a stream of all settings
  Stream<List<UserSettings>> getSettings() {
    _refreshSettings();
    return _settingsController.stream;
  }

  /// Returns a stream with the count of settings
  Stream<int> getSettingsCount() {
    _refreshCount();
    return _countController.stream;
  }

  // MARK: - CRUD Operations
  
  /// Adds a new settings object to the database
  ///
  /// Lets ObjectBox assign an ID and saves the settings, then refreshes streams.
  @override
  Future<UserSettings> add(UserSettings item) async {
    final id = _userSettingsBox.put(item);
    _refreshAllStreams();
    return item.copyWith(id: id);
  }

  /// Adds multiple settings objects at once
  ///
  /// More efficient than calling add() multiple times, especially for bulk operations.
  @override
  Future<List<UserSettings>> addMany(List<UserSettings> items) async {
    if (items.isEmpty) return [];
    
    final ids = _userSettingsBox.putMany(items);
    
    final updatedItems = <UserSettings>[];
    for (int i = 0; i < items.length; i++) {
      updatedItems.add(items[i].copyWith(id: ids[i]));
    }
    
    _refreshAllStreams();
    return updatedItems;
  }

  /// Updates multiple settings objects at once
  ///
  /// Batch operation for efficient updating of multiple settings.
  @override
  Future<List<UserSettings>> updateMany(List<UserSettings> items) async {
    if (items.isEmpty) return [];
    
    final ids = _userSettingsBox.putMany(items);
    
    final updatedItems = <UserSettings>[];
    for (int i = 0; i < items.length; i++) {
      updatedItems.add(items[i].copyWith(id: ids[i]));
    }
    
    _refreshAllStreams();
    return updatedItems;
  }

  /// Deletes a settings object by ID
  ///
  /// Permanently removes the settings from the database.
  @override
  Future<void> delete(int id) async {
    _userSettingsBox.remove(id);
    _refreshAllStreams();
  }

  /// Deletes multiple settings objects by their IDs
  ///
  /// More efficient than calling delete() multiple times.
  @override
  Future<void> deleteMany(List<int> ids) async {
    if (ids.isEmpty) return;
    
    _userSettingsBox.removeMany(ids);
    _refreshAllStreams();
  }

  /// Gets the total count of settings objects
  @override
  Future<int> count() async {
    return _userSettingsBox.count();
  }

  /// Gets all settings objects
  @override
  Future<List<UserSettings>> getAll() async {
    return _userSettingsBox.getAll();
  }

  /// Gets a single settings object by ID
  @override
  Future<UserSettings?> getById(int id) async {
    return _userSettingsBox.get(id);
  }

  /// Updates an existing settings object
  @override
  Future<UserSettings> update(UserSettings item) async {
    final id = _userSettingsBox.put(item);
    _refreshAllStreams();
    return item.copyWith(id: id);
  }

  /// Deletes all settings objects
  ///
  /// This is a destructive operation that completely clears the settings table.
  @override
  Future<void> deleteAll() async {
    _userSettingsBox.removeAll();
    _refreshAllStreams();
  }
  
  // MARK: - Resource Management
  
  /// Cleans up resources when the source is no longer needed
  ///
  /// Closes all stream controllers to prevent memory leaks.
  @override
  void dispose() {
    _settingsController.close();
    _countController.close();
  }
}
