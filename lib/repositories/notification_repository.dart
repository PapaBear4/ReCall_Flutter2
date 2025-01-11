// lib/repositories/notification_repository.dart
import 'package:recall/models/notification.dart';
import 'package:logger/logger.dart';
import 'package:objectbox/objectbox.dart';
import 'package:recall/sources/notification_ob_source.dart';
import 'package:recall/sources/notification_sp_source.dart';
import 'package:recall/sources/data_source.dart';
import 'repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

var notificationRepoLogger = Logger();

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
        notificationRepoLogger.i("Error opening ObjectBox store: $e");
        _source = _createInMemorySource();
      }
    } else {
      _source = _createInMemorySource();
      try {
        _source = NotificationSharedPreferencesSource();
      } catch (e) {
        notificationRepoLogger.i("Error opening shared preferences: $e");
      }
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
      notificationRepoLogger.i("Error getting all notifications: $e");
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
      notificationRepoLogger.i("Error getting notification by id: $e");
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
      notificationRepoLogger.i("Error adding notification: $e");
      return item;
    }
  }

  @override
  Future<Notification> update(Notification item) async {
    try {
      final notification = await _source.update(item);
      if (item.id != null) {
        _notifications[item.id!] = item;
      }
      return notification;
    } catch (e) {
      notificationRepoLogger.i("Error updating notification: $e");
      return item;
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      await _source.delete(id);
      _notifications.remove(id);
    } catch (e) {
      notificationRepoLogger.i("Error deleting notification: $e");
    }
  }
}

class _InMemoryNotificationSource implements DataSource<Notification> {
  final Map<int, Notification> notifications;

  _InMemoryNotificationSource({required this.notifications});

  @override
  Future<Notification> add(Notification item) async {
    final id = notifications.keys.length + 1;
    final newItem = item.copyWith(id: id);
    notifications[id] = newItem;
    return newItem;
  }

  @override
  Future<List<Notification>> addMany(List<Notification> items) async {
    final updatedItems = <Notification>[];
    for (final item in items) {
      final id = notifications.keys.length + 1;
      final newItem = item.copyWith(id: id);
      notifications[id] = newItem;
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
    notifications[item.id!] = item;
    return item;
  }
}
