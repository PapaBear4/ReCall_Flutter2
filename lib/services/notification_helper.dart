// lib/services/notification_helper.dart
// does the work to get the notification service
// set up and active for the app.  Handles callbacks.

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:recall/main.dart';
import 'package:recall/models/contact.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:recall/utils/logger.dart'; // Adjust path if needed
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:go_router/go_router.dart';
import 'package:recall/config/app_router.dart';

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
    try {
      // 1. Initialize timezone database (required first)
      tz.initializeTimeZones();

      // 2. Get the native device timezone name string
      final String currentTimeZone = await FlutterTimezone.getLocalTimezone();

      // 3. Get the Location object for that name
      final tz.Location deviceLocation = tz.getLocation(currentTimeZone);

      // 4. Set it as the default local location for this isolate
      tz.setLocalLocation(deviceLocation);

      //logger.i("Timezone initialized for main isolate using device zone: $currentTimeZone");

    } catch (e) {
       logger.e("Error initializing/setting timezone: $e. Falling back to UTC for main isolate.");
       // Optionally set to UTC explicitly on error: tz.setLocalLocation(tz.UTC);
    }

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
        logger.i(
            '>>> Notification Tapped! Type: ${notificationResponse.notificationResponseType}'); // Using logger
        logger.i(
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
    );

    await requestAndHandlePermissions();
  }

  Future<bool> requestAndHandlePermissions() async {
    PermissionStatus status = await Permission.notification.status;
    //logger.i('Notification permission status: $status');

    if (status.isGranted) {
      //logger.i('Notification permission already granted.');
      return true; // Permission already granted
    }

    if (status.isDenied) {
      // Permission was denied previously but not permanently. Request again.
      logger.i('Notification permission denied, requesting again...');
      final PermissionStatus newStatus = await Permission.notification.request();
      logger.i('Notification permission status after request: $newStatus');
      return newStatus.isGranted; // Return true if granted after request
    }

    if (status.isPermanentlyDenied) {
      // Permission permanently denied. User needs to go to settings.
      logger.w('Notification permission permanently denied. Cannot request.');
      // Optional: Trigger UI to show a message asking user to go to settings.
      // Example: You might use a global key navigator or a state management solution
      //          to show a dialog from here, or return false and handle it in the UI layer.
      // For simplicity now, just log it. You might want to call openAppSettings():
      // await openAppSettings(); // Requires user interaction in UI ideally
      return false;
    }

     if (status.isRestricted) {
       // Typically on iOS - parental controls etc.
       logger.w('Notification permission is restricted.');
       return false;
     }

     // Handle other potential states like 'limited' (new on iOS 14+) if applicable
     // For now, assume isGranted is the goal.

     // Default case (shouldn't typically be reached if logic above is sound)
     // If status wasn't granted, denied, or permanently denied, request it.
     // This covers potential initial states where status might not be determined yet.
     logger.i('Notification permission status unknown or requires request, requesting...');
     final PermissionStatus finalStatus = await Permission.notification.request();
     logger.i('Notification permission status after final request: $finalStatus');
     return finalStatus.isGranted;
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
      logger.i(
          'LOG: Contact $id overdue (due $calculatedDueDate). Scheduling for $scheduledDate');
    } else {
      // It's due in the future. Schedule for the calculated date.
      scheduledDate = targetTimeOnDate(tzCalculatedDueDate); // Use user's time
      //logger
      //    .i('LOG: Contact $id due in future. Scheduling for $scheduledDate');
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
      logger.w(
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
    //logger.i(
    //    'LOG: Notification $id scheduled for $scheduledDate with payload $payload');
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
      logger
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
    logger
        .i('LOG: Displayed test notification $notifyId with payload $payload');
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    logger
        .i("Pending Notifications: ${pendingNotificationRequests.toString()}");
    return pendingNotificationRequests;
  }

  void _handleNotificationTap(String? payload) {
    if (payload != null &&
        payload.isNotEmpty &&
        payload.startsWith('contact_id:')) {
      final String idString = payload.split(':').last;
      final contactId = int.tryParse(idString);

      if (contactId != null) {
        // Use GoRouter to navigate, ensuring context is available via the key
        if (navigatorKey.currentContext != null) {
           GoRouter.of(navigatorKey.currentContext!).pushNamed(
                AppRouter.contactDetailsRouteName,
                pathParameters: {'id': contactId.toString()},
              );
        } else {
           logger.e(">>> Navigator key context was null, couldn't navigate from notification tap.");
        }
      } else {
        logger
            .w('>>> Failed to parse contactId from payload.'); // Using logger
      }
    } else {
      logger
          .w('>>> Payload is null, empty, or invalid format.'); // Using logger
    }
  }
}
