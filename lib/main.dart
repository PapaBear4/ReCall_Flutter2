<<<<<<< Updated upstream
// lib/main.dart
import 'package:flutter/material.dart';
=======
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
>>>>>>> Stashed changes
import 'package:recall/repositories/contact_repository.dart';
import 'package:logger/logger.dart';
import 'package:recall/utils/objectbox_utils.dart' as objectbox_utils;
import 'package:recall/app.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'objectbox.g.dart' as objectbox_g;

final logger = Logger();

<<<<<<< Updated upstream
late final objectbox_g.Store? store; // Declare the store
=======
late final Store? store; // Declare the store

final StreamController<NotificationResponse> selectNotificationStream =
    StreamController<NotificationResponse>.broadcast();

const MethodChannel platform = MethodChannel('I DONt know what this is');

const String portName = 'notification_send_port';

String? selectedNotificationPayload;

/// A notification action which triggers a url launch event
const String urlLaunchActionId = 'id_1';

/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';

/// Defines a iOS/MacOS notification category for text input actions.
const String darwinNotificationCategoryText = 'textCategory';

/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

Future<Store?> openStore() async {
  if (kIsWeb) {
    return null;
  }
  try {
    final docsDir = await getApplicationDocumentsDirectory();
    return Store(getObjectBoxModel(), directory: '${docsDir.path}/objectbox');
  } catch (e) {
    logger.i("Error opening objectbox: $e");
    return null;
  }
}
>>>>>>> Stashed changes

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized

  await _configureLocalTimeZone();

  store = await objectbox_utils.openStore(); // Initialize the store

  runApp(ReCall(
      contactRepository:
          ContactRepository(store))); // Pass the store to the repository
  logger.i('LOG:App started');
}
