// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:recall/services/notification_helper.dart';
// Import GetIt instance
import 'package:recall/services/service_locator.dart';
// Import repositories and services needed from GetIt
import 'package:recall/services/notification_service.dart';
import 'package:recall/utils/logger.dart'; // Adjust path if needed
import 'package:recall/app.dart';
import 'package:workmanager/workmanager.dart';
import 'package:recall/services/background_service.dart' as bg;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

String? initialNotificationPayload; // to hold initial payload

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Setup service locator - this initializes the store and registers dependencies
    await setupServiceLocator();

    // Retrieve NotificationHelper from GetIt
    final notificationHelper = getIt<NotificationHelper>();
    await notificationHelper.init(); // Initialize it

    // --- CHECK FOR APP LAUNCH DETAILS ---
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await notificationHelper.getNotificationAppLaunchDetails(); // Use helper from GetIt

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      initialNotificationPayload =
          notificationAppLaunchDetails!.notificationResponse?.payload;
      logger.i(
          'App launched via notification tap. Payload: $initialNotificationPayload');
    }
    // --- END CHECK ---

    // Retrieve NotificationService from GetIt
    final notificationService = getIt<NotificationService>();

    // --- Initialize Background Service ---
    // Workmanager initialization remains the same
    await Workmanager().initialize(bg.callbackDispatcher, isInDebugMode: false);
    bg.initializeBackgroundService(); // Call the helper from background_service.dart

    // Use retrieved instances in Provider and App
    runApp(ChangeNotifierProvider<NotificationService>(
      create: (_) => notificationService, // Use instance from GetIt
      child: const ReCall(),
    ));
    logger.i('LOG:App started, background service initialized');
  } catch (e) {
    logger.e("Error during app initialization: $e"); // Log the specific error
    // Handle initialization error, perhaps with a simple error screen
    runApp(ErrorApp(error: e.toString()));
  }
}

// ErrorApp widget implementation...
class ErrorApp extends StatelessWidget {
  final String error;

  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
