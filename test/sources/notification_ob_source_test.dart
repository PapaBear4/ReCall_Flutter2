import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recall/models/notification.dart' as recall_notification; // Alias needed
import 'package:recall/objectbox.g.dart'; // For Box, Query, Notification_
import 'package:recall/sources/notification_ob_source.dart';

// Import the generated mocks
import 'notification_ob_source_test.mocks.dart';

// --- Explicit Mock Class Definitions ---
class MockBoxNotification extends Mock implements Box<recall_notification.Notification> {}
class MockQueryNotification extends Mock implements Query<recall_notification.Notification> {}

// Annotation to generate implementations for the mocks above
@GenerateNiceMocks([
  MockSpec<Box<recall_notification.Notification>>(as: #MockBoxNotification),
  MockSpec<Query<recall_notification.Notification>>(as: #MockQueryNotification),
])
void main() {
  // Use the explicitly defined mock types
  late MockBoxNotification mockBox;
  late MockQueryNotification mockQuery; // For the standard refresh query
  late MockQueryNotification mockIdQuery; // For getByContactId
  late NotificationObjectBoxSource dataSource;

  // Helper function to create dummy notification
  recall_notification.Notification createNotification(int id, {DateTime? scheduledTime}) =>
      recall_notification.Notification(
        id: id,
        title: 'Title $id',
        body: 'Body $id',
        scheduledTime: scheduledTime,
      );

  setUp(() {
    // Create mocks using the explicitly defined classes
    mockBox = MockBoxNotification();
    mockQuery = MockQueryNotification();
    mockIdQuery = MockQueryNotification();

    // --- Adjusted Stubbing ---
    // Stub the result of box.query(any).build() for the refresh methods
    final mockRefreshQueryBuilder = MockQueryBuilder<recall_notification.Notification>();
    when(mockBox.query(any)).thenReturn(mockRefreshQueryBuilder); // Assume refresh uses a query
    when(mockRefreshQueryBuilder.build()).thenReturn(mockQuery);

    // Stub the result for getByContactId's specific query
    final mockIdQueryBuilder = MockQueryBuilder<recall_notification.Notification>();
    when(mockBox.query(argThat(isA<Condition<recall_notification.Notification>>()
            .having((c) => c.toString(), 'toString', contains('Notification_.id.equals')))))
        .thenReturn(mockIdQueryBuilder);
    when(mockIdQueryBuilder.build()).thenReturn(mockIdQuery);

    // Stub methods on the mock queries
    when(mockQuery.find()).thenReturn([]); // Initial find for _refreshNotifications
    when(mockQuery.count()).thenReturn(0); // Initial count for _refreshNotificationCount
    when(mockQuery.close()).thenReturn(null); // Stub close for refresh query

    when(mockIdQuery.find()).thenReturn([]); // Default find for ID query
    when(mockIdQuery.close()).thenReturn(null); // Stub close for ID query

    dataSource = NotificationObjectBoxSource(mockBox);

    // Clear interactions from constructor
    clearInteractions(mockBox);
    clearInteractions(mockRefreshQueryBuilder);
    clearInteractions(mockIdQueryBuilder);
    clearInteractions(mockQuery);
    clearInteractions(mockIdQuery);

    // Re-apply stubs needed after constructor
    when(mockBox.query(any)).thenReturn(mockRefreshQueryBuilder);
    when(mockRefreshQueryBuilder.build()).thenReturn(mockQuery);
    when(mockBox.query(argThat(isA<Condition<recall_notification.Notification>>()
            .having((c) => c.toString(), 'toString', contains('Notification_.id.equals')))))
        .thenReturn(mockIdQueryBuilder);
    when(mockIdQueryBuilder.build()).thenReturn(mockIdQuery);
    when(mockQuery.find()).thenReturn([]);
    when(mockQuery.count()).thenReturn(0);
    when(mockQuery.close()).thenReturn(null);
    when(mockIdQuery.find()).thenReturn([]);
    when(mockIdQuery.close()).thenReturn(null);
  });

  tearDown(() {
    dataSource.dispose();
  });

  group('NotificationObjectBoxSource Tests', () {
    test('Constructor initializes streams via refresh methods', () {
      final mockRefreshQueryBuilder = MockQueryBuilder<recall_notification.Notification>();
      when(mockBox.query(any)).thenReturn(mockRefreshQueryBuilder);
      when(mockRefreshQueryBuilder.build()).thenReturn(mockQuery);
      when(mockQuery.find()).thenReturn([]);
      when(mockQuery.count()).thenReturn(0);
      when(mockQuery.close()).thenReturn(null);

      dataSource = NotificationObjectBoxSource(mockBox);

      verify(mockBox.query(any)).called(2);
      verify(mockRefreshQueryBuilder.build()).called(2);
      verify(mockQuery.find()).called(1);
      verify(mockQuery.count()).called(1);
      verify(mockQuery.close()).called(2);
    });

    test('add() puts item, refreshes streams, returns with ID', () async {
      final notification = createNotification(0);
      final notificationWithId = createNotification(1);
      when(mockBox.put(notification)).thenReturn(1);
      when(mockQuery.find()).thenReturn([notificationWithId]);
      when(mockQuery.count()).thenReturn(1);

      final addedNotification = await dataSource.add(notification);

      verify(mockBox.put(notification)).called(1);
      expect(addedNotification.id, 1);
      final mockRefreshQueryBuilder = MockQueryBuilder<recall_notification.Notification>();
      verify(mockBox.query(any)).called(2);
      verify(mockRefreshQueryBuilder.build()).called(2);
      verify(mockQuery.find()).called(1);
      verify(mockQuery.count()).called(1);
      verify(mockQuery.close()).called(2);
      expectLater(dataSource.getNotifications(), emits([notificationWithId]));
      expectLater(dataSource.getCountStream(NotificationQueryNames.active), emits(1));
    });

    test('addMany() puts items, refreshes streams, returns with IDs', () async {
      final notifications = [createNotification(0), createNotification(0)];
      final notificationsWithIds = [createNotification(1), createNotification(2)];
      when(mockBox.putMany(notifications)).thenReturn([1, 2]);
      when(mockQuery.find()).thenReturn(notificationsWithIds);
      when(mockQuery.count()).thenReturn(2);

      final addedNotifications = await dataSource.addMany(notifications);

      verify(mockBox.putMany(notifications)).called(1);
      expect(addedNotifications.length, 2);
      expect(addedNotifications[0].id, 1);
      expect(addedNotifications[1].id, 2);
      final mockRefreshQueryBuilder = MockQueryBuilder<recall_notification.Notification>();
      verify(mockBox.query(any)).called(2);
      verify(mockRefreshQueryBuilder.build()).called(2);
      verify(mockQuery.find()).called(1);
      verify(mockQuery.count()).called(1);
      verify(mockQuery.close()).called(2);
      expectLater(dataSource.getNotifications(), emits(notificationsWithIds));
      expectLater(dataSource.getCountStream(NotificationQueryNames.active), emits(2));
    });

    test('update() puts item, refreshes streams', () async {
      final notification = createNotification(1);
      when(mockBox.put(notification)).thenReturn(1);
      when(mockQuery.find()).thenReturn([notification]);
      when(mockQuery.count()).thenReturn(1);

      final updatedNotification = await dataSource.update(notification);

      verify(mockBox.put(notification)).called(1);
      expect(updatedNotification.id, 1);
      final mockRefreshQueryBuilder = MockQueryBuilder<recall_notification.Notification>();
      verify(mockBox.query(any)).called(2);
      verify(mockRefreshQueryBuilder.build()).called(2);
      verify(mockQuery.find()).called(1);
      verify(mockQuery.count()).called(1);
      verify(mockQuery.close()).called(2);
      expectLater(dataSource.getNotifications(), emits([notification]));
      expectLater(dataSource.getCountStream(NotificationQueryNames.active), emits(1));
    });

    test('updateMany() puts items, refreshes streams', () async {
      final notifications = [createNotification(1), createNotification(2)];
      when(mockBox.putMany(notifications)).thenReturn([1, 2]);
      when(mockQuery.find()).thenReturn(notifications);
      when(mockQuery.count()).thenReturn(2);

      final updatedNotifications = await dataSource.updateMany(notifications);

      verify(mockBox.putMany(notifications)).called(1);
      expect(updatedNotifications.length, 2);
      final mockRefreshQueryBuilder = MockQueryBuilder<recall_notification.Notification>();
      verify(mockBox.query(any)).called(2);
      verify(mockRefreshQueryBuilder.build()).called(2);
      verify(mockQuery.find()).called(1);
      verify(mockQuery.count()).called(1);
      verify(mockQuery.close()).called(2);
      expectLater(dataSource.getNotifications(), emits(notifications));
      expectLater(dataSource.getCountStream(NotificationQueryNames.active), emits(2));
    });

    test('delete() removes item, refreshes streams', () async {
      const id = 1;
      when(mockBox.remove(id)).thenReturn(true);
      when(mockQuery.find()).thenReturn([]);
      when(mockQuery.count()).thenReturn(0);

      await dataSource.delete(id);

      verify(mockBox.remove(id)).called(1);
      final mockRefreshQueryBuilder = MockQueryBuilder<recall_notification.Notification>();
      verify(mockBox.query(any)).called(2);
      verify(mockRefreshQueryBuilder.build()).called(2);
      verify(mockQuery.find()).called(1);
      verify(mockQuery.count()).called(1);
      verify(mockQuery.close()).called(2);
      expectLater(dataSource.getNotifications(), emits([]));
      expectLater(dataSource.getCountStream(NotificationQueryNames.active), emits(0));
    });

    test('deleteMany() removes items, refreshes streams', () async {
      final ids = [1, 2];
      when(mockBox.removeMany(ids)).thenReturn(2);
      when(mockQuery.find()).thenReturn([]);
      when(mockQuery.count()).thenReturn(0);

      await dataSource.deleteMany(ids);

      verify(mockBox.removeMany(ids)).called(1);
      final mockRefreshQueryBuilder = MockQueryBuilder<recall_notification.Notification>();
      verify(mockBox.query(any)).called(2);
      verify(mockRefreshQueryBuilder.build()).called(2);
      verify(mockQuery.find()).called(1);
      verify(mockQuery.count()).called(1);
      verify(mockQuery.close()).called(2);
      expectLater(dataSource.getNotifications(), emits([]));
      expectLater(dataSource.getCountStream(NotificationQueryNames.active), emits(0));
    });

    test('deleteAll() removes all items, refreshes streams', () async {
      when(mockBox.removeAll()).thenReturn(5);
      when(mockQuery.find()).thenReturn([]);
      when(mockQuery.count()).thenReturn(0);

      await dataSource.deleteAll();

      verify(mockBox.removeAll()).called(1);
      final mockRefreshQueryBuilder = MockQueryBuilder<recall_notification.Notification>();
      verify(mockBox.query(any)).called(2);
      verify(mockRefreshQueryBuilder.build()).called(2);
      verify(mockQuery.find()).called(1);
      verify(mockQuery.count()).called(1);
      verify(mockQuery.close()).called(2);
      expectLater(dataSource.getNotifications(), emits([]));
      expectLater(dataSource.getCountStream(NotificationQueryNames.active), emits(0));
    });

    test('getById() gets item from box', () async {
      const id = 1;
      final notification = createNotification(id);
      when(mockBox.get(id)).thenReturn(notification);

      final result = await dataSource.getById(id);

      verify(mockBox.get(id)).called(1);
      expect(result, notification);
    });

    test('getAll() gets all items from box', () async {
      final notifications = [createNotification(1), createNotification(2)];
      when(mockBox.getAll()).thenReturn(notifications);

      final result = await dataSource.getAll();

      verify(mockBox.getAll()).called(1);
      expect(result, notifications);
    });

    test('count() gets count from box', () async {
      when(mockBox.count()).thenReturn(10);

      final result = await dataSource.count();

      verify(mockBox.count()).called(1);
      expect(result, 10);
    });

    test('getAllStream() returns stream with all items from box', () {
      final notifications = [createNotification(1), createNotification(2)];
      when(mockBox.getAll()).thenReturn(notifications);

      final stream = dataSource.getAllStream();

      verify(mockBox.getAll()).called(1);
      expect(stream, isNotNull);
      expectLater(stream, emits(notifications));
    });

    test('getCountStream() returns active count stream and refreshes', () {
      when(mockQuery.count()).thenReturn(5);

      final stream = dataSource.getCountStream(NotificationQueryNames.active);

      final mockRefreshQueryBuilder = MockQueryBuilder<recall_notification.Notification>();
      verify(mockBox.query(any)).called(1);
      verify(mockRefreshQueryBuilder.build()).called(1);
      verify(mockQuery.count()).called(1);
      verify(mockQuery.close()).called(1);

      expect(stream, isNotNull);
      expectLater(stream, emits(5));
    });

    test('getCountStream() returns empty stream for unknown query', () {
      final stream = dataSource.getCountStream('unknown');
      expect(stream, isNotNull);
      expectLater(stream, emits(0));
    });

    test('getByContactId() queries and returns matching notifications', () async {
      const contactId = 5;
      final notifications = [createNotification(1), createNotification(2)];
      when(mockIdQuery.find()).thenReturn(notifications);

      final result = await dataSource.getByContactId(contactId);

      expect(result, notifications);
      final mockIdQueryBuilder = MockQueryBuilder<recall_notification.Notification>();
      verify(mockBox.query(argThat(isA<Condition<recall_notification.Notification>>()
              .having((c) => c.toString(), 'toString', contains('Notification_.id.equals($contactId)')))))
          .called(1);
      verify(mockIdQueryBuilder.build()).called(1);
      verify(mockIdQuery.find()).called(1);
      verify(mockIdQuery.close()).called(1);
    });

    test('dispose() closes streams', () async {
      final notificationsFuture = dataSource.getNotifications().toList();
      final countFuture = dataSource.getCountStream(NotificationQueryNames.active).toList();

      dataSource.dispose();

      await expectLater(notificationsFuture, completion(isEmpty));
      await expectLater(countFuture, completion(isEmpty));
    });
  });
}

// Need to define this intermediate mock because the source code uses it
class MockQueryBuilder<T> extends Mock implements QueryBuilder<T> {}
