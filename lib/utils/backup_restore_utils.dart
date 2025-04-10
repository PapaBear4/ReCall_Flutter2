// lib/utils/backup_restore_utils.dart
import 'dart:convert';
import 'package:recall/models/contact.dart';
import 'package:recall/models/usersettings.dart';
import 'package:recall/repositories/contact_repository.dart'; // Import repository
import 'package:recall/repositories/usersettings_repository.dart'; // Import repository
import 'package:recall/utils/logger.dart'; // Adjust path if needed

// Define the return type as a record for clarity
typedef BackupData = ({UserSettings? settings, List<Contact>? contacts});

/// Parses the backup JSON string, handling different versions and migrating
/// contacts from version 2 (map format) to version 3+ (individual fields format).
///
/// Returns a record containing the parsed UserSettings and the list of Contacts.
/// Returns null for settings or contacts if parsing/validation fails.
BackupData parseAndMigrateBackupData(String jsonData) {
  try {
    final decoded = jsonDecode(jsonData);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid format: Expected a JSON object.');
    }

    // Determine version (default to 2 if 'version' key is missing for older backups)
    // V3 is the previous version. Assume V4 for the new fields.
    final version =
        decoded['version'] as int? ?? 2; // Assume version 2 if key missing

    UserSettings? parsedSettings;
    List<Contact>? parsedContacts;

    // --- Parse Settings (Common to v2+) ---
    if (decoded.containsKey('userSettings')) {
      final settingsData = decoded['userSettings'];
      if (settingsData is Map<String, dynamic>) {
        parsedSettings = UserSettings.fromJson(settingsData);
      } else {
        logger.w(
            'Warning: "userSettings" key present but not a valid object. Settings will not be restored.');
      }
    } else if (version >= 2) {
      logger.w(
          'Warning: Backup version $version expects "userSettings", but key is missing. Settings will not be restored.');
    }

    // --- Parse Contacts ---
    final contactsData = decoded['contacts'];
    if (contactsData is! List) {
      throw const FormatException(
          'Invalid format: Expected "contacts" to be a list.');
    }

    List<Contact> migratedContacts = [];
    for (final contactMap in contactsData) {
      if (contactMap is! Map<String, dynamic>) {
        logger.w('Skipping invalid contact entry: $contactMap');
        continue; // Skip invalid entries
      }

      // --- Handle Version 4 (or later if identical structure) ---
      // Contact.fromJson should now handle the new fields directly if they exist.
      // It also handles the removal of tikTokHandle gracefully.
      if (version == 4) {
        // Assuming version 4 includes the new fields
        migratedContacts.add(Contact.fromJson(contactMap)); // [cite: 6]
      }
      // --- Handle Version 3 (Previous Format) ---
      else if (version == 3) {
        // fromJson works, but new fields (nickname, xHandle, linkedInUrl) will be null
        Contact contactV3 = Contact.fromJson(contactMap); // [cite: 6]
        // tikTokHandle is ignored by the new fromJson if present in the v3 data.
        migratedContacts.add(contactV3);
      }
      // --- Handle Version 2 (Map Format) ---
      else if (version == 2) {
        // 1. Parse basic data (fromJson will ignore the map field)
        Contact basicContact = Contact.fromJson(contactMap);

        // 2. Extract the old map (handle potential nulls/type errors)
        final Map<String, dynamic>? oldSocialMap =
            contactMap['socialMediaHandles'] as Map<String, dynamic>?;

        // 3. Migrate data using copyWith
        if (oldSocialMap != null) {
          // Define the mapping from old keys to new field names.
          // Adjust keys ('youtubeUrl', etc.) if they were different in your V2 map.
          basicContact = basicContact.copyWith(
            youtubeUrl: oldSocialMap['youtubeUrl']?.toString(),
            instagramHandle: oldSocialMap['instagramHandle']?.toString(),
            facebookUrl: oldSocialMap['facebookUrl']?.toString(),
            snapchatHandle: oldSocialMap['snapchatHandle']?.toString(),
          );
        }
        migratedContacts.add(basicContact);
      } else {
        logger
            .w('Skipping contact due to unsupported backup version: $version');
      }
    }
    parsedContacts = migratedContacts;

    // Return parsed data
    return (settings: parsedSettings, contacts: parsedContacts);
  } on FormatException catch (e) {
    logger.e("Restore Format Error: ${e.message}");
    // Consider how to propagate errors - maybe return specific error state or throw?
    // For now, returning nulls as before.
    return (settings: null, contacts: null);
  } catch (e) {
    logger.e("Restore Error: $e");
    return (settings: null, contacts: null);
  }
}

/// Fetches current contacts and settings and prepares a JSON string for backup.
/// Includes version number for future compatibility.
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
      // Decide how to handle this - throw error or return null? Returning null for now.
      return null;
    }

    // Structure for export (using version 3)
    Map<String, dynamic> backupData = {
      'version': 4, // Mark backups with current version
      'userSettings': currentSettings.toJson(),
      'contacts': contacts.map((contact) => contact.toJson()).toList(),
    };
    // Use JsonEncoder for pretty printing
    String jsonString = const JsonEncoder.withIndent('  ').convert(backupData);
    return jsonString;
  } catch (e) {
    logger.e('Error preparing backup data: $e');
    // Propagate error or return null
    return null;
  }
  //TODO: Update backup file name to use a timestamp so I don't 
  //keep saving over the old one
}
