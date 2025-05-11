// lib/repositories/notification_repository.dart
import 'package:recall/models/notification.dart';
import 'package:recall/utils/logger.dart'; // Adjust path if needed
import 'package:objectbox/objectbox.dart';
import 'package:recall/sources/notification_ob_source.dart';
import 'package:recall/sources/data_source.dart';
import 'repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class NotificationRepository implements Repository<Notification> {
  late final Store? _store;
  late final Box<Notification>? _notificationBox;
  late DataSource<Notification> _source;
  final Map<int, Notification> _notifications = {};

  NotificationRepository(this._store) {
    if (!kIsWeb) {
      try {
        _notificationBox = _store!.box<Notification>();
        _source = NotificationObjectBoxSource(_notificationBox!);
      } catch (e) {
        logger.i("Error opening ObjectBox store: $e");
        _source = _createInMemorySource();
      }
    } else {
      _source = _createInMemorySource();
    }
  }

  DataSource<Notification> _createInMemorySource() {
    return _InMemoryNotificationSource(notifications: _notifications);
  }

  @override
  Future<List<Notification>> getAll() async {
    try {
      final notifications = await _source.getAll();
      _notifications.clear();
      for (final notification in notifications) {
        if (notification.id != null) {
          _notifications[notification.id!] = notification;
        }
      }
      return notifications;
    } catch (e) {
      logger.i("Error getting all notifications: $e");
      return _notifications.values.toList();
    }
  }

  @override
  Future<Notification?> getById(int id) async {
    if (_notifications.containsKey(id)) {
      return _notifications[id];
    }
    try {
      return await _source.getById(id);
    } catch (e) {
      logger.i("Error getting notification by id: $e");
      return null;
    }
  }

  @override
  Future<Notification> add(Notification item) async {
    try {
      final notification = await _source.add(item);
      if (item.id != null) {
        _notifications[item.id!] = item;
      }
      return notification;
    } catch (e) {
      logger.i("Error adding notification: $e");
      return item;
    }
  }

  @override
  Future<Notification> update(Notification item) async {
    try {
      final notification = await _source.add(item);
      if (item.id != null) {
        _notifications[item.id!] = item;
      }
      return notification;
    } catch (e) {
      logger.i("Error updating notification: $e");
      return item;
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      await _source.delete(id);
      _notifications.remove(id);
    } catch (e) {
      logger.i("Error deleting notification: $e");
    }
  }

  @override
  Future<List<Notification>> addMany(List<Notification> items) async {
    try {
      final addedItems = await _source.addMany(items);
      // Update cache with items returned from source (which have IDs)
      for (final item in addedItems) {
        if (item.id != null) {
          _notifications[item.id!] = item;
        }
      }
      return addedItems;
    } catch (e) {
      logger.i("Error adding many notifications: $e");
      return []; // Or handle error appropriately
    }
  }

  @override
  Future<void> deleteAll() async {
    try {
      await _source.deleteAll();
      _notifications.clear(); // Clear cache
    } catch (e) {
      logger.i("Error deleting all notifications: $e");
    }
  }

}

class _InMemoryNotificationSource implements DataSource<Notification> {
  final Map<int, Notification> notifications;
  int _nextId = 1; // Add ID tracking

   _InMemoryNotificationSource({required this.notifications}) {
     // Initialize _nextId based on existing items if any
     if (notifications.isNotEmpty) {
       _nextId = notifications.keys.reduce((a, b) => a > b ? a : b) + 1;
     }
   }

  @override
  Future<Notification> add(Notification item) async {
    final newItem = item.copyWith(id: _nextId++);
    notifications[newItem.id!] = newItem;
    return newItem;
  }

  @override
  Future<List<Notification>> addMany(List<Notification> items) async {
    final updatedItems = <Notification>[];
    for (final item in items) {
      final newItem = item.copyWith(id: _nextId++);
      notifications[newItem.id!] = newItem;
      updatedItems.add(newItem);
    }
    return updatedItems;
  }

  @override
  Future<void> delete(int id) async {
    notifications.remove(id);
  }

  @override
  Future<void> deleteMany(List<int> ids) async {
    for (final id in ids) {
      notifications.remove(id);
    }
  }

  @override
  Future<int> count() async {
    return notifications.length;
  }

  @override
  Future<List<Notification>> getAll() async {
    return notifications.values.toList();
  }

  @override
  Future<Notification?> getById(int id) async {
    return notifications[id];
  }

  @override
  Future<Notification> update(Notification item) async {
    if (item.id == null) return item;
    if (notifications.containsKey(item.id)) {
        notifications[item.id!] = item;
    }
    return item;
  }

  @override
  Future<void> deleteAll() async {
    notifications.clear();
    _nextId = 1; // Reset ID counter
  }
}