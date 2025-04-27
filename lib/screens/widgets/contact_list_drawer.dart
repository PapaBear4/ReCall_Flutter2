import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recall/screens/scheduled_notifications_screen.dart';
import 'package:recall/utils/debug_utils.dart'; // Import DebugUtils
import 'package:recall/utils/logger.dart'; // Import logger
// Assuming you have defined scaffoldMessengerKey in your main app file
// import 'package:recall/main.dart'; // Or wherever scaffoldMessengerKey is defined

typedef VoidCallback = void Function();

class ContactListDrawer extends StatelessWidget {
  // MARK: - Properties
  final VoidCallback onAddSampleContacts;
  final VoidCallback onClearAppData;

  // MARK: - Constructor
  const ContactListDrawer({
    super.key,
    required this.onAddSampleContacts,
    required this.onClearAppData,
  });

  // MARK: - Build Method
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'ReCall',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Keep in touch with people who matter',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.contact_phone),
            title: const Text('Contacts'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              // Already on contact list screen, do nothing else
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushNamed(context, '/about');
            },
          ),

          // Add debug section only in debug mode
          if (kDebugMode) const Divider(),

          if (kDebugMode)
            ListTile(
              leading: const Icon(Icons.bug_report, color: Colors.orange),
              title: const Text('Developer Debug',
                  style: TextStyle(color: Colors.orange)),
              onTap: () {
                Navigator.pop(context); // Close drawer
                _showDebugMenu(context);
              },
            ),
        ],
      ),
    );
  }

  // MARK: - Debug Menu
  // Debug menu implementation (moved here, needs context)
  void _showDebugMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // Add these properties to prevent the sheet dismissal from potentially
      // invalidating the context before the async operation completes fully.
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext innerContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: double.infinity,
                color: Colors.orange.shade100,
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                child: const Text(
                  'Developer Debug Options',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.deepOrange,
                  ),
                ),
              ),
              // ----- VIEW NOTIFICATIONS -----
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('View Scheduled Notifications'),
                onTap: () {
                  Navigator.pop(context); // Close bottom sheet
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ScheduledNotificationsScreen()));
                },
              ),
              // ----- ADD SAMPLE CONTACTS TO APP -----
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Add Sample Contacts to App'),
                onTap: () {
                  Navigator.pop(innerContext); // Close bottom sheet
                  onAddSampleContacts(); // Call the callback
                },
              ),
              // ----- ADD SAMPLE CONTACTS TO DEVICE -----
              ListTile(
                leading: const Icon(Icons.contact_phone),
                title: const Text('Add Sample Contacts to Device'),
                onTap: () async {
                  Navigator.pop(innerContext); // Close bottom sheet
                  final status = await DebugUtils.addSampleDeviceContacts();
                  logger.i(status);
                },
              ),
              // ----- CLEAR ALL APP DATA -----
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text('Clear ALL App Data',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  if (innerContext.mounted) {
                    Navigator.pop(innerContext); // Close bottom sheet
                  }
                  onClearAppData(); // Call the callback
                },
              ),
              // Optional: Add a cancel button if isDismissible is false
              const Divider(),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () {
                  if (innerContext.mounted) {
                    Navigator.pop(innerContext); // Close bottom sheet
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
