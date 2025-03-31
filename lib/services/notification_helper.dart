// lib/services/notification_helper.dart
// does the work to get the notification service
// set up and active for the app.  Handles callbacks.

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
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
        AndroidInitializationSettings(
            'notification_icon'); // Use underscores, no extension

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
        // LOGGING START
        notificationLogger.i(
            '>>> Notification Tapped! Type: ${notificationResponse.notificationResponseType}'); // Using logger
        notificationLogger.i(
            '>>> Received payload: ${notificationResponse.payload}'); // Using logger
        // LOGGING END
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
    required int id, // Keep using contact ID as notification ID
    required String title, // Base title
    required String body, // Base body
    required DateTime calculatedDueDate, // The ideal due date
    required Contact contact, // Pass the full contact
    required int notificationHour,
    required int notificationMinute,
  }) async {
    tz.TZDateTime scheduledDate;
    String notificationTitle = title; // Start with base title
    String notificationBody = body; // Start with base body

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime tzCalculatedDueDate =
        tz.TZDateTime.from(calculatedDueDate, tz.local);

    // Target time on a given date, using the user's settings
    tz.TZDateTime targetTimeOnDate(tz.TZDateTime date) {
      return tz.TZDateTime(tz.local, date.year, date.month, date.day,
          notificationHour, notificationMinute);
    }

    // Check if the calculated due date is in the past (or very close to now)
    if (tzCalculatedDueDate.isBefore(now) ||
        now.difference(tzCalculatedDueDate).inSeconds.abs() < 5) {
      // It's overdue or happening right now. Schedule for tomorrow morning.
      tz.TZDateTime tomorrow =
          tz.TZDateTime(tz.local, now.year, now.month, now.day)
              .add(const Duration(days: 1));
      scheduledDate = targetTimeOnDate(tomorrow); // Use user's time

      // Optional: Modify title/body for overdue notifications
      notificationTitle = "OVERDUE: ${contact.firstName} ${contact.lastName}";
      notificationBody =
          "Contact was due on ${DateFormat.yMd().format(calculatedDueDate)}.";
      notificationLogger.i(
          'LOG: Contact $id overdue (due $calculatedDueDate). Scheduling for $scheduledDate');
    } else {
      // It's due in the future. Schedule for the calculated date.
      scheduledDate = targetTimeOnDate(tzCalculatedDueDate); // Use user's time
      notificationLogger
          .i('LOG: Contact $id due in future. Scheduling for $scheduledDate');
    }

    // Ensure we don't schedule in the past (safety net)
    if (scheduledDate.isBefore(now)) {
      // If the calculated time today/tomorrow is already past, schedule for the *next* occurrence
      // (e.g., if it's 10 AM and time is 9 AM, schedule for 9 AM tomorrow)
      if (scheduledDate.day == now.day) {
        scheduledDate = scheduledDate
            .add(const Duration(days: 1)); // Push to same time tomorrow
      } else {
        // If it was already calculated for tomorrow but still ended up in the past (unlikely but possible near midnight), push further
        scheduledDate =
            now.add(const Duration(seconds: 5)); // Fallback: 5 seconds from now
      }
      notificationLogger.w(
          'LOG: Adjusted schedule time for contact $id to be in the future: $scheduledDate');
    }

    String payload = "contact_id:${contact.id}";
    //debuging code
    // Format the final 'scheduledDate' (include date and time)
    final String formattedScheduledDateTime =
        DateFormat.yMd().add_jm().format(scheduledDate);
    // Append it to the original notification body
    final String debugNotificationBody =
        '$notificationBody (Scheduled: $formattedScheduledDateTime)'; // Use scheduled date/time
    // end debugging code

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      notificationTitle, // Use potentially modified title
      debugNotificationBody, // Use potentially modified body
      scheduledDate, // The finally determined schedule date
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'recall_channel_id', // Channel ID
          'Recall Channel', // Channel Name
          channelDescription: 'Notifications for due contacts',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: payload,
      matchDateTimeComponents:
          null, // Usually null for specific date/time schedules
    );
    notificationLogger.i(
        'LOG: Notification $id scheduled for $scheduledDate with payload $payload');
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> showTestNotification(Contact contact) async {
    // Ensure contact ID is not null before creating payload
    if (contact.id == null) {
      notificationLogger
          .e("Cannot show test notification for contact with null ID.");
      return;
    }
    final int notifyId = contact.id!; // Use non-nullable ID
    // --- Create the payload ---
    final String payload = "contact_id:$notifyId";
    // --- End Create payload ---

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'recall_channel_id',
      'reCall Channel',
      channelDescription: 'Notifications for due contacts',
      importance: Importance.max, // Max importance for testing visibility
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      notifyId,
      'Test: ${contact.firstName} ${contact.lastName}', // Test title
      'This is a test notification. Tap me!', // Test body
      platformChannelSpecifics,
      // --- ADD THIS LINE ---
      payload: payload, // Pass the payload here
      // --- END ADD ---
    );
    notificationLogger
        .i('LOG: Displayed test notification $notifyId with payload $payload');
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    notificationLogger
        .i("Pending Notifications: ${pendingNotificationRequests.toString()}");
    return pendingNotificationRequests;
  }

  void _handleNotificationTap(String? payload) {
    // --- ADD LOGGING HERE ---
    notificationLogger.i(
        '>>> _handleNotificationTap called with payload: $payload'); // Using logger
    // --- END LOGGING ---

    if (payload != null &&
        payload.isNotEmpty &&
        payload.startsWith('contact_id:')) {
      final String idString = payload.split(':').last;
      notificationLogger
          .i('>>> Extracted ID string: $idString'); // Using logger
      final contactId = int.tryParse(idString);
      notificationLogger.i('>>> Parsed contactId: $contactId'); // Using logger

      if (contactId != null) {
        // --- ADD LOGGING HERE ---
        notificationLogger.i(
            '>>> Attempting navigation to /contactDetails with argument: $contactId'); // Using logger
        notificationLogger.i(
            '>>> navigatorKey.currentState is null? ${navigatorKey.currentState == null}'); // Using logger
        // --- END LOGGING ---
        navigatorKey.currentState
            ?.pushNamed('/contactDetails', arguments: contactId);
      } else {
        notificationLogger
            .w('>>> Failed to parse contactId from payload.'); // Using logger
      }
    } else {
      notificationLogger
          .w('>>> Payload is null, empty, or invalid format.'); // Using logger
    }
  }
}
