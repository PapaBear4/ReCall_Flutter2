// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Use provider to read repository
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

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  UserSettings? _userSettings;
  bool _isLoading = true;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
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
      }
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
    if (_userSettings == null)
      return; // Don't show picker if settings haven't loaded

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
  Future<String?> _prepareExportData() async {
    setState(() => _isExporting = true);
    try {
      final contactRepo = context.read<ContactRepository>();
      final List<Contact> contacts = await contactRepo.getAll();

      if (contacts.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No contacts to export.')),
        );
        setState(() => _isExporting = false);
        return null;
      }

      List<Map<String, dynamic>> contactsJsonList =
          contacts.map((contact) => contact.toJson()).toList();
      String jsonString =
          const JsonEncoder.withIndent('  ').convert(contactsJsonList);

      setState(() => _isExporting = false);
      return jsonString;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error preparing export data: $e')),
      );
      setState(() => _isExporting = false);
      return null;
    }
  }

  // Saves the JSON string using file_picker
  Future<void> _saveExportFile(String jsonString) async {
    setState(() => _isExporting = true); // Show loading indicator
    try {
      // Convert string to bytes
      Uint8List fileBytes = utf8.encode(jsonString);

      String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Contacts Export',
        fileName: 'recall_contacts.json', // Suggested filename
        bytes: fileBytes,
      );

      if (mounted) {
        // Check if widget is still mounted
        setState(() => _isExporting = false); // Hide loading indicator
        if (outputPath != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Contacts exported successfully to $outputPath')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Export cancelled.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isExporting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving export file: $e')),
        );
      }
    }
  }

  // Shares the JSON string using share_plus
  Future<void> _shareExportFile(String jsonString) async {
    setState(() => _isExporting = true); // Show loading indicator
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String tempFilePath = '${tempDir.path}/recall_contacts_temp.json';
      final File tempFile = File(tempFilePath);

      await tempFile.writeAsString(jsonString);

      await Share.shareXFiles(
        [XFile(tempFile.path)],
        text: 'Recall App Contacts Export',
      );

      // Optional: Clean up the temporary file
      // await tempFile.delete();

      if (mounted) {
        // Check if widget is still mounted
        setState(() => _isExporting = false); // Hide loading indicator
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isExporting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing export file: $e')),
        );
      }
    }
  }

  // Shows the dialog to choose between Save or Share
  Future<void> _showExportOptions() async {
    // Prepare data first
    final String? jsonString = await _prepareExportData();

    // If data preparation failed or was cancelled, stop here
    if (jsonString == null || !mounted) return;

    // Show choice dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Export Contacts As JSON'),
          content: const Text('Choose how to export the file:'),
          actions: <Widget>[
            TextButton(
              child: const Text('Save to Device'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _saveExportFile(jsonString); // Call save function
              },
            ),
            TextButton(
              child: const Text('Share'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _shareExportFile(jsonString); // Call share function
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
              : Stack(  // Use Stack to overlay loading indicator
                  children: [
                    ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: <Widget>[
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
                        // --- EXPORT TILE ---
                        ListTile(
                          title: const Text('Export Data'),
                          subtitle: const Text('Save contacts to a JSON file'),
                          trailing: const Icon(Icons.file_upload),
                          enabled: !_isExporting, // Disable while exporting
                          onTap: _isExporting
                              ? null
                              : _showExportOptions, // Call options dialog
                        ),
                        // --- END EXPORT TILE ---
                        const Divider(),
                        ListTile(
                          // Import Tile remains placeholder
                          title: const Text('Import Data'),
                          subtitle: const Text('Load contacts from a file'),
                          trailing: const Icon(Icons.file_download),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Import not yet implemented')),
                            );
                          },
                        ),
                        const Divider(),
                      ],
                    ),
                    // Loading Indicator Overlay
                    if (_isExporting)
                      Container(
                        color: Colors.black.withOpacity(0.3),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                ),
    );
  }
}
