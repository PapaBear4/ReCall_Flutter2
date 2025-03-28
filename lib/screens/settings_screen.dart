// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView( // Use ListView for future settings options
        padding: const EdgeInsets.all(16.0),
        children: const <Widget>[
          // We will add settings options here in later steps
          Text('Notification Time (To be implemented)'),
          SizedBox(height: 20),
          Text('Export Data (To be implemented)'),
          SizedBox(height: 20),
          Text('Import Data (To be implemented)'),
        ],
      ),
    );
  }
}