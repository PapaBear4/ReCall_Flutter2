// lib/utils/debug_utils.dart
import 'dart:math'; // Import for Random
import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import 'package:recall/models/enums.dart';
import 'package:recall/utils/logger.dart'; // Your logger
import 'package:faker/faker.dart'; // Import faker for realistic data
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/repositories/usersettings_repository.dart';
import 'package:recall/models/contact.dart' as app_contact;
import 'package:recall/utils/contact_utils.dart'; // Import ContactUtils

class DebugUtils {
  // MARK: FAKE CNTCT
  /// Generates a fake contact mapped to the device (fc) Contact model.
  /// Each fake contact has a random name, phone number, email, events, and notes.
  static fc.Contact _generateFakeFlutterContact(Faker faker, Random random) {
    return fc.Contact(
      name: fc.Name(
        first: faker.person.firstName(),
        last: faker.person.lastName(),
        nickname: random.nextDouble() < 0.2
            ? faker.animal.name()
            : '', // 20% chance for nickname
      ),
      phones: List.generate(
        random.nextInt(3) + 1, // Generate 1 to 3 phone numbers
        (index) => fc.Phone(
          '${random.nextInt(900) + 100}-${random.nextInt(900) + 100}-${random.nextInt(9000) + 1000}',
          label: index == 0 ? fc.PhoneLabel.mobile : fc.PhoneLabel.home,
        ),
      ),
      emails: List.generate(
        random.nextInt(3) + 1, // Generate 1 to 3 emails
        (index) => fc.Email(
          "${faker.person.firstName().toLowerCase()}${index + 1}@${faker.internet.domainName()}",
          label: index == 0 ? fc.EmailLabel.home : fc.EmailLabel.work,
        ),
      ),
      events: [
        if (random.nextBool())
          fc.Event(
            year:
                random.nextInt(50) + 1970, // Random year between 1970 and 2020
            month: random.nextInt(12) + 1, // Random month
            day: random.nextInt(28) + 1, // Random day
            label: fc.EventLabel.birthday,
          ),
        if (random.nextBool())
          fc.Event(
            year: random.nextInt(50) + 1970,
            month: random.nextInt(12) + 1,
            day: random.nextInt(28) + 1,
            label: fc.EventLabel.anniversary,
          ),
      ],
      notes: List.generate(
        random.nextInt(2), // Generate 0 to 1 notes
        (index) => fc.Note(
          faker.lorem.sentence(),
        ),
      ),
    );
  }

  /// Generates a fake contact for the app's database.
  /// Maps the FlutterContacts contact to the app's Contact model and adds random
  /// frequency and dates.
  // MARK: FAKE ApCNT
  static app_contact.Contact _generateFakeAppContact(
      Faker faker, Random random, String defaultFrequency) {
    final fcContact = _generateFakeFlutterContact(faker, random);
    final fakeAppContact =
        ContactUtils.mapContactDeviceToApp(fcContact, defaultFrequency);

    // Add a random frequency to the contact
    final List<ContactFrequency> frequencies = ContactFrequency.values;
    final randomFrequency =
        frequencies[random.nextInt(frequencies.length)].value;

    // Add a random last contacted date (between today and today minus the selected frequency)
    final DateTime now = DateTime.now();
    final int daysAgo =
        random.nextInt(60); // Random number of days in the past (up to 60 days)
    final DateTime lastContactDate = now.subtract(Duration(days: daysAgo));
    final bool isActive = random.nextBool();

    // Calculate the next contact date based on the last contacted date and the frequency
    final DateTime nextContactDate = calculateNextContactDate(fakeAppContact
        .copyWith(frequency: randomFrequency, lastContactDate: lastContactDate));

    // Return the updated contact with the new fields
    return fakeAppContact.copyWith(
      frequency: randomFrequency,
      lastContactDate: lastContactDate,
      nextContactDate: nextContactDate,
      isActive: isActive
    );
  }

  /// Adds a specified number of sample contacts directly to the app's database.
  // MARK: ADD TO APP
  static Future<String> addSampleAppContacts(ContactRepository contactRepo,
      {int count = 10}) async {
    if (!kDebugMode) {
      logger.w("Attempted to call debug function in non-debug mode.");
      return "Error: Cannot run in release mode.";
    }
    if (count <= 0) {
      return "Info: Please enter a positive number of contacts to create.";
    }

    int successCount = 0;
    int failCount = 0;
    final faker = Faker();
    final random = Random();
    final String defaultFrequency = ContactFrequency.defaultValue;

    logger.d(
        "Attempting to insert $count debug contacts into the app database...");
    for (int i = 0; i < count; i++) {
      final contact = _generateFakeAppContact(faker, random, defaultFrequency);
      try {
        await contactRepo.add(contact);
        successCount++;
      } catch (e) {
        failCount++;
        logger.e("Failed to insert app contact: $e");
      }
    }

    final statusMessage =
        "App contacts: $successCount added, $failCount failed.";
    logger.i(statusMessage);
    return statusMessage;
  }

  /// Adds a specified number of sample contacts to the device's address book.
  // MARK: ADD TO DEVICE
  static Future<String> addSampleDeviceContacts({int count = 10}) async {
    if (!kDebugMode) {
      logger.w("Attempted to call debug function in non-debug mode.");
      return "Error: Cannot run in release mode.";
    }
    if (count <= 0) {
      return "Info: Please enter a positive number of contacts to create.";
    }

    int successCount = 0;
    int failCount = 0;
    String statusMessage;
    final random = Random();

    try {
      if (!await fc.FlutterContacts.requestPermission(readonly: false)) {
        logger.w("Write Contacts permission denied for debug function.");
        return "Permission Denied: Cannot write contacts.";
      }

      logger.d(
          "Write contacts permission granted. Attempting to insert $count debug contacts...");
      final faker = Faker();

      for (int i = 0; i < count; i++) {
        final deviceContact = _generateFakeFlutterContact(faker, random);
        try {
          await fc.FlutterContacts.insertContact(deviceContact);
          successCount++;
        } catch (e) {
          failCount++;
          logger.e("Failed to insert debug contact: $e");
        }
      }

      statusMessage = "Debug contacts: $successCount added, $failCount failed.";
      logger.i(statusMessage);
    } catch (e) {
      logger.e("Error during debug contact creation process: $e");
      statusMessage = "Error adding debug contacts: $e";
    }
    return statusMessage;
  }

  /// MARK: CLEAR APP
  /// Clears all application data (Database, SharedPreferences, and Notifications).
  /// Only runs in debug mode.
  /// Returns a status message string.
  static Future<String> clearAppData(ContactRepository contactRepo,
      UserSettingsRepository settingsRepo) async {
    if (!kDebugMode) {
      logger.w("Attempted to call debug function in non-debug mode.");
      return "Error: Cannot run in release mode.";
    }

    logger.i("--- Starting App Data Clear ---");
    try {
      // Clear contacts from the database
      final int contactCount = await contactRepo.getContactsCount();
      await contactRepo.deleteAll();
      logger.i("Deleted $contactCount contacts from ObjectBox.");

      // Clear user settings
      await settingsRepo.deleteAll();
      logger.i("Cleared user settings from ObjectBox.");

      // Cancel all scheduled notifications
      logger.i("Cancelled all scheduled notifications.");

      logger.i("--- App Data Clear Finished ---");
      return "App data cleared ($contactCount contacts deleted, settings cleared, notifications cancelled).";
    } catch (e) {
      logger.e("Error during app data clear: $e");
      return "Error during app data clear: $e";
    }
  }
}
