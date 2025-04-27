// lib/repositories/notification_repository.dart
import 'dart:async';
import 'package:recall/models/notification.dart';
import 'package:recall/utils/logger.dart';
import 'package:recall/sources/notification_ob_source.dart';
import 'package:recall/sources/data_source.dart';
import 'data_repository.dart';

/// Repository for accessing and managing notification data
class NotificationRepository implements Repository<Notification> {
  final DataSource<Notification> _source;
  
  /// Creates a new notification repository with the specified data source
  ///
  /// Uses dependency injection to get the data source
  NotificationRepository(this._source);

  // MARK: - Basic CRUD Operations

  /// Retrieves all notifications
  @override
  Future<List<Notification>> getAll() async {
    try {
      return await _source.getAll();
    } catch (e) {
      logger.e("Error getting all notifications: $e");
      rethrow; // Propagate error to caller for handling
    }
  }

  /// Gets a notification by ID
  @override
  Future<Notification?> getById(int id) async {
    try {
      return await _source.getById(id);
    } catch (e) {
      logger.e("Error getting notification by id: $e");
      rethrow;
    }
  }

  /// Adds a new notification to the data source
  @override
  Future<Notification> add(Notification item) async {
    try {
      return await _source.add(item);
    } catch (e) {
      logger.e("Error adding notification: $e");
      rethrow;
    }
  }

  /// Updates an existing notification
  @override
  Future<Notification> update(Notification item) async {
    try {
      return await _source.update(item);
    } catch (e) {
      logger.e("Error updating notification: $e");
      rethrow;
    }
  }

  /// Updates multiple notifications at once
  @override
  Future<List<Notification>> updateMany(List<Notification> items) async {
    try {
      return await _source.updateMany(items);
    } catch (e) {
      logger.e("Error updating many notifications: $e");
      rethrow;
    }
  }

  /// Deletes a notification by ID
  @override
  Future<void> delete(int id) async {
    try {
      await _source.delete(id);
    } catch (e) {
      logger.e("Error deleting notification: $e");
      rethrow;
    }
  }

  /// Deletes multiple notifications by their IDs
  @override
  Future<void> deleteMany(List<int> ids) async {
    try {
      await _source.deleteMany(ids);
    } catch (e) {
      logger.e("Error deleting multiple notifications: $e");
      rethrow;
    }
  }

  /// Adds multiple notifications at once
  @override
  Future<List<Notification>> addMany(List<Notification> items) async {
    try {
      return await _source.addMany(items);
    } catch (e) {
      logger.e("Error adding many notifications: $e");
      rethrow;
    }
  }

  /// Deletes all notifications
  @override
  Future<void> deleteAll() async {
    try {
      await _source.deleteAll();
    } catch (e) {
      logger.e("Error deleting all notifications: $e");
      rethrow;
    }
  }

  /// Gets the count of notifications
  @override
  Future<int> count() async {
    try {
      return await _source.count();
    } catch (e) {
      logger.e("Error counting notifications: $e");
      rethrow;
    }
  }

  /// Gets all notifications associated with a specific contact
  Future<List<Notification>> getByContactId(int contactId) async {
    try {
      // This method needs to be implemented in your data source
      // Or you can implement it here by fetching all and filtering
      final allNotifications = await _source.getAll();
      return allNotifications.where((notification) => 
        notification.id == contactId).toList();
    } catch (e) {
      logger.e("Error getting notifications by contact ID: $e");
      rethrow;
    }
  }

  // MARK: - Stream Access Methods
  
  /// Returns a filtered stream of notifications based on query name
  @override
  Stream<List<Notification>> getAllStream() {
    return _source.getAllStream();
  }
  
  /// Returns a count stream based on query name
  @override
  Stream<int> getCountStream(String queryName) {
    return _source.getCountStream(queryName);
  }
  
  /// Returns a stream with the count of active notifications
  Stream<int> getNotificationCount() {
    return _source.getCountStream(NotificationQueryNames.active);
  }
  
  // MARK: - Resource Management
  
  /// Releases resources used by this repository
  void dispose() {
    _source.dispose();
  }
}