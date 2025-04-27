// lib/services/background_service.dart
import 'package:recall/utils/logger.dart'; // Adjust path if needed
import 'package:recall/models/contact.dart';
import 'package:recall/models/contact_enums.dart';
// Import models explicitly for GetIt registration
import 'package:recall/models/models.dart' as m;
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/repositories/usersettings_repository.dart';
// Import NotificationRepository for registration
import 'package:recall/repositories/notification_repository.dart';
import 'package:recall/services/notification_helper.dart';
import 'package:recall/services/notification_service.dart';
// Import sources for registration
import 'package:recall/sources/sources.dart';
import 'package:recall/utils/last_contacted_utils.dart';
import 'package:workmanager/workmanager.dart';
import 'package:recall/objectbox.g.dart'; // Import generated ObjectBox code
import 'package:path_provider/path_provider.dart'; // Import path_provider
// Import core objectbox
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart'; // Import the package
// Import GetIt
import 'package:get_it/get_it.dart';

// Get the GetIt instance
final getIt = GetIt.instance;

@pragma('vm:entry-point')
void callbackDispatcher() async {
  logger.i("--- callbackDispatcher Isolate STARTED ---");
  // *** Initialize Timezone right after isolate starts ***
  try {
    tz.initializeTimeZones();
    logger.d("Timezone database initialized in background isolate.");
  } catch (e) {
    logger.e("Error initializing timezone DB in background: $e");
  }
  // *** End Timezone Initialization ***

  Workmanager().executeTask((task, inputData) async {
    logger.i("Background task '$task' started.");
    Store? store; // Declare store variable
    bool getItInitialized = false; // Track if GetIt was initialized for this task

    try {
      // *** Set Dynamic Timezone at start of task execution ***
      try {
        final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
        final tz.Location deviceLocation = tz.getLocation(currentTimeZone);
        tz.setLocalLocation(deviceLocation);
        logger.d("Timezone set for background task using device zone: $currentTimeZone");
      } catch (e) {
        logger.e("Error setting dynamic timezone in background task: $e. Falling back to UTC.");
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
        store = Store(getObjectBoxModel(), directory: storePath);
        logger.d("New ObjectBox store instance opened successfully.");
      }
      // --- End Store Attach/Open ---

      // --- Register Dependencies with GetIt ---
      logger.d("Registering dependencies with GetIt for background task...");
      getIt.registerSingleton<Store>(store);
      getIt.registerSingleton<Box<m.Contact>>(store.box<m.Contact>());
      getIt.registerSingleton<Box<m.Notification>>(store.box<m.Notification>());
      getIt.registerSingleton<Box<m.UserSettings>>(store.box<m.UserSettings>());
      getIt.registerSingleton<ContactObjectBoxSource>(ContactObjectBoxSource(getIt<Box<m.Contact>>()));
      getIt.registerSingleton<NotificationObjectBoxSource>(NotificationObjectBoxSource(getIt<Box<m.Notification>>()));
      getIt.registerSingleton<UserSettingsObjectBoxSource>(UserSettingsObjectBoxSource(getIt<Box<m.UserSettings>>()));
      getIt.registerSingleton<ContactRepository>(ContactRepository(getIt<ContactObjectBoxSource>()));
      getIt.registerSingleton<NotificationRepository>(NotificationRepository(getIt<NotificationObjectBoxSource>()));
      getIt.registerSingleton<UserSettingsRepository>(UserSettingsRepository(getIt<UserSettingsObjectBoxSource>()));
      getIt.registerSingleton<NotificationHelper>(NotificationHelper());
      getIt.registerSingleton<NotificationService>(NotificationService(getIt<NotificationHelper>(), getIt<UserSettingsRepository>()));
      getItInitialized = true;
      logger.d("Dependencies registered successfully.");
      // --- End Dependency Registration ---

      // --- Retrieve Services from GetIt ---
      logger.d("Retrieving services from GetIt...");
      final contactRepository = getIt<ContactRepository>();
      final notificationService = getIt<NotificationService>();
      logger.d("Services retrieved.");
      // --- End Service Retrieval ---

      // --- Task Logic Phase ---
      logger.d("Fetching all contacts...");
      final List<Contact> allContacts = await contactRepository.getAll();
      logger.i("Fetched ${allContacts.length} contacts.");

      final List<Contact> overdueContacts = allContacts.where((contact) {
        if (contact.frequency == ContactFrequency.never.value) return false;
        return isOverdue(contact.frequency, contact.lastContacted);
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
      if (getItInitialized) {
        logger.d("Resetting GetIt registrations for background task...");
        await getIt.reset(dispose: false);
        logger.d("GetIt reset complete.");
      }
      logger.d("Closing/Detaching background ObjectBox store reference.");
      store?.close();
      logger.d("Store closed/detached.");
    }
  });
}

void initializeBackgroundService() {
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false
  );
  Workmanager().registerPeriodicTask(
    "recall_overdue_check_1",
    "checkOverdueContacts",
    frequency: const Duration(hours: 12),
    constraints: Constraints(
      requiresCharging: false,
      networkType: NetworkType.not_required,
    ),
    initialDelay: const Duration(seconds: 10),
    existingWorkPolicy: ExistingWorkPolicy.keep,
  );
  logger.i("Background service initialized and task registered (TESTING MODE).");
}