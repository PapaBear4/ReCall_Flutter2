import 'package:flutter/material.dart';
import 'package:recall/utils/debug_utils.dart';
import 'package:recall/services/service_locator.dart';
import 'package:recall/repositories/repositories.dart';

class DebugMenuScreen extends StatelessWidget {
  const DebugMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug Menu')),
      body: ListView(
        children: [
          _buildDebugButton(
            context,
            'Add 10 Sample Device Contacts',
            () async {
              final result = await DebugUtils.addSampleDeviceContacts();
              _showResult(context, result);
            },
          ),
          
          // Add the new button for app contacts
          _buildDebugButton(
            context,
            'Add 10 Sample App Contacts',
            () async {
              final contactRepo = getIt<ContactRepository>();
              final result = await DebugUtils.addSampleAppContacts(contactRepo);
              _showResult(context, result.toString());
            },
          ),
          
          _buildDebugButton(
            context,
            'Clear App Database',
            () async {
              final contactRepo = getIt<ContactRepository>();
              final settingsRepo = getIt<UserSettingsRepository>();
              final result = await DebugUtils.clearAppDatabase(
                  contactRepo, settingsRepo);
              _showResult(context, result);
            },
          ),
          
          // Other debug buttons...
        ],
      ),
    );
  }

  Widget _buildDebugButton(
      BuildContext context, String title, Future<void> Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ElevatedButton(
        onPressed: () async {
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Processing...')),
          );
          await onPressed();
        },
        child: Text(title),
      ),
    );
  }

  void _showResult(BuildContext context, String result) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Operation Result'),
        content: Text(result),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
