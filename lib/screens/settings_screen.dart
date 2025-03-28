// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Use provider to read repository
import 'package:recall/models/usersettings.dart';
import 'package:recall/repositories/usersettings_repository.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  UserSettings? _userSettings;
  bool _isLoading = true;

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
    if (_userSettings == null) return; // Don't show picker if settings haven't loaded

    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _userSettings!.notificationTimeOfDay, // Use current time as initial
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
          _userSettings = updatedSettings; // Update local state to reflect change
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
              : ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: <Widget>[
                    ListTile(
                      title: const Text('Notification Time'),
                      subtitle: Text(
                        // Format the TimeOfDay for display
                        _userSettings!.notificationTimeOfDay.format(context),
                      ),
                      trailing: const Icon(Icons.edit),
                      onTap: _pickNotificationTime, // Open time picker on tap
                    ),
                    const Divider(), // Separator
                    // --- Placeholder for Export ---
                    ListTile(
                      title: const Text('Export Data'),
                      subtitle: const Text('Save contacts to a file'),
                      trailing: const Icon(Icons.file_upload),
                      onTap: () {
                        // TODO: Implement Export
                         ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Export not yet implemented')),
                         );
                      },
                    ),
                    const Divider(), // Separator
                    // --- Placeholder for Import ---
                    ListTile(
                      title: const Text('Import Data'),
                      subtitle: const Text('Load contacts from a file'),
                      trailing: const Icon(Icons.file_download),
                      onTap: () {
                        // TODO: Implement Import
                         ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Import not yet implemented')),
                         );
                      },
                    ),
                    const Divider(), // Separator
                  ],
                ),
    );
  }
}