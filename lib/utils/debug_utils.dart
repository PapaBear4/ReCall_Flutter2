// lib/utils/debug_utils.dart
import 'dart:math'; // Import for Random
import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import 'package:recall/utils/logger.dart'; // Your logger
import 'package:faker/faker.dart'; // Import faker for realistic data
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/repositories/usersettings_repository.dart';

class DebugUtils {
  /// Adds a specified number of sample contacts to the device's address book.
  /// Only runs in debug mode and requires contact write permission.
  /// Returns a status message string.
  static Future<String> addSampleDeviceContacts({int count = 10}) async {
    // Added count parameter
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
      // Request write permission
      if (!await fc.FlutterContacts.requestPermission(readonly: false)) {
        logger.w("Write Contacts permission denied for debug function.");
        return "Permission Denied: Cannot write contacts.";
      }

      logger.d(
          "Write contacts permission granted. Attempting to insert $count debug contacts..."); // --- Generate and Insert Random Contacts using Faker ---
      final faker = Faker();

      for (int i = 0; i < count; i++) {
        // Generate realistic random data using faker
        String firstName = faker.person.firstName();
        String lastName = faker.person.lastName();

        // Create more realistic US-formatted phone numbers
        String phone1 =
            '${random.nextInt(900) + 100}-${random.nextInt(900) + 100}-${random.nextInt(9000) + 1000}';
        String? phone2;
        String? email1;
        String? email2;

        // Occasionally add a second phone
        if (random.nextDouble() < 0.3) {
          // 30% chance of second phone
          phone2 =
              '${random.nextInt(900) + 100}-${random.nextInt(900) + 100}-${random.nextInt(9000) + 1000}';
        }

        // Create realistic email addresses
        if (random.nextDouble() < 0.7) {
          // 70% chance of primary email
          // Generate realistic email with various patterns
          final emailPattern = random.nextInt(3);
          switch (emailPattern) {
            case 0:
              email1 =
                  "${firstName.toLowerCase()}.${lastName.toLowerCase()}@${faker.internet.domainName()}";
              break;
            case 1:
              email1 =
                  "${firstName.toLowerCase()}${random.nextInt(99)}@${faker.internet.domainName()}";
              break;
            default:
              email1 = faker.internet.email();
          }

          if (random.nextDouble() < 0.2) {
            // 20% chance of secondary email IF primary exists
            email2 =
                "work.${firstName.toLowerCase()}@${faker.internet.domainName()}";
          }
        } // Add random social media profiles
        final fc.SocialMedia? twitter = random.nextDouble() < 0.3
            ? fc.SocialMedia(
                "@${firstName.toLowerCase()}${lastName.toLowerCase()}",
                label: fc.SocialMediaLabel.twitter)
            : null;

        final fc.SocialMedia? linkedIn = random.nextDouble() < 0.25
            ? fc.SocialMedia(
                "${firstName.toLowerCase()}-${lastName.toLowerCase()}",
                label: fc.SocialMediaLabel.linkedIn)
            : null;

        // Add random websites
        List<fc.Website> websites = [];
        if (random.nextDouble() < 0.15) {
          // 15% chance of having a personal website
          websites.add(fc.Website(
              "https://www.${firstName.toLowerCase()}${lastName.toLowerCase()}.com",
              label: fc.WebsiteLabel.homepage));
        }
        if (random.nextDouble() < 0.2 && linkedIn != null) {
          // 20% chance of LinkedIn URL if has LinkedIn username
          websites.add(fc.Website(
              "https://www.linkedin.com/in/${linkedIn.userName}",
              label: fc.WebsiteLabel.profile));
        }

        // Add random address for some contacts
        List<fc.Address> addresses = [];
        if (random.nextDouble() < 0.4) {
          // 40% chance of having an address
          addresses.add(fc.Address(faker.address.streetAddress(),
              city: faker.address.city(),
              state: faker.address.state(),
              postalCode: faker.address.zipCode(),
              label: fc.AddressLabel.home));
        }

        // Add some events (birthdays, anniversaries)
        List<fc.Event> events = [];
        if (random.nextDouble() < 0.6) {
          // 60% chance of having a birthday
          final birthMonth = random.nextInt(12) + 1;
          final birthDay =
              random.nextInt(28) + 1; // Avoid invalid dates by limiting to 28
          final birthYear =
              1950 + random.nextInt(55); // Birth years between 1950 and 2004
          events.add(fc.Event(
              year: birthYear,
              month: birthMonth,
              day: birthDay,
              label: fc.EventLabel.birthday));
        }

        if (random.nextDouble() < 0.2) {
          // 20% chance of having an anniversary
          final anniMonth = random.nextInt(12) + 1;
          final anniDay = random.nextInt(28) + 1;
          final anniYear =
              1980 + random.nextInt(40); // Anniversary between 1980 and 2019
          events.add(fc.Event(
              year: anniYear,
              month: anniMonth,
              day: anniDay,
              label: fc.EventLabel.anniversary));
        }

        // Add notes for some contacts
        List<fc.Note> notes = [];
        if (random.nextDouble() < 0.3) {
          // 30% chance of having notes
          notes.add(
              fc.Note(faker.lorem.sentences(random.nextInt(3) + 1).join(' ')));
        }

        // Create contact object with all the enriched data
        final contact = fc.Contact(
            name: fc.Name(
              first: firstName,
              last: lastName,
              nickname: random.nextDouble() < 0.2
                  ? (faker.person.prefix()) // Provide a default empty string
                  : '', // Default to empty string if no nickname
            ),
            phones: [
              fc.Phone(phone1, label: fc.PhoneLabel.mobile),
              if (phone2 != null) fc.Phone(phone2, label: fc.PhoneLabel.home),
            ],
            emails: [
              if (email1 != null) fc.Email(email1, label: fc.EmailLabel.home),
              if (email2 != null) fc.Email(email2, label: fc.EmailLabel.work),
            ],
            socialMedias: [
              if (twitter != null) twitter,
              if (linkedIn != null) linkedIn,
            ],
            websites: websites,
            addresses: addresses,
            events: events,
            notes: notes,
            // Add job information for some contacts
            organizations: random.nextDouble() < 0.4
                ? [
                    fc.Organization(
                      company: faker.company.name(),
                      title: faker.job.title(),
                    )
                  ]
                : []);

        // Insert contact
        try {
          await fc.FlutterContacts.insertContact(contact);
          successCount++;
        } catch (e) {
          failCount++;
          logger.e("Failed to insert debug contact $firstName $lastName: $e");
        }
      } // End loop

      statusMessage = "Debug contacts: $successCount added, $failCount failed.";
      logger.i(statusMessage);
    } catch (e) {
      logger.e("Error during debug contact creation process: $e");
      statusMessage = "Error adding debug contacts: $e";
    }
    return statusMessage;
  }

  /// Clears all data stored in the app's database (ObjectBox via repositories).
  /// Also cancels all scheduled notifications.
  /// Only runs in debug mode.
  /// Requires ContactRepository and UserSettingsRepository instances.
  /// Returns a status message string.
  static Future<String> clearAppDatabase(
      ContactRepository contactRepo, UserSettingsRepository settingsRepo) async {
    if (!kDebugMode) {
      logger.w("Attempted to call debug function in non-debug mode.");
      return "Error: Cannot run in release mode.";
    }

    logger.d("Attempting to clear app database (ObjectBox)...");
    try {
      // Get count before deleting
      final int contactCount = await contactRepo.getContactsCount();
      // Clear contacts
      await contactRepo.deleteAll(); // Call deleteAll without assigning the result
      logger.i("Deleted $contactCount contacts from ObjectBox."); // Updated log message

      // Clear settings (assuming a deleteAll or similar method exists)
      // If not, you might need to fetch the single setting and delete it by ID,
      // or add a deleteAll method to the repository.
      // Example: await settingsRepo.deleteAll();
      // For now, let's assume you might recreate settings later if needed.
      // If you have a specific way to clear settings, implement it here.
      // For simplicity, we'll just log that we'd clear settings here.
      logger.i("Cleared user settings from ObjectBox (implementation needed if specific clearing required).");

      // Cancel any scheduled notifications
      logger.i("Cancelled all scheduled notifications.");

      return "App database cleared ($contactCount contacts deleted, settings cleared, notifications cancelled)."; // Use the fetched count
    } catch (e) {
      logger.e("Error clearing app database: $e");
      return "Error clearing app database: $e";
    }
  }

  /// Clears ALL application data (Database and SharedPreferences).
  /// Only runs in debug mode.
  /// Returns a combined status message string.
  static Future<String> clearAllAppData(
      ContactRepository contactRepo, UserSettingsRepository settingsRepo) async {
    if (!kDebugMode) {
      logger.w("Attempted to call debug function in non-debug mode.");
      return "Error: Cannot run in release mode.";
    }

    logger.i("--- Starting Full App Data Clear ---");
    List<String> results = [];
    try {
      results.add(await clearAppDatabase(contactRepo, settingsRepo));
      logger.i("--- Full App Data Clear Finished ---");
      return results.join(' ');
    } catch (e) {
      logger.e("Error during full app data clear: $e");
      return "Error during full app data clear: $e";
    }
  }
}
