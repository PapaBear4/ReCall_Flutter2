// lib/utils/debug_utils.dart
import 'dart:math'; // Import for Random
import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import 'package:recall/utils/logger.dart'; // Your logger
import 'package:faker/faker.dart'; // Import faker for realistic data
import 'package:recall/models/models.dart'; // Import your models
import 'package:recall/repositories/repositories.dart'; // Import your repositories

class DebugUtils {
  // MARK: - CONTACT GEN
  /// Helper method to generate random contact data
  /// Returns a map with standardized contact data that can be used for both device and app contacts
  static Map<String, dynamic> _generateRandomContact() {
    final random = Random();
    final faker = Faker();

    final String firstName = faker.person.firstName();
    final String lastName = faker.person.lastName();

    // Generate phone numbers
    final String phone1 =
        '${random.nextInt(900) + 100}-${random.nextInt(900) + 100}-${random.nextInt(9000) + 1000}';
    String? phone2;
    if (random.nextDouble() < 0.3) {
      phone2 =
          '${random.nextInt(900) + 100}-${random.nextInt(900) + 100}-${random.nextInt(9000) + 1000}';
    }

    // Generate email addresses
    String? email1;
    String? email2;
    if (random.nextDouble() < 0.7) {
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
        email2 =
            "work.${firstName.toLowerCase()}@${faker.internet.domainName()}";
      }
    }

    // Generate notes
    final hasNotes = random.nextDouble() < 0.3;
    final String? notes = hasNotes
        ? faker.lorem.sentences(random.nextInt(3) + 1).join(' ')
        : null;

    // Other common contact attributes
    final String nickname =
        random.nextDouble() < 0.2 ? faker.person.prefix() : '';
    final bool isActive = random.nextBool();

    // Dates for events/next contact
    final birthMonth = random.nextInt(12) + 1;
    final birthDay = random.nextInt(28) + 1;
    final birthYear = 1950 + random.nextInt(55);
    final DateTime? birthday = random.nextDouble() < 0.6
        ? DateTime(birthYear, birthMonth, birthDay)
        : null;

    final DateTime? anniversary = random.nextDouble() < 0.2
        ? DateTime(1980 + random.nextInt(40), random.nextInt(12) + 1,
            random.nextInt(28) + 1)
        : null;

    final DateTime? nextContact = random.nextDouble() < 0.7
        ? DateTime.now().add(Duration(days: random.nextInt(60) - 30))
        : null;

    // Return a standardized map with all the generated data
    return {
      'firstName': firstName,
      'lastName': lastName,
      'nickname': nickname,
      'phone1': phone1,
      'phone2': phone2,
      'email1': email1,
      'email2': email2,
      'notes': notes,
      'isActive': isActive,
      'birthday': birthday,
      'anniversary': anniversary,
      'nextContact': nextContact,
      'importance': random.nextInt(5) + 1,
      'contactFrequency': random.nextInt(90) + 1,
      'company': random.nextDouble() < 0.4 ? faker.company.name() : null,
      'jobTitle': random.nextDouble() < 0.4 ? faker.job.title() : null,
      'address':
          random.nextDouble() < 0.4 ? faker.address.streetAddress() : null,
      'city': random.nextDouble() < 0.4 ? faker.address.city() : null,
      'state': random.nextDouble() < 0.4 ? faker.address.state() : null,
      'postalCode': random.nextDouble() < 0.4 ? faker.address.zipCode() : null,
      'website': random.nextDouble() < 0.15
          ? "https://www.${firstName.toLowerCase()}${lastName.toLowerCase()}.com"
          : null,
    };
  }

  // MARK: - ADD Device
  /// Adds a specified number of sample contacts to the device's address book.
  /// Only runs in debug mode and requires contact write permission.
  /// Returns a status message string.
  static Future<String> addSampleDeviceContacts({int count = 10}) async {
    if (!kDebugMode) {
      logger.w("Attempted to call debug function in non-debug mode.");
      return "Error: Cannot run in release mode.";
    }
    if (count <= 0) {
      logger.w("Invalid count for sample device contacts: $count");
      return "Info: Please enter a positive number of contacts to create.";
    }

    int successCount = 0;
    int failCount = 0;
    String statusMessage = "Initialization error."; // Default status

    logger.d("Starting addSampleDeviceContacts with count: $count");

    try {
      // Request write permission
      logger.d("Requesting write contacts permission...");
      if (!await fc.FlutterContacts.requestPermission(readonly: false)) {
        logger.w("Write Contacts permission denied for debug function.");
        return "Permission Denied: Cannot write contacts.";
      }

      logger.i(
          "Write contacts permission granted. Attempting to insert $count debug contacts...");

      for (int i = 0; i < count; i++) {
        logger.d("Generating contact data for contact ${i + 1}/$count...");
        // Get random contact data from the helper method
        final contactData = _generateRandomContact();
        logger.d(
            "Generated data for ${contactData['firstName']} ${contactData['lastName']}: $contactData");

        // Build device contact using the generated data
        List<fc.Website> websites = [];
        if (contactData['website'] != null) {
          websites.add(fc.Website(contactData['website'],
              label: fc.WebsiteLabel.homepage));
        }

        List<fc.Address> addresses = [];
        if (contactData['address'] != null) {
          addresses.add(fc.Address(
            contactData['address'],
            city: contactData['city'] ?? '', // Provide default empty string
            state: contactData['state'] ?? '', // Provide default empty string
            postalCode: contactData['postalCode'] ?? '', // Provide default empty string
            label: fc.AddressLabel.home,
          ));
        }

        List<fc.Event> events = [];
        if (contactData['birthday'] != null) {
          final birthday = contactData['birthday'] as DateTime;
          events.add(fc.Event(
            year: birthday.year,
            month: birthday.month,
            day: birthday.day,
            label: fc.EventLabel.birthday,
          ));
        }
        if (contactData['anniversary'] != null) {
          final anniversary = contactData['anniversary'] as DateTime;
          events.add(fc.Event(
            year: anniversary.year,
            month: anniversary.month,
            day: anniversary.day,
            label: fc.EventLabel.anniversary,
          ));
        }

        List<fc.Note> notes = [];
        if (contactData['notes'] != null) {
          notes.add(fc.Note(contactData['notes']));
        }

        final contact = fc.Contact(
          name: fc.Name(
            first: contactData['firstName'],
            last: contactData['lastName'],
            nickname: contactData['nickname'] ?? '', // Provide default empty string
          ),
          phones: [
            fc.Phone(contactData['phone1'], label: fc.PhoneLabel.mobile),
            if (contactData['phone2'] != null)
              fc.Phone(contactData['phone2'], label: fc.PhoneLabel.home),
          ],
          emails: [
            if (contactData['email1'] != null)
              fc.Email(contactData['email1'], label: fc.EmailLabel.home),
            if (contactData['email2'] != null)
              fc.Email(contactData['email2'], label: fc.EmailLabel.work),
          ],
          websites: websites,
          addresses: addresses,
          events: events,
          notes: notes,
          organizations: (contactData['company'] != null &&
                  contactData['jobTitle'] != null)
              ? [
                  fc.Organization(
                    company: contactData['company']!,
                    title: contactData['jobTitle']!,
                  ),
                ]
              : [],
        );

        try {
          logger.d(
              "Attempting to insert contact: ${contact.displayName}");
          await fc.FlutterContacts.insertContact(contact);
          successCount++;
          logger.i(
              "Successfully inserted contact ${successCount}/${count}: ${contact.displayName}");
        } catch (e, s) {
          failCount++;
          logger.e(
              "Failed to insert debug contact ${contactData['firstName']} ${contactData['lastName']}: $e",
              error: e,
              stackTrace: s);
        }
      }

      statusMessage = "Debug contacts: $successCount added, $failCount failed.";
      logger.i(statusMessage);
    } catch (e, s) {
      logger.e("Error during debug contact creation process: $e",
          error: e, stackTrace: s);
      statusMessage = "Error adding debug contacts: $e";
    }
    logger.d("Finished addSampleDeviceContacts. Returning: $statusMessage");
    return statusMessage;
  }

  // MARK: - ADD App
  /// Adds a specified number of sample contacts to the app's database.
  /// Only runs in debug mode.
  /// Returns a list of added contacts.
  static Future<List<Contact>> addSampleAppContacts(
      ContactRepository contactRepo,
      {int count = 10}) async {
    if (!kDebugMode) {
      logger.w("Attempted to call debug function in non-debug mode.");
      throw Exception("Cannot run in release mode");
    }

    if (count <= 0) {
      logger.w("Invalid count for sample contacts: $count");
      throw Exception("Please enter a positive number of contacts to create");
    }

    List<Contact> contacts = [];
    final random = Random();

    try {
      logger.d("Generating $count sample contacts for app database...");

      // Define contact frequencies to choose from
      final List<String> frequencies = [
        ContactFrequency.daily.name,
        ContactFrequency.weekly.name,
        ContactFrequency.biweekly.name,
        ContactFrequency.monthly.name,
        ContactFrequency.quarterly.name,
        ContactFrequency.yearly.name,
        ContactFrequency.rarely.name,
        ContactFrequency.never.name,
      ];

      for (int i = 0; i < count; i++) {
        // Get random contact data from the helper method
        final contactData = _generateRandomContact();

        // Pick a random frequency from the list
        final frequency = frequencies[random.nextInt(frequencies.length)];

        // Create app contact model from the generated data
        List<String>? emails;
        if (contactData['email1'] != null) {
          emails = [contactData['email1']];
          if (contactData['email2'] != null) {
            emails.add(contactData['email2']);
          }
        }

        final contact = Contact(
          firstName: contactData['firstName'],
          lastName: contactData['lastName'],
          nickname: contactData['nickname'].isNotEmpty
              ? contactData['nickname']
              : null,
          emails: emails,
          phoneNumber: contactData['phone1'],
          isActive: contactData['isActive'],
          notes: contactData['notes'],
          frequency: frequency,
          birthday: contactData['birthday'],
          anniversary: contactData['anniversary'],
          lastContacted: random.nextDouble() < 0.5
              ? DateTime.now().subtract(Duration(days: random.nextInt(30)))
              : null,
          nextContact: contactData['nextContact'],
        );

        contacts.add(contact);
      }

      // Add all contacts to the database
      final addedContacts = await contactRepo.addMany(contacts);

      logger.i("Added ${addedContacts.length} sample contacts successfully");
      return addedContacts;
    } catch (e) {
      logger.e("Error during sample app contact creation: $e");
      throw Exception("Error adding sample app contacts: $e");
    }
  }

  // MARK: - CLEAR ALL
  /// Clears all data stored in the app's database (ObjectBox via repositories).
  /// Only runs in debug mode.
  /// Requires ContactRepository and UserSettingsRepository instances.
  /// Returns a status message string.
  static Future<String> clearAppDatabase(ContactRepository contactRepo,
      UserSettingsRepository settingsRepo) async {
    if (!kDebugMode) {
      logger.w("Attempted to call debug function in non-debug mode.");
      return "Error: Cannot run in release mode.";
    }

    logger.d("Attempting to clear app database (ObjectBox)...");
    try {
      final int contactCount = await contactRepo.count();

      await contactRepo.deleteAll();
      logger.i("Deleted $contactCount contacts from ObjectBox.");

      await settingsRepo.deleteAll();
      logger.i("Cleared user settings from ObjectBox.");

      return "App database cleared ($contactCount contacts deleted, settings cleared, notifications cancelled).";
    } catch (e) {
      logger.e("Error clearing app database: $e");
      return "Error clearing app database: $e";
    }
  }
}
