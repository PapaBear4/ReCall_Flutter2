// lib/services/background_service.dart
import 'package:recall/utils/logger.dart'; // Adjust path if needed
import 'package:recall/models/contact.dart';
import 'package:recall/models/enums.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/repositories/usersettings_repository.dart';
import 'package:recall/services/notification_helper.dart';
import 'package:recall/services/notification_service.dart';
import 'package:recall/utils/contact_utils.dart';
import 'package:workmanager/workmanager.dart';
import 'package:recall/objectbox.g.dart'; // Import generated ObjectBox code
import 'package:path_provider/path_provider.dart'; // Import path_provider
// Import core objectbox
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart'; // Import the package

@pragma('vm:entry-point')
void callbackDispatcher() async {
  logger.i("--- callbackDispatcher Isolate STARTED ---");
    // *** Initialize Timezone right after isolate starts ***
  // Initialize Timezone right after isolate starts
  try {
      // 1. Initialize database (still required first)
      tz.initializeTimeZones();

      // 2 & 3. Get and set the device's local location (ASYNC!)
      // We need to make this part async now, which callbackDispatcher isn't directly.
      // We'll do it inside the executeTask lambda before it's needed.
      // Leaving just initializeTimeZones here is fine.
      logger.d("Timezone database initialized in background isolate.");

  } catch(e) {
      logger.e("Error initializing timezone DB in background: $e");
  }
  // *** End Timezone Initialization ***


  Workmanager().executeTask((task, inputData) async {
    logger.i("Background task '$task' started.");
    Store? store; // Declare store variable
    try {
             // *** Set Dynamic Timezone at start of task execution ***
       try {
          final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
          final tz.Location deviceLocation = tz.getLocation(currentTimeZone);
          tz.setLocalLocation(deviceLocation);
          logger.d("Timezone set for background task using device zone: $currentTimeZone");
       } catch(e) {
          logger.e("Error setting dynamic timezone in background task: $e. Falling back to UTC.");
          // Optionally set tz.setLocalLocation(tz.UTC); or let it potentially use UTC default
       }
       // *** End Timezone Setup ***

      // --- Get Store Path ---
      logger.d("Getting documents directory for ObjectBox...");
      final docsDir = await getApplicationDocumentsDirectory();
      final storePath = '${docsDir.path}/objectbox';
      logger.d("ObjectBox store path: $storePath");

      // --- Attach or Open ObjectBox Store ---
      if (Store.isOpen(storePath)) {
         logger.d("Store is already open, attaching...");
         store = Store.attach(getObjectBoxModel(), storePath);
         logger.d("Successfully attached to existing ObjectBox store.");
      } else {
         logger.d("Store is not open, attempting to open new instance...");
         // Fallback to opening a new store if not already open
         store = Store(getObjectBoxModel(), directory: storePath);
         logger.d("New ObjectBox store instance opened successfully.");
      }
      // --- End Store Attach/Open ---

      // --- Create Repositories (remains the same) ---
      logger.d("Creating repositories and services...");
      final contactRepository = ContactRepository(store);
      final userSettingsRepository = UserSettingsRepository(store);
      final notificationHelper = NotificationHelper();
      final notificationService = NotificationService(notificationHelper, userSettingsRepository);
      logger.d("Repositories and services created.");
      // --- End Repo Creation ---

      // --- Task Logic Phase (remains the same) ---
      logger.d("Fetching all contacts...");
      final List<Contact> allContacts = await contactRepository.getAll();
      logger.i("Fetched ${allContacts.length} contacts.");

      // ... (rest of the task logic: finding overdue, scheduling reminders) ...
       final List<Contact> overdueContacts = allContacts.where((contact) {
          if (contact.frequency == ContactFrequency.never.value) return false;
          return isOverdue(contact);
       }).toList();
       logger.i("Found ${overdueContacts.length} overdue contacts.");
       logger.d("Processing ${overdueContacts.length} overdue contacts...");
       for (final contact in overdueContacts) {
         logger.d("Processing overdue contact ID: ${contact.id}");
         await notificationService.scheduleReminder(contact);
       }
      // --- End Task Logic ---

      logger.i("Background task '$task' completed successfully.");
      return Future.value(true);
    } catch (err, stack) {
      logger.e("Error executing background task '$task': $err\n$stack");
      return Future.value(false);
    } finally {
       // Close / Detach from the store instance used by this isolate
       logger.d("Closing/Detaching background ObjectBox store reference.");
       // Calling close() on an attached store should be safe and detach it.
       store?.close();
    }
  });
}

// initializeBackgroundService remains the same (keep testing settings for now)
void initializeBackgroundService() {
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false // Keep true for testing
  );
  Workmanager().registerPeriodicTask(
    "recall_overdue_check_1",
    "checkOverdueContacts",
    frequency: const Duration(hours: 12), // Keep testing frequency
    constraints: Constraints(
      requiresCharging: false,
      networkType: NetworkType.not_required,
    ),
    initialDelay: const Duration(seconds: 10), // Keep testing delay
    existingWorkPolicy: ExistingWorkPolicy.keep, // Keep replace for testing
  );
   logger.i("Background service initialized and task registered (TESTING MODE).");
}