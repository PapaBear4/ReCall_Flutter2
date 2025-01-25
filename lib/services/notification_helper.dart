// lib/services/notification_helper.dart
// does the work to get the notification service
// set up and active for the app.  Handles callbacks.
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:logger/logger.dart';

var notificationLogger = Logger();

class NotificationHelper {
  static final NotificationHelper _instance = NotificationHelper._internal();

  factory NotificationHelper() {
    return _instance;
  }

  NotificationHelper._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize Time Zones
    tz.initializeTimeZones();
    // TODO: Make this dynamic based on the user's actual time zone
    // For now it's hardcoded to NY
    tz.setLocalLocation(
        tz.getLocation('America/New_York')); // Set your desired timezone

    // Android Initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // Your app icon

    // iOS Initialization (add if needed, with appropriate settings)
    // final DarwinInitializationSettings initializationSettingsDarwin =
    //     DarwinInitializationSettings(
    //         requestAlertPermission: false,
    //         requestBadgePermission: false,
    //         requestSoundPermission: false,
    //         onDidReceiveLocalNotification:
    //             (int id, String? title, String? body, String? payload) async {
    //           // Handle notification tap on iOS (if needed)
    //         });

    // Initialization Settings
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        // Handle notification tap when app is in foreground/background
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            // Handle regular notification tap
            break;
          case NotificationResponseType.selectedNotificationAction:
            // Handle action button tap (if you implement action buttons)
            break;
        }
        // You might want to navigate to a specific screen based on the payload
      },
    );

    await requestPermissions();
  }

  Future<void> requestPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
      required DateTime dueDate}) async {
    final scheduledDate = tz.TZDateTime(
            tz.local,
            dueDate.year,
            dueDate.month,
            dueDate.day,
            10, // Set the notification time (e.g., 10:00 AM)
          );
    notificationLogger.i('LOG: helper function called');
    notificationLogger.i('Scheduling notification with ID: $id, title: $title, body: $body, due date: $scheduledDate');

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'recall_channel_id', // Define this in your AndroidManifest.xml
            'Recall Channel',
            channelDescription: 'Notifications for due contacts',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
            payload: scheduledDate.toString(),
        matchDateTimeComponents: DateTimeComponents.time);
    notificationLogger.i('LOG: Notification Scheduled');
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> showTestNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'recall_channel_id', // Your channel ID
      'Recall Channel', // Your channel name
      channelDescription: 'Notifications for due contacts',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      123, // A test notification ID (make it unique)
      'Test Notification',
      'This is a test notification.',
      platformChannelSpecifics,
    );
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    notificationLogger
        .i("Pending Notifications: ${pendingNotificationRequests.toString()}");
    return pendingNotificationRequests;
  }
}
