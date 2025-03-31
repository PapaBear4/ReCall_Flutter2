// lib/screens/help_screen.dart
import 'package:flutter/material.dart';

// Enum to identify help sections
enum HelpSection { list, details, icons }

class HelpScreen extends StatelessWidget {
  final HelpSection? initialSection; // Add parameter

  const HelpScreen({super.key, this.initialSection}); // Update constructor

  @override
  Widget build(BuildContext context) {
    // Define tile padding for consistency
    const EdgeInsets tilePadding = EdgeInsets.symmetric(horizontal: 16.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & How To Use'),
      ),
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            key: const PageStorageKey<String>(
                'listHelp'), // Add keys for state preservation
            title: _buildSectionTitle(context, 'Using the Contact List'),
            initiallyExpanded:
                initialSection == HelpSection.list, // Control expansion
            childrenPadding: tilePadding,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildHelpText(
                // ... (help text content remains the same) ...
                '• Use the Search Bar at the top to find contacts by first or last name.\n'
                '• Tap the Sort/Filter icon (looks like lines) in the top right to change sorting or apply filters.\n'
                '  - Sorting: Due Date (Soonest/Latest), Last Name (A-Z/Z-A), Last Contacted (Oldest/Newest).\n'
                '  - Filtering: Show only Overdue, only Due Soon (Today/Tomorrow), or Clear Filter.\n'
                '• Swipe left or right on a contact to quickly mark them as contacted today.\n'
                '• Tap a contact to view their details.\n'
                '• The main line shows the contact\'s name.\n'
                '• The subtitle shows when they are next due for contact (e.g., "Today", "Tomorrow", "In 5 days", "Overdue").\n'
                '• The text on the right shows how long ago they were last contacted (e.g., "Today", "3 days ago", "Never"). Red text indicates they are overdue based on their frequency setting.\n'
                '• The frequency (e.g., "weekly", "monthly") is shown below the last contacted time (if set).',
              ),
              const SizedBox(height: 16),
            ],
          ),
          const Divider(height: 1),
          ExpansionTile(
            key: const PageStorageKey<String>('detailsHelp'),
            title: _buildSectionTitle(context, 'Contact Details Screen'),
            initiallyExpanded:
                initialSection == HelpSection.details, // Control expansion
            childrenPadding: tilePadding,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildHelpText(
                // ... (help text content remains the same) ...
                '• This screen starts in View-Only mode, showing the contact\'s details (Name, Birthday, Last Contacted, Frequency, Next Due).\n'
                '• Tap the Edit icon (pencil) in the top right to enter Edit Mode.\n'
                '• In Edit Mode, the static details disappear, and you can edit the First Name, Last Name, Contact Frequency, and Birthday using input fields.\n'
                '• Tap the Save icon (disk) in the top right while in Edit Mode to save your changes and return to View-Only mode.\n'
                '• Tap the Delete icon (trash can) in the top right to delete the contact (you will be asked to confirm).\n'
                '• Tap the "Mark Contacted Today" button (checkmark circle) in the bottom bar at any time to update the "Last Contacted" date to now (this also saves the change immediately).',
              ),
              const SizedBox(height: 16),
            ],
          ),
          const Divider(height: 1),
          ExpansionTile(
            key: const PageStorageKey<String>('iconsHelp'),
            title: _buildSectionTitle(context, 'Icon Meanings'),
            initiallyExpanded:
                initialSection == HelpSection.icons, // Control expansion
            childrenPadding: tilePadding,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // ... (icon meanings remain the same) ...
              _buildIconMeaning(Icons.search,
                  'Search (List Screen): Type to filter contacts by name.'),
              _buildIconMeaning(Icons.clear,
                  'Clear Search (List Screen): Clears the search bar text.'),
              _buildIconMeaning(Icons.sort,
                  'Sort & Filter (List Screen): Opens menu for sorting and filtering options.'),
              _buildIconMeaning(Icons.help_outline,
                  'Help (List/Details Screen): Opens this help screen.'), // Updated description slightly
              _buildIconMeaning(Icons.settings,
                  'Settings (List Screen): Access app settings (Notification Time, Import/Export, About).'),
              _buildIconMeaning(Icons.edit,
                  'Edit Contact (Details Screen): Enter Edit Mode to modify contact details.'),
              _buildIconMeaning(Icons.save,
                  'Save Changes (Details Screen): Saves modifications made in Edit Mode.'),
              _buildIconMeaning(Icons.delete,
                  'Delete Contact (Details Screen): Deletes the current contact.'),
              _buildIconMeaning(Icons.arrow_back,
                  'Back: Navigates to the previous screen. Prompts to discard if editing with unsaved changes.'),
              _buildIconMeaning(Icons.check_circle_outline,
                  'Mark Contacted Today (Details Screen - Bottom Bar): Sets "Last Contacted" date to now.'),
              _buildIconMeaning(Icons.notifications,
                  'View Scheduled Notifications (List Screen - Bottom Bar): Shows a list of upcoming notification reminders.'),
              _buildIconMeaning(Icons.add,
                  'Add Contact (List Screen - Bottom Bar): Opens the details screen to add a new contact.'),
              const SizedBox(height: 16),
            ],
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }

  // Helper widget for section titles (Used as ExpansionTile title)
  Widget _buildSectionTitle(BuildContext context, String title) {
    // Removed Padding from here, let ExpansionTile handle spacing
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold), // Adjusted style for tile title
    );
  }

  // Helper widget for help text (remains the same)
  Widget _buildHelpText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 15, height: 1.5),
    );
  }

  // Helper widget for icon meanings (remains the same)
  Widget _buildIconMeaning(IconData icon, String meaning) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22.0, color: Colors.grey[700]),
          const SizedBox(width: 14.0),
          Expanded(child: Text(meaning, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}
