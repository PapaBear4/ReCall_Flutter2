import 'package:flutter/material.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/repositories/usersettings_repository.dart';
import 'package:recall/utils/debug_utils.dart';

class DebugOptionsTile extends StatelessWidget {
  final ContactRepository contactRepo;
  final UserSettingsRepository settingsRepo;

  const DebugOptionsTile({
    super.key,
    required this.contactRepo,
    required this.settingsRepo,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.bug_report, color: Colors.red),
      title: const Text(
        'Debug Options',
        style: TextStyle(color: Colors.red),
      ),
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, color: Colors.red),
        onSelected: (String value) async {
          if (value == 'add_to_device') {
            // Add Contacts to Device
            final result = await DebugUtils.addSampleDeviceContacts();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result)),
            );
          } else if (value == 'add_to_app') {
            // Add Contacts to App
            final result = await DebugUtils.addSampleAppContacts(contactRepo);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result)),
            );
          } else if (value == 'clear_data') {
            // Clear App Data
            final confirm = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Clear App Data'),
                      content: const Text(
                          'This will permanently delete all app data. Are you sure?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        TextButton(
                          child: const Text(
                            'Clear Data',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                      ],
                    );
                  },
                ) ??
                false;

            if (confirm) {
              final result =
                  await DebugUtils.clearAppData(contactRepo, settingsRepo);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(result)),
              );
            }
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'add_to_device',
            child: Text('Add Contacts to Device'),
          ),
          const PopupMenuItem<String>(
            value: 'add_to_app',
            child: Text('Add Contacts to App'),
          ),
          const PopupMenuItem<String>(
            value: 'clear_data',
            child: Text('Clear App Data'),
          ),
        ],
      ),
    );
  }
}