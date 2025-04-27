import 'dart:async';
import 'package:recall/models/notification.dart';
import 'package:recall/objectbox.g.dart';
import 'package:recall/sources/data_source.dart';

/// Standard query names for filtering notifications
class NotificationQueryNames {
  /// Returns notifications scheduled for future or with no schedule
  static const String active = 'active';

  /// Returns all notifications regardless of status
  static const String all = 'all';

  /// Returns notifications scheduled for today
  static const String today = 'today';
}

/// Implements the data source for Notification models using ObjectBox database
class NotificationObjectBoxSource implements DataSource<Notification> {
  final Box<Notification> _notificationBox;

  // MARK: - STREAMS

  /// Stream controllers for reactive data updates
  final _notificationsController =
      StreamController<List<Notification>>.broadcast();
  final _notificationCountController = StreamController<int>.broadcast();

  /// Creates a new notification data source with the specified ObjectBox box
  NotificationObjectBoxSource(this._notificationBox) {
    // Initialize streams with data on creation
    _refreshNotifications();
    _refreshNotificationCount();
  }

  // MARK: - PRI Stream

  /// Updates notifications stream with fresh data
  void _refreshNotifications() {
    final now = DateTime.now();
    final query = _notificationBox
        .query(Notification_.scheduledTime.isNull().or(Notification_
            .scheduledTime
            .greaterThan(now.millisecondsSinceEpoch)))
        .build();
    _notificationsController.add(query.find());
    query.close();
  }

  /// Updates the notification count stream with fresh count
  void _refreshNotificationCount() {
    final now = DateTime.now();
    final query = _notificationBox
        .query(Notification_.scheduledTime.isNull().or(Notification_
            .scheduledTime
            .greaterThan(now.millisecondsSinceEpoch)))
        .build();
    _notificationCountController.add(query.count());
    query.close();
  }

  /// Refreshes all streams with fresh data
  void _refreshAllStreams() {
    _refreshNotifications();
    _refreshNotificationCount();
  }

  // MARK: - PUB Stream

  /// Returns a stream that emits all notifications
  @override
  Stream<List<Notification>> getAllStream() {
    // Since we want truly all notifications without filtering,
    // we'll return a simple stream with all notifications from the box
    return Stream.value(_notificationBox.getAll());
  }

  /// Returns a stream that emits a count based on the provided query name
  @override
  Stream<int> getCountStream(String queryName) {
    switch (queryName) {
      case NotificationQueryNames.active:
        _refreshNotificationCount();
        return _notificationCountController.stream;
      default:
        return Stream.value(0);
    }
  }

  /// Returns a stream of active notifications
  Stream<List<Notification>> getNotifications() {
    _refreshNotifications();
    return _notificationsController.stream;
  }

  /// Returns a stream of the active notifications count
  Stream<int> getNotificationCount() {
    _refreshNotificationCount();
    return _notificationCountController.stream;
  }

  // MARK: - CRUD Operations

  /// Adds a new notification to the database
  @override
  Future<Notification> add(Notification item) async {
    final id = _notificationBox.put(item);
    _refreshAllStreams();
    return item.copyWith(id: id);
  }

  /// Adds multiple notifications at once
  @override
  Future<List<Notification>> addMany(List<Notification> items) async {
    if (items.isEmpty) return [];

    final ids = _notificationBox.putMany(items);

    final updatedItems = <Notification>[];
    for (int i = 0; i < items.length; i++) {
      updatedItems.add(items[i].copyWith(id: ids[i]));
    }

    _refreshAllStreams();
    return updatedItems;
  }

  /// Updates multiple notifications at once
  @override
  Future<List<Notification>> updateMany(List<Notification> items) async {
    if (items.isEmpty) return [];

    final ids = _notificationBox.putMany(items);

    final updatedItems = <Notification>[];
    for (int i = 0; i < items.length; i++) {
      updatedItems.add(items[i].copyWith(id: ids[i]));
    }

    _refreshAllStreams();
    return updatedItems;
  }

  /// Deletes a notification by ID
  @override
  Future<void> delete(int id) async {
    _notificationBox.remove(id);
    _refreshAllStreams();
  }

  /// Deletes multiple notifications by their IDs
  @override
  Future<void> deleteMany(List<int> ids) async {
    if (ids.isEmpty) return;
    _notificationBox.removeMany(ids);
    _refreshAllStreams();
  }

  /// Gets the total count of notifications
  @override
  Future<int> count() async {
    return _notificationBox.count();
  }

  /// Gets all notifications
  @override
  Future<List<Notification>> getAll() async {
    return _notificationBox.getAll();
  }

  /// Gets a single notification by ID
  @override
  Future<Notification?> getById(int id) async {
    return _notificationBox.get(id);
  }

  /// Updates an existing notification
  @override
  Future<Notification> update(Notification item) async {
    final id = _notificationBox.put(item);
    _refreshAllStreams();
    return item.copyWith(id: id);
  }

  /// Deletes all notifications
  @override
  Future<void> deleteAll() async {
    _notificationBox.removeAll();
    _refreshAllStreams();
  }

  /// Gets all notifications for a specific contact ID
  Future<List<Notification>> getByContactId(int contactId) async {
    final query =
        _notificationBox.query(Notification_.id.equals(contactId)).build();

    final result = query.find();
    query.close();
    return result;
  }

  // MARK: - Resource Management

  /// Cleans up resources when the source is no longer needed
  @override
  void dispose() {
    _notificationsController.close();
    _notificationCountController.close();
  }
}
