// lib/utils/backup_restore_utils.dart
import 'dart:convert';
import 'package:recall/models/contact.dart';
import 'package:recall/models/usersettings.dart';
import 'package:recall/repositories/contact_repository.dart'; // Import repository
import 'package:recall/repositories/usersettings_repository.dart'; // Import repository
import 'package:recall/utils/logger.dart'; // Adjust path if needed

// Define the return type as a record for clarity
typedef BackupData = ({UserSettings? settings, List<Contact>? contacts});

/// Parses the backup JSON string with simplified version 1 format.
///
/// Returns a record containing the parsed UserSettings and the list of Contacts.
/// Returns null for settings or contacts if parsing/validation fails.
BackupData parseAndMigrateBackupData(String jsonData) {
  try {
    final decoded = jsonDecode(jsonData);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid format: Expected a JSON object.');
    }

    // Simple version check - we only support version 1 now
    final version = decoded['version'] as int? ?? 1; // Default to version 1
    
    if (version != 1) {
      logger.w('Warning: Backup version $version is not supported. Attempting to parse as version 1.');
    }

    UserSettings? parsedSettings;
    List<Contact>? parsedContacts;

    // --- Parse Settings ---
    if (decoded.containsKey('userSettings')) {
      final settingsData = decoded['userSettings'];
      if (settingsData is Map<String, dynamic>) {
        parsedSettings = UserSettings.fromJson(settingsData);
      } else {
        logger.w(
            'Warning: "userSettings" key present but not a valid object. Settings will not be restored.');
      }
    } else {
      logger.w(
          'Warning: "userSettings" key is missing. Settings will not be restored.');
    }

    // --- Parse Contacts ---
    final contactsData = decoded['contacts'];
    if (contactsData is! List) {
      throw const FormatException(
          'Invalid format: Expected "contacts" to be a list.');
    }

    List<Contact> parsedContactsList = [];
    for (final contactMap in contactsData) {
      if (contactMap is! Map<String, dynamic>) {
        logger.w('Skipping invalid contact entry: $contactMap');
        continue; // Skip invalid entries
      }

      // Simply parse contacts using the current model
      try {
        Contact contact = Contact.fromJson(contactMap);
        parsedContactsList.add(contact);
      } catch (e) {
        logger.w('Error parsing contact: $e');
        // Skip invalid entries
      }
    }
    parsedContacts = parsedContactsList;

    // Return parsed data
    return (settings: parsedSettings, contacts: parsedContacts);
  } on FormatException catch (e) {
    logger.e("Restore Format Error: ${e.message}");
    return (settings: null, contacts: null);
  } catch (e) {
    logger.e("Restore Error: $e");
    return (settings: null, contacts: null);
  }
}

/// Fetches current contacts and settings and prepares a JSON string for backup.
/// Uses simplified version 1 format.
/// Returns null if fetching settings fails.
Future<String?> prepareBackupData({
  required ContactRepository contactRepo,
  required UserSettingsRepository settingsRepo,
}) async {
  try {
    final List<Contact> contacts = await contactRepo.getAll();
    // Fetch current settings - assuming ID 1 or load the only one
    final List<UserSettings> currentSettingsList = await settingsRepo.getAll();
    final UserSettings? currentSettings =
        currentSettingsList.isNotEmpty ? currentSettingsList.first : null;

    if (currentSettings == null) {
      logger.e('Error preparing backup: Could not fetch UserSettings.');
      return null;
    }

    // Structure for export (using version 1)
    Map<String, dynamic> backupData = {
      'version': 1, // Mark backups with simplified version 1
      'userSettings': currentSettings.toJson(),
      'contacts': contacts.map((contact) => contact.toJson()).toList(),
    };
    // Use JsonEncoder for pretty printing
    String jsonString = const JsonEncoder.withIndent('  ').convert(backupData);
    return jsonString;
  } catch (e) {
    logger.e('Error preparing backup data: $e');
    return null;
  }
  //TODO: Update backup file name to use a timestamp so I don't 
  //keep saving over the old one
}
