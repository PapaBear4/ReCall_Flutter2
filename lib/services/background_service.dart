// lib/services/background_service.dart
import 'package:logger/logger.dart';
import 'package:recall/main.dart'; // To access store if needed globally (or pass path)
import 'package:recall/models/contact.dart';
import 'package:recall/models/contact_frequency.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/services/notification_helper.dart';
import 'package:recall/services/notification_service.dart';
import 'package:recall/utils/last_contacted_utils.dart';
import 'package:recall/utils/objectbox_utils.dart' as objectbox_utils;
import 'package:workmanager/workmanager.dart';
import 'package:recall/objectbox.g.dart' as objectbox_g; // Import generated ObjectBox file

final bgLogger = Logger();

// A top-level function is required for background execution
@pragma('vm:entry-point') // Mandatory if enabling Flutter obfuscation
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    bgLogger.i("Background task '$task' started.");
    try {
      // --- Initialization Phase ---
      // 1. Initialize ObjectBox Store
      //    Note: Ensure objectbox_utils.openStore() works without BuildContext
      final objectbox_g.Store? store = await objectbox_utils.openStore();
      if (store == null) {
        bgLogger.e("Failed to open ObjectBox store in background task.");
        return Future.value(false); // Indicate failure
      }

      // 2. Initialize Repositories and Services
      final contactRepository = ContactRepository(store);
      final notificationHelper = NotificationHelper();
      // IMPORTANT: NotificationHelper init needs WidgetsFlutterBinding.ensureInitialized()
      // if it uses platform channels internally beyond the plugin itself.
      // flutter_local_notifications handles its own initialization, but double-check
      // if you added other platform channel calls there. Let's assume it's okay for now.
      // await notificationHelper.init(); // Usually called in main, might not be needed again unless state is lost

      final notificationService = NotificationService(notificationHelper);

      // --- Task Logic Phase ---
      // 3. Fetch Contacts
      final List<Contact> allContacts = await contactRepository.getAll();
      bgLogger.i("Fetched ${allContacts.length} contacts.");

      // 4. Identify Overdue Contacts
      final List<Contact> overdueContacts = allContacts.where((contact) {
         // Skip contacts set to 'never' or with null lastContacted if isOverdue expects non-null
         if (contact.frequency == ContactFrequency.never.value) return false;
         // isOverdue might need adjustment if it doesn't handle null lastContacted gracefully,
         // though scheduleReminder should handle the 'never contacted' case.
         return isOverdue(contact.frequency, contact.lastContacted);
      }).toList();

      bgLogger.i("Found ${overdueContacts.length} overdue contacts.");

      // 5. Trigger Scheduling for Overdue Contacts
      for (final contact in overdueContacts) {
        bgLogger.i("Processing overdue contact ID: ${contact.id}");
        await notificationService.scheduleReminder(contact);
      }

      bgLogger.i("Background task '$task' completed successfully.");
      return Future.value(true); // Indicate success
    } catch (err, stack) {
      bgLogger.e("Error executing background task '$task': $err\n$stack");
      return Future.value(false); // Indicate failure
    }
  });
}

// Helper function to initialize and register the background task (call this from main)
void initializeBackgroundService() {
  Workmanager().initialize(
    callbackDispatcher, // The top-level function to call
    isInDebugMode: false // Set to true for testing, false for release
  );
  // Register the periodic task
  Workmanager().registerPeriodicTask(
    "recall_overdue_check_1", // Unique name for the task
    "checkOverdueContacts", // Task name passed to callbackDispatcher
    frequency: const Duration(days: 1), // How often to run (e.g., daily)
    // Optional: Add constraints like network connectivity or charging
    // constraints: Constraints(
    //   networkType: NetworkType.connected,
    // ),
    initialDelay: const Duration(minutes: 5), // Optional delay before first run
    existingWorkPolicy: ExistingWorkPolicy.keep, // Keep existing task if already registered
  );
   bgLogger.i("Background service initialized and task registered.");
}