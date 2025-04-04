// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Use provider to read repository
import 'package:recall/models/contact_frequency.dart';
import 'package:recall/models/usersettings.dart';
import 'package:recall/repositories/usersettings_repository.dart';
import 'package:recall/repositories/contact_repository.dart'; // To get contacts
import 'package:recall/models/contact.dart'; // Contact model
import 'dart:convert'; // For JSON encoding
import 'dart:io'; // For File operations
import 'dart:typed_data'; // For Uint8List
import 'package:file_picker/file_picker.dart'; // For saving
import 'package:path_provider/path_provider.dart'; // For temp directory
import 'package:share_plus/share_plus.dart'; // For sharing
import 'package:recall/blocs/contact_list/contact_list_bloc.dart'; // To refresh list
import 'package:recall/services/notification_helper.dart';
import 'package:recall/services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  UserSettings? _userSettings;
  bool _isLoading = true;
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    if (!mounted) return; // Check mounted before setState
    setState(() {
      _isLoading = true;
    });
    try {
      final repository = context.read<UserSettingsRepository>();
      List<UserSettings> settingsList = await repository.getAll();
      UserSettings settings;
      if (settingsList.isEmpty) {
        // Create default settings if none exist (first run)
        settings = UserSettings(); // Uses defaults defined in the model
        // Assign an ID (ObjectBox typically manages this, but for the first setting...)
        // A common pattern is to use a fixed ID like 1 for the single settings object
        settings = settings.copyWith(id: 1);
        await repository.add(settings); // Save the default settings
      } else {
        // Load the existing settings (assuming only one settings object)
        settings = settingsList.first;
        // Ensure loaded settings have a default frequency if migrating from older version
        if (settings.defaultFrequency.isEmpty) {
          // Basic check, might need refinement
          settings =
              settings.copyWith(defaultFrequency: ContactFrequency.never.value);
          // Optionally update the repo if loaded settings were incomplete
          // await repository.update(settings);
        }
      }
      if (!mounted) return; // Check mounted again before setState

      setState(() {
        _userSettings = settings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error loading settings (e.g., show a SnackBar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading settings: $e')),
      );
    }
  }

  Future<void> _pickNotificationTime() async {
    if (_userSettings == null) {
      return; // Don't show picker if settings haven't loaded
    }

    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime:
          _userSettings!.notificationTimeOfDay, // Use current time as initial
    );

    if (newTime != null) {
      // User picked a time
      final repository = context.read<UserSettingsRepository>();
      final updatedSettings = _userSettings!.copyWith(
        notificationHour: newTime.hour,
        notificationMinute: newTime.minute,
      );
      try {
        await repository.update(updatedSettings);
        setState(() {
          _userSettings =
              updatedSettings; // Update local state to reflect change
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification time saved')),
        );
      } catch (e) {
        // Handle error saving settings
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving time: $e')),
        );
      }
    }
  }

  // Fetches contacts and converts them to a JSON string
  Future<String?> _prepareBackupData() async {
    if (!mounted) return null;
    setState(() => _isBusy = true);
    try {
      final contactRepo = context.read<ContactRepository>();
      final settingsRepo =
          context.read<UserSettingsRepository>(); // Get settings repo

      final List<Contact> contacts = await contactRepo.getAll();
      // Fetch current settings - assuming ID 1 or load the only one
      final List<UserSettings> currentSettingsList =
          await settingsRepo.getAll();
      final UserSettings? currentSettings =
          currentSettingsList.isNotEmpty ? currentSettingsList.first : null;

      if (currentSettings == null) {
        if (!mounted) return null;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error fetching settings for export.')),
        );
        setState(() => _isBusy = false);
        return null;
      }

      // Structure for export (using version 2)
      Map<String, dynamic> backupData = {
        'version': 2, // Increment version
        'userSettings': currentSettings.toJson(), // Add settings
        'contacts': contacts.map((contact) => contact.toJson()).toList(),
      };
      String jsonString =
          const JsonEncoder.withIndent('  ').convert(backupData);

      if (!mounted) return null;
      setState(() => _isBusy = false);
      return jsonString;
    } catch (e) {
      if (!mounted) return null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error preparing export data: $e')),
      );
      setState(() => _isBusy = false);
      return null;
    }
  }

  // Saves the JSON string using file_picker
  Future<void> _saveBackupFile(String jsonString) async {
    setState(() => _isBusy = true); // Show loading indicator
    try {
      // Convert string to bytes
      Uint8List fileBytes = utf8.encode(jsonString);

      String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Contacts Backup',
        fileName: 'recall_backup.json', // Suggested filename
        bytes: fileBytes,
      );

      if (mounted) {
        // Check if widget is still mounted
        setState(() => _isBusy = false); // Hide loading indicator
        if (outputPath != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Contacts successfully backed upto $outputPath')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Backup cancelled.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isBusy = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving backup file: $e')),
        );
      }
    }
  }

  // Shares the JSON string using share_plus
  Future<void> _shareBackupFile(String jsonString) async {
    setState(() => _isBusy = true); // Show loading indicator
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String tempFilePath = '${tempDir.path}/recall_backup_temp.json';
      final File tempFile = File(tempFilePath);

      await tempFile.writeAsString(jsonString);

      await Share.shareXFiles(
        [XFile(tempFile.path)],
        text: 'reCall App Backup Data',
      );

      // Clean up the temporary file
      await tempFile.delete();

      if (mounted) {
        // Check if widget is still mounted
        setState(() => _isBusy = false); // Hide loading indicator
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isBusy = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing backup file: $e')),
        );
      }
    }
  }

  // Shows the dialog to choose between Save or Share
  Future<void> _showBackupOptions() async {
    // Prepare data first
    final String? jsonString = await _prepareBackupData();

    // If data preparation failed or was cancelled, stop here
    if (jsonString == null || !mounted) return;

    // Show choice dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Backup Contacts & Settings As JSON'),
          content: const Text('Choose how to save the backup file:'),
          actions: <Widget>[
            TextButton(
              child: const Text('Save Backup to Device'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _saveBackupFile(jsonString); // Call save function
              },
            ),
            TextButton(
              child: const Text('Share'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _shareBackupFile(jsonString); // Call share function
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  ({UserSettings? settings, List<Contact>? contacts})
      _parseAndValidateRestoreData(String jsonData) {
    try {
      final decoded = jsonDecode(jsonData);

      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Invalid format: Expected a JSON object.');
      }

      // Check version - handle version 1 (old) and 2 (new)
      final version = decoded['version'];
      UserSettings? parsedSettings;
      List<Contact>? parsedContacts;

      if (version == 2) {
        // Parse settings (new format)
        final settingsData = decoded['userSettings'];
        if (settingsData is! Map<String, dynamic>) {
          throw const FormatException(
              'Invalid format V2: Expected "userSettings" to be an object.');
        }
        // Use generated fromJson, ensure ID is handled later during update
        parsedSettings = UserSettings.fromJson(settingsData);

        // Parse contacts
        final contactsData = decoded['contacts'];
        if (contactsData is! List) {
          throw const FormatException(
              'Invalid format V2: Expected "contacts" to be a list.');
        }
        parsedContacts = contactsData.map((contactMap) {
          if (contactMap is! Map<String, dynamic>) {
            throw FormatException(
                'Invalid format V2: Contact entry is not valid: $contactMap');
          }
          return Contact.fromJson(contactMap);
        }).toList();
      } else if (version == 1) {
        final dynamic contactsData = decoded[
            'contacts']; // Use dynamic or Object? if type is unknown initially
        // Check if 'contactsData' is actually a List
        if (contactsData is List) {
          // It is a list, proceed with parsing contacts
          parsedContacts = contactsData.map((contactMap) {
            if (contactMap is! Map<String, dynamic>) {
              throw FormatException(
                  'Invalid format V1: Contact entry is not valid: $contactMap');
            }
            return Contact.fromJson(contactMap);
          }).toList();
          // No settings in V1 format
          parsedSettings = null;
        } else {
          // If 'contactsData' wasn't a List, the V1 format is invalid
          // No reassignment needed, just throw the error.
          throw const FormatException(
              'Invalid format V1: Expected "contacts" key to contain a list.');
        }
      } else {
        throw FormatException('Unsupported backup version: $version');
      }

      return (settings: parsedSettings, contacts: parsedContacts);
    } on FormatException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Import Error: ${e.message}')),
        );
      }
      return (settings: null, contacts: null); // Indicate failure
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Import Error: $e')),
        );
      }
      return (settings: null, contacts: null); // Indicate failure
    }
  }

  // Orchestrates the import process
  Future<void> _startRestoreProcess() async {
    if (!mounted) return;
    setState(() => _isBusy = true);

    final notificationHelper = NotificationHelper();
    final notificationService = context.read<NotificationService>();
    final contactRepo = context.read<ContactRepository>();
    final settingsRepo =
        context.read<UserSettingsRepository>(); // Get settings repo

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.single.path == null || !mounted) {
        if (mounted) {
          // Check mounted before showing snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Restore cancelled.')),
          );
          setState(() => _isBusy = false);
        }
        return;
      }

      File file = File(result.files.single.path!);
      String jsonData = await file.readAsString();

      // Parse and validate using the updated function
      final parsedData = _parseAndValidateRestoreData(jsonData);
      final UserSettings? settingsFromBackup = parsedData.settings;
      final List<Contact>? contactsFromBackup = parsedData.contacts;

      if (contactsFromBackup == null || !mounted) {
        // Validation/parsing failed, message already shown
        if (mounted) setState(() => _isBusy = false);
        return;
      }
            // Show confirmation dialog before overwriting
       final bool confirmRestore = await showDialog<bool>(
          context: context,
          barrierDismissible: false, // User must tap button
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Restore'),
              content: const Text('Restoring will replace ALL current contacts and settings with the data from the backup file. This cannot be undone. Are you sure?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () { Navigator.of(context).pop(false); },
                ),
                TextButton(
                  child: const Text('Restore', style: TextStyle(color: Colors.red)),
                  onPressed: () { Navigator.of(context).pop(true); },
                ),
              ],
            );
          },
       ) ?? false; // Default to false if dialog dismissed

       if (!confirmRestore || !mounted) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('Restore cancelled.')), );
            setState(() => _isBusy = false);
          }
          return;
       }


      // --- Overwrite Data and Notifications ---
      // Update Settings if present in import file (Overwrite strategy)
      int currentSettingsId = 1; // Assuming settings always have ID 1
      if (settingsFromBackup != null) {
        try {
          // Ensure imported settings get the correct persistent ID
          final settingsToSave =
              settingsFromBackup.copyWith(id: currentSettingsId);
          await settingsRepo.update(settingsToSave);
          if (!mounted) return; // Check after await
          // Update local state to reflect imported settings immediately
          setState(() {
            _userSettings = settingsToSave;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Settings restored successfully.')),
          );
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error restoring settings: $e')),
          );
          // Decide whether to continue contact import if settings fail
        }
      }

      // Proceed with contact import (remains the same)
      await notificationHelper.cancelAllNotifications();
      await contactRepo.deleteAll();
      final List<Contact> addedContacts =
          await contactRepo.addMany(contactsFromBackup);
      for (final contact in addedContacts) {
        await notificationService.scheduleReminder(contact);
      }
      notificationLogger.i(
          'LOG: Scheduled notifications for ${addedContacts.length} restored contacts.');

      // --- Show Final Success & Refresh ---
      if (!mounted) return; // Final check
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Successfully restored ${addedContacts.length} contacts.')),
      );
      context
          .read<ContactListBloc>()
          .add(const ContactListEvent.loadContacts());
      setState(() => _isBusy = false);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Restore failed: $e')),
        );
        setState(() => _isBusy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userSettings == null
              ? const Center(child: Text('Could not load settings.'))
              : Stack(
                  // Use Stack to overlay loading indicator
                  children: [
                    ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: <Widget>[
                        // NOTIFICATION TIME
                        ListTile(
                          title: const Text('Notification Time'),
                          subtitle: Text(
                            _userSettings!.notificationTimeOfDay
                                .format(context),
                          ),
                          trailing: const Icon(Icons.edit),
                          onTap: _pickNotificationTime,
                        ),
                        const Divider(),
                        // CONTACT FREQUENCY
                        ListTile(
                          title: const Text('Default New Contact Frequency'),
                          subtitle: Text(
                              _userSettings!.defaultFrequency.isNotEmpty
                                  ? _userSettings!.defaultFrequency
                                  : 'Not Set'),
                          trailing: const Icon(
                              Icons.edit), // Maybe PopupMenuButton is better?
                        ),
                        Padding(
                          // Add padding for dropdown
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: DropdownButtonFormField<String>(
                            value: _userSettings!.defaultFrequency,
                            items: ContactFrequency.values.map((frequency) {
                              return DropdownMenuItem<String>(
                                value: frequency.value,
                                child: Text(
                                    frequency.name), // Display readable name
                              );
                            }).toList(),
                            onChanged: (String? newValue) async {
                              if (newValue != null &&
                                  newValue != _userSettings!.defaultFrequency) {
                                final repository =
                                    context.read<UserSettingsRepository>();
                                final updatedSettings = _userSettings!
                                    .copyWith(defaultFrequency: newValue);
                                try {
                                  await repository.update(updatedSettings);
                                  if (!mounted) return; // Check mounted
                                  setState(() {
                                    _userSettings = updatedSettings;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Default frequency saved')),
                                  );
                                } catch (e) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Error saving frequency: $e')),
                                  );
                                }
                              }
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 12.0),
                            ),
                          ),
                        ),
                        const Divider(),

                        // --- EXPORT TILE ---
                        ListTile(
                          title: const Text('Backup Data'),
                          subtitle: const Text('Save contacts & settings to a JSON file'),
                          trailing: const Icon(Icons.file_upload),
                          enabled: !_isBusy, // Disable while exporting
                          onTap: _isBusy
                              ? null
                              : _showBackupOptions, // Call options dialog
                        ),
                        // --- END EXPORT TILE ---
                        const Divider(),
                        // --- IMPORT TILE ---
                        ListTile(
                          title: const Text('Restore Data'),
                          subtitle: const Text(
                              'Restore (overwrite) contacts & settings from JSON file'), // Updated subtitle
                          trailing: const Icon(Icons.file_download),
                          enabled: !_isBusy, // Disable while busy
                          onTap: _isBusy
                              ? null
                              : _startRestoreProcess, // Call import function
                        ),
                        // --- END IMPORT TILE ---
                        const Divider(),
                        // --- ABOUT TILE ---
                        ListTile(
                          title: const Text('About'),
                          subtitle:
                              const Text('App description and contact info'),
                          trailing: const Icon(Icons.info_outline),
                          onTap: () {
                            Navigator.pushNamed(context, '/about');
                          },
                        ),
                        const Divider(),
                        // --- END ABOUT TILE ---
                        const Divider(),
                      ],
                    ),
                    // Loading Indicator Overlay
                    if (_isBusy) // Use combined busy indicator
                      Container(
                        color: Colors.black.withOpacity(0.3),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
    );
  }
}
