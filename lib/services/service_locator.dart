import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:recall/models/models.dart' as m;
import 'package:recall/objectbox.g.dart';
import 'package:recall/repositories/repositories.dart';
import 'package:recall/services/notification_helper.dart';
import 'package:recall/sources/sources.dart';
import 'package:recall/utils/logger.dart';
import 'package:recall/services/notification_service.dart';

final getIt = GetIt.instance;

/// Sets up the service locator with all required dependencies
/// 
/// This must be called before any services are accessed.
/// Will throw exceptions if database initialization fails.
Future<void> setupServiceLocator() async {
  // Initialize ObjectBox
  Store? store;
  try {
    store = await openStore();
    getIt.registerSingleton<Store>(store);
  } catch (e) {
    logger.e("Failed to initialize database: $e");
    throw Exception("Failed to initialize database: $e");
  }
  
  // Register boxes
  getIt.registerSingleton<Box<m.Contact>>(store.box<m.Contact>());
  getIt.registerSingleton<Box<m.Notification>>(store.box<m.Notification>());
  getIt.registerSingleton<Box<m.UserSettings>>(store.box<m.UserSettings>());
  
  // Register data sources
  getIt.registerSingleton<ContactObjectBoxSource>(
    ContactObjectBoxSource(getIt<Box<m.Contact>>()),
  );
  
  getIt.registerSingleton<NotificationObjectBoxSource>(
    NotificationObjectBoxSource(getIt<Box<m.Notification>>()),
  );
  
  getIt.registerSingleton<UserSettingsObjectBoxSource>(
    UserSettingsObjectBoxSource(getIt<Box<m.UserSettings>>()),
  );
  
  // Register repositories
  getIt.registerSingleton<ContactRepository>(
    ContactRepository(getIt<ContactObjectBoxSource>()),
  );
  
  getIt.registerSingleton<NotificationRepository>(
    NotificationRepository(getIt<NotificationObjectBoxSource>()),
  );
  
  getIt.registerSingleton<UserSettingsRepository>(
    UserSettingsRepository(getIt<UserSettingsObjectBoxSource>()),
  );
  
  // Register helpers
  getIt.registerSingleton<NotificationHelper>(
    NotificationHelper(),
  );
  
  // Register services
  getIt.registerSingleton<NotificationService>(
    NotificationService(
      getIt<NotificationHelper>(),
      getIt<UserSettingsRepository>(),
    ),
  );
  
  logger.i('Service locator setup completed successfully.');
}

/// Shows an error dialog when database initialization fails
void showDatabaseErrorDialog(BuildContext context, String error) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('Database Error'),
      content: Text(
        'The app could not initialize its database. This may be due to '
        'file permission issues or disk space problems.\n\n'
        'Technical details: $error'
      ),
      actions: [
        TextButton(
          child: const Text('EXIT'),
          onPressed: () => exit(context),
        ),
        TextButton(
          child: const Text('TRY AGAIN'),
          onPressed: () => tryAgain(context),
        ),
      ],
    ),
  );
}

/// Exits the app
void exit(BuildContext context) {
  Navigator.of(context).pop();
  // You may need to add platform-specific code to actually exit the app
}

/// Attempts to initialize the app again
void tryAgain(BuildContext context) {
  Navigator.of(context).pop();
  // You would add code here to retry initialization
  // Possibly by restarting the app or reinitializing services
}
