// lib/main.dart
import 'package:flutter/material.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:logger/logger.dart';
import 'package:recall/utils/objectbox_utils.dart' as objectbox_utils;
import 'package:recall/app.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:recall/services/notification_service.dart';
import 'package:recall/services/notification_helper.dart';
import 'objectbox.g.dart' as objectbox_g;

final logger = Logger();

late final objectbox_g.Store? store; // Declare the store

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized

  store = await objectbox_utils.openStore(); // Initialize the store

  // Initialize NotificationHelper
  final notificationHelper = NotificationHelper();
  await notificationHelper.init();

  // Initialize NotificationService
  final notificationService = NotificationService(store, notificationHelper);

  runApp(ReCall(
      contactRepository:
          ContactRepository(store))); // Pass the store to the repository
  logger.i('LOG:App started');
}
