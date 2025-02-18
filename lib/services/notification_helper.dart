// lib/services/notification_helper.dart
// does the work to get the notification service
// set up and active for the app.  Handles callbacks.

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:recall/main.dart';
import 'package:recall/models/contact.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:logger/logger.dart';

var notificationLogger = Logger();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationHelper {
  static final NotificationHelper _instance = NotificationHelper._internal();

  factory NotificationHelper() {
    return _instance;
  }

  NotificationHelper._internal();

  //initialization code
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
        notificationLogger.i('LOG: Notification Response Received');
        // Handle notification tap when app is in foreground/background
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            _handleNotificationTap(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            // Handle action button tap (if you implement action buttons)
            // TODO: compose text, initiate call, compose discord, etc.
            break;
        }
        // You might want to navigate to a specific screen based on the payload
      },
      //TODO: This is for later implementation of Notification Actions (background?)
      //https://pub.dev/packages/flutter_local_notifications#-usage
      //onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    await requestPermissions();
  }

  Future<void> requestPermissions() async {
    //TODO: expand to include checking permissions
    /*
// Add permission_handler to your pubspec.yaml:
//   permission_handler: ^10.0.0  (or a later version)

import 'package:permission_handler/permission_handler.dart';

// ... inside your NotificationHelper or wherever you schedule ...

Future<void> checkAndRequestNotificationPermission() async {
  PermissionStatus status = await Permission.notification.status;

  if (status.isDenied) {
    // The user has denied the permission.
    // You might want to show a dialog explaining why you need it.
    status = await Permission.notification.request(); // Request again
  }

  if (status.isPermanentlyDenied) {
    // The user has permanently denied the permission.
    // You might want to direct them to the app settings.
    openAppSettings(); // From the permission_handler package
  }

  if (status.isGranted) {
    // Permission is granted, proceed with scheduling.
  }
}
    */
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dueDate,
    required int contactId,
  }) async {
    DateTime now = DateTime.now();
    DateTime scheduledDateTime;

    if (dueDate.difference(now).inMilliseconds.abs()<10){
      scheduledDateTime=now.add(const Duration(seconds:10));
    } else {
      scheduledDateTime=dueDate;
    }

    final scheduledDate = tz.TZDateTime.from(scheduledDateTime,tz.local);
    String payload = "contact_id:$contactId";

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
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
    notificationLogger.i('LOG: Notification Scheduled for $scheduledDate');
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> showTestNotification(Contact contact) async {
    final int notifyId = contact.id ?? 123;
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'recall_channel_id', // Your channel ID
      'reCall Channel', // Your channel name
      channelDescription: 'Notifications for due contacts',
      //importance: Importance.max,
      //priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      notifyId, // A test notification ID (make it unique)
      'Test Notification for ${contact.firstName} ${contact.lastName}',
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

  void _handleNotificationTap(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      // Parse the payload to get the contact ID
      final contactId = int.tryParse(payload.split(':').last);
      if (contactId != null) {
        navigatorKey.currentState?.pushNamed('/contactDetails', arguments:contactId);
      }
    }
  }
}
