// lib/main.dart
import 'package:flutter/material.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:logger/logger.dart';
import 'package:recall/utils/objectbox_utils.dart' as objectbox_utils;
import 'package:recall/app.dart';
import 'objectbox.g.dart' as objectbox_g;

final logger = Logger();

late final objectbox_g.Store? store; // Declare the store

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized

  store = await objectbox_utils.openStore(); // Initialize the store

  runApp(ReCall(
      contactRepository:
          ContactRepository(store))); // Pass the store to the repository
  logger.i('LOG:App started');
}
