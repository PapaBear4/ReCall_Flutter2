// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/repositories/usersettings_repository.dart';
import 'package:recall/utils/logger.dart'; // Adjust path if needed
import 'package:recall/utils/objectbox_utils.dart' as objectbox_utils;
import 'package:recall/app.dart';
import 'package:recall/services/notification_service.dart';
import 'package:recall/services/notification_helper.dart';
import 'objectbox.g.dart' as objectbox_g;
import 'package:workmanager/workmanager.dart';
import 'package:recall/services/background_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

late final objectbox_g.Store? store; // Declare the store

String? initialNotificationPayload;  // to hold initial payload


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized

  store = await objectbox_utils.openStore(); // Initialize the store

  // Initialize NotificationHelper
  final notificationHelper = NotificationHelper();
  await notificationHelper.init();

  // --- CHECK FOR APP LAUNCH DETAILS ---
  final NotificationAppLaunchDetails? notificationAppLaunchDetails = await
      flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails(); // Use the plugin instance from helper

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    initialNotificationPayload = notificationAppLaunchDetails!.notificationResponse?.payload;
    logger.i('App launched via notification tap. Payload: $initialNotificationPayload');
  }
  // --- END CHECK ---

  // Create repositories
  final contactRepository = ContactRepository(store);
  final userSettingsRepository = UserSettingsRepository(store); 

  // Initialize NotificationService
  final notificationService =
      NotificationService(notificationHelper, userSettingsRepository);

  // --- Initialize Background Service ---
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  initializeBackgroundService(); // Call the helper from background_service.dart


  runApp(ChangeNotifierProvider<NotificationService>(
        create: (_) => notificationService,
        child: ReCall(
          contactRepository: contactRepository,
          userSettingsRepository: userSettingsRepository,
        ),
      ));
  //logger.i('LOG:App started, background service initialized');
}
