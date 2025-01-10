/*
Notification Toggles: Provide switches or toggles for users to enable or disable different types of notifications (e.g., reminders, alerts, updates).
Channel Customization: If you're using notification channels (for Android), allow users to configure the importance level, sound, vibration pattern, and other settings for each channel.
Quiet Hours: Implement options for users to define quiet hours or "Do Not Disturb" periods during which they won't receive notifications.
Notification Preview: Consider adding a section to preview how notifications will look and sound based on the user's current settings.


import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _ remindersEnabled = true;
  bool _alertsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Enable Reminders'),
            value: _remindersEnabled,
            onChanged: (value) {
              setState(() {
                _remindersEnabled = value;
                // Notify the NotificationService about the change
              });
            },
          ),
          SwitchListTile(
            title: const Text('Enable Alerts'),
            value: _alertsEnabled,
            onChanged: (value) {
              setState(() {
                _alertsEnabled = value;
                // Notify the NotificationService about the change
              });
            },
          ),
          // Add more settings options here
        ],
      ),
    );
  }
}



// ... other imports ...
import 'package:path_provider/path_provider.dart';

class _SettingsPageState extends State<SettingsPage> {
  // ... other variables ...
  late final Store _store;
  late final Box<NotificationSettings> _settingsBox;
  late NotificationSettings _settings;

  @override
  void initState() {
    super.initState();
    _initializeObjectBox();
  }

  Future<void> _initializeObjectBox() async {
    final dir = await getApplicationDocumentsDirectory();
    _store = await openStore(directory: dir.path + '/objectbox');
    _settingsBox = _store.box<NotificationSettings>();

    // Get existing settings or create default ones
    final query = _settingsBox.query().build();
    final results = query.find();
    if (results.isEmpty) {
      _settings = NotificationSettings();
      _settingsBox.put(_settings);
    } else {
      _settings = results.first;
    }

    setState(() {}); // Update UI with fetched settings
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... app bar ...
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Enable Reminders'),
            value: _settings.remindersEnabled,
            onChanged: (value) {
              setState(() {
                _settings.remindersEnabled = value;
                _settingsBox.put(_settings); // Update in ObjectBox
              });
            },
          ),
          // ... other settings options ...
        ],
      ),
    );
  }
}

*/