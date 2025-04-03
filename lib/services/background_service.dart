// lib/services/background_service.dart
import 'package:logger/logger.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/models/contact_frequency.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/repositories/usersettings_repository.dart';
import 'package:recall/services/notification_helper.dart';
import 'package:recall/services/notification_service.dart';
import 'package:recall/utils/last_contacted_utils.dart';
import 'package:workmanager/workmanager.dart';
import 'package:recall/objectbox.g.dart'; // Import generated ObjectBox code
import 'package:path_provider/path_provider.dart'; // Import path_provider
import 'package:objectbox/objectbox.dart'; // Import core objectbox
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final bgLogger = Logger();

@pragma('vm:entry-point')
void callbackDispatcher() {
  bgLogger.i("--- callbackDispatcher Isolate STARTED ---");
    // *** Initialize Timezone right after isolate starts ***
  try {
      tz.initializeTimeZones();
      // You might optionally call tz.setLocalLocation here if needed,
      // mirroring main.dart, but often initializeTimeZones is sufficient
      // for the background isolate to use the system's default correctly.
      // Example: tz.setLocalLocation(tz.getLocation('America/New_York'));
      bgLogger.d("Timezone package initialized in background isolate.");
  } catch(e) {
      bgLogger.e("Error initializing timezone in background: $e");
      // Decide if the task should fail if timezone init fails
  }
  // *** End Timezone Initialization ***


  Workmanager().executeTask((task, inputData) async {
    bgLogger.i("Background task '$task' started.");
    Store? store; // Declare store variable
    try {
      // --- Get Store Path ---
      bgLogger.d("Getting documents directory for ObjectBox...");
      final docsDir = await getApplicationDocumentsDirectory();
      final storePath = '${docsDir.path}/objectbox';
      bgLogger.d("ObjectBox store path: $storePath");

      // --- Attach or Open ObjectBox Store ---
      if (Store.isOpen(storePath)) {
         bgLogger.d("Store is already open, attaching...");
         store = Store.attach(getObjectBoxModel(), storePath);
         bgLogger.d("Successfully attached to existing ObjectBox store.");
      } else {
         bgLogger.d("Store is not open, attempting to open new instance...");
         // Fallback to opening a new store if not already open
         store = Store(getObjectBoxModel(), directory: storePath);
         bgLogger.d("New ObjectBox store instance opened successfully.");
      }
      // --- End Store Attach/Open ---

      // --- Create Repositories (remains the same) ---
      bgLogger.d("Creating repositories and services...");
      final contactRepository = ContactRepository(store);
      final userSettingsRepository = UserSettingsRepository(store);
      final notificationHelper = NotificationHelper();
      final notificationService = NotificationService(notificationHelper, userSettingsRepository);
      bgLogger.d("Repositories and services created.");
      // --- End Repo Creation ---

      // --- Task Logic Phase (remains the same) ---
      bgLogger.d("Fetching all contacts...");
      final List<Contact> allContacts = await contactRepository.getAll();
      bgLogger.i("Fetched ${allContacts.length} contacts.");

      // ... (rest of the task logic: finding overdue, scheduling reminders) ...
       final List<Contact> overdueContacts = allContacts.where((contact) {
          if (contact.frequency == ContactFrequency.never.value) return false;
          return isOverdue(contact.frequency, contact.lastContacted);
       }).toList();
       bgLogger.i("Found ${overdueContacts.length} overdue contacts.");
       bgLogger.d("Processing ${overdueContacts.length} overdue contacts...");
       for (final contact in overdueContacts) {
         bgLogger.d("Processing overdue contact ID: ${contact.id}");
         await notificationService.scheduleReminder(contact);
       }
      // --- End Task Logic ---

      bgLogger.i("Background task '$task' completed successfully.");
      return Future.value(true);
    } catch (err, stack) {
      bgLogger.e("Error executing background task '$task': $err\n$stack");
      return Future.value(false);
    } finally {
       // Close / Detach from the store instance used by this isolate
       bgLogger.d("Closing/Detaching background ObjectBox store reference.");
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
   bgLogger.i("Background service initialized and task registered (TESTING MODE).");
}