import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & How To Use'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          _buildSectionTitle(context, 'Using the Contact List'),
          _buildHelpText(
            '• Swipe left or right on a contact to quickly mark them as contacted today.\n'
            '• Tap a contact to view or edit their details.\n'
            '• The main line shows the contact\'s name.\n'
            '• The subtitle shows when they are next due for contact (e.g., "Today", "Tomorrow", "In 5 days", "Overdue").\n'
            '• The text on the right shows how long ago they were last contacted (e.g., "Today", "3 days ago", "Never"). Red text indicates they are overdue based on their frequency setting.\n'
            '• The frequency (e.g., "weekly", "monthly") is shown below the last contacted time.',
          ),
          const Divider(height: 32),

          _buildSectionTitle(context, 'Contact Details Screen'),
           _buildHelpText(
            '• Edit First Name, Last Name, Birthday.\n'
            '• Select Contact Frequency: Choose how often you plan to contact this person. This determines the "Next Due" date calculation.\n'
            '• Last Contacted: Shows the last time you marked them as contacted.\n'
            '• Next Due: Shows when the app calculates you should contact them next based on the Last Contacted date and Frequency.',
          ),
           const Divider(height: 32),

           _buildSectionTitle(context, 'Icon Meanings'),
           _buildIconMeaning(Icons.check_circle_outline, 'Mark Contacted Today (Details Screen): Sets the "Last Contacted" date to now.'),
           _buildIconMeaning(Icons.save, 'Save (Details Screen): Saves any changes made to the contact.'),
           _buildIconMeaning(Icons.notifications, 'Test Notification (Details Screen) / View Scheduled (List Screen): Sends a test notification / Shows currently scheduled notifications.'),
           _buildIconMeaning(Icons.delete, 'Delete (Details Screen): Deletes the contact permanently.'),
           _buildIconMeaning(Icons.settings, 'Settings (List Screen): Access app settings like notification time, import/export, etc.'),
            _buildIconMeaning(Icons.add, 'Add Contact (List Screen): Opens the details screen to add a new contact.'),
            _buildIconMeaning(Icons.help_outline, 'Help (List Screen): Opens this help screen.'),
           // Add more icon meanings as needed
        ],
      ),
    );
  }

  // Helper widget for section titles
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge, // Use theme title style
      ),
    );
  }

   // Helper widget for help text
  Widget _buildHelpText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 15, height: 1.4), // Slightly larger font and line height
    );
  }

   // Helper widget for icon meanings
   Widget _buildIconMeaning(IconData icon, String meaning) {
     return Padding(
       padding: const EdgeInsets.symmetric(vertical: 6.0),
       child: Row(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Icon(icon, size: 20.0, color: Colors.grey[700]),
           const SizedBox(width: 12.0),
           Expanded(child: Text(meaning, style: const TextStyle(fontSize: 15))),
         ],
       ),
     );
   }
}