// lib/screens/help_screen.dart
import 'package:flutter/material.dart';

// Enum to identify help sections
enum HelpSection { list, details, settings, icons } // Added settings

class HelpScreen extends StatelessWidget {
  final HelpSection? initialSection;

  const HelpScreen({super.key, this.initialSection});

  @override
  Widget build(BuildContext context) {
    const EdgeInsets tilePadding = EdgeInsets.symmetric(horizontal: 16.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & How To Use'),
      ),
      body: ListView(
        children: <Widget>[
          // --- Contact List Section ---
          ExpansionTile(
            key: const PageStorageKey<String>('listHelp'),
            title: _buildSectionTitle(context, 'Using the Contact List'),
            initiallyExpanded: initialSection == HelpSection.list,
            childrenPadding: tilePadding,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildHelpText(
                '• Use the Search Bar at the top to find contacts by first or last name.\n'
                '• Tap the Sort/Filter icon (three lines) in the top right to change sorting or apply filters:\n'
                '  - Sorting: Due Date (Soonest/Latest), Last Name (A-Z/Z-A), Last Contacted (Oldest/Newest).\n' // Updated sort options
                '  - Filtering: Show only Overdue, only Due Soon (Today/Tomorrow), or Clear Filter.\n'
                '• Long press on a contact to enter Selection Mode.\n' // Added long press
                '• In Selection Mode, tap contacts to select/deselect them.\n' // Added selection tap
                '• Use the top bar in Selection Mode to Close selection, Delete selected contacts, or Select All displayed contacts.\n' // Added selection actions
                '• Swipe left or right on a contact in the list to reveal a button to quickly mark them as contacted today.\n' // Updated swipe action
                '• Tap a contact (when not in Selection Mode) to view their details.\n'
                '• The main line shows the contact\'s Nickname (if set) or their First and Last Name.\n' // Updated name display
                '• If a nickname is shown, the full name appears smaller below it.\n' // Added secondary name
                '• Below the name, it shows when they are next due for contact (e.g., "Today", "Tomorrow", "In 5 days", "Overdue").\n'
                '• The text on the right shows how long ago they were last contacted (e.g., "Today", "3 days ago"). Red text indicates they are overdue based on their frequency setting.\n'
                '• The contact frequency (e.g., "weekly", "monthly") is shown below the last contacted time (if set and not "never").', // Updated frequency display
              ),
              const SizedBox(height: 16),
            ],
          ),
          const Divider(height: 1),
          // --- Contact Details Section ---
          ExpansionTile(
            key: const PageStorageKey<String>('detailsHelp'),
            title: _buildSectionTitle(context, 'Contact Details Screen'),
            initiallyExpanded: initialSection == HelpSection.details,
            childrenPadding: tilePadding,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildHelpText(
                '• This screen displays the contact\'s details.\n'
                '• Tapping the Phone number opens options to Call or Message.\n' // Added phone tap action
                '• Tapping an Email address opens your email app to compose a message.\n' // Added email tap action
                '• Tap the Edit icon (pencil) in the top right to enter Edit Mode.\n'
                '• In Edit Mode, you can modify: First Name, Last Name, Nickname, Phone Number, Contact Frequency, Birthday, Anniversary, Emails (add/remove/edit), Notes, and Social Media links/handles.\n' // Updated editable fields
                '• Tap the Save icon (disk) in the top right while in Edit Mode to save your changes and return to View Mode.\n'
                '• Tap the Delete icon (trash can) in the top right to delete the contact (you will be asked to confirm).\n'
                '• Tap the Back arrow (<) to return to the list. If you have unsaved changes in Edit Mode, you will be asked to confirm discarding them.\n'
                '• Tap the "Mark Contacted Today" button (checkmark circle) in the bottom bar at any time to update the "Last Contacted" date to now (this also saves the change immediately).',
              ),
              const SizedBox(height: 16),
            ],
          ),
          const Divider(height: 1),
          // --- Settings Section ---
          ExpansionTile(
            key: const PageStorageKey<String>('settingsHelp'), // Added key
            title:
                _buildSectionTitle(context, 'Settings Screen'), // Added title
            initiallyExpanded:
                initialSection == HelpSection.settings, // Added control
            childrenPadding: tilePadding,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildHelpText(
                '• Notification Time: Set the time of day you want to receive reminders for due contacts.\n'
                '• Default New Contact Frequency: Choose the frequency that will be automatically selected when you create a new contact.\n'
                '• Import Contacts: Select contacts from your device\'s address book to import into reCall.\n'
                '• Backup Data: Save all your reCall contacts and settings to a JSON file. You can choose to save it locally or share it.\n'
                '• Restore Data: Replace ALL current reCall data with data from a previously saved JSON backup file. Use with caution!\n'
                '• About: View app description and developer contact information.',
              ),
              const SizedBox(height: 16),
            ],
          ),
          const Divider(height: 1),
          // --- Icon Meanings Section ---
          ExpansionTile(
            key: const PageStorageKey<String>('iconsHelp'),
            title: _buildSectionTitle(context, 'Icon Meanings'),
            initiallyExpanded: initialSection == HelpSection.icons,
            childrenPadding: tilePadding,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildIconMeaning(Icons.search,
                  'Search (List Screen): Filters contacts by name as you type.'), // Updated
              _buildIconMeaning(Icons.clear,
                  'Clear Search (List Screen): Clears the search bar text.'),
              _buildIconMeaning(Icons.sort,
                  'Sort & Filter (List Screen): Opens menu for sorting and filtering options.'), // Keep description
              _buildIconMeaning(Icons.help_outline,
                  'Help (List/Details Screen): Opens this help screen.'),
              _buildIconMeaning(Icons.settings,
                  'Settings (List Screen): Access app settings.'),
              _buildIconMeaning(Icons.edit,
                  'Edit Contact (Details Screen): Enter Edit Mode to modify contact details.'),
              _buildIconMeaning(Icons.save,
                  'Save Changes (Details Screen): Saves modifications made in Edit Mode.'),
              _buildIconMeaning(Icons.delete,
                  'Delete Contact (Details Screen / Selection Mode Top Bar): Deletes the current or selected contact(s).'), // Updated
              _buildIconMeaning(Icons.arrow_back,
                  'Back: Navigates to the previous screen. Prompts if editing with unsaved changes.'),
              _buildIconMeaning(Icons.check_circle_outline,
                  'Mark Contacted Today (Details Screen - Bottom Bar): Sets "Last Contacted" date to now.'),
              _buildIconMeaning(Icons.notifications,
                  'View Scheduled Notifications (List Screen - Bottom Bar): Shows a list of upcoming notification reminders.'),
              _buildIconMeaning(Icons.add,
                  'Add Contact (List Screen - Bottom Bar): Opens the details screen to add a new contact.'),
              _buildIconMeaning(Icons.close,
                  'Close Selection Mode (List Screen - Top Bar): Exits selection mode without deleting.'), // Added
              _buildIconMeaning(Icons.select_all,
                  'Select All (List Screen - Selection Mode Top Bar): Selects/deselects all currently visible contacts.'), // Added
              _buildIconMeaning(Icons.check,
                  'Mark Contacted (List Screen - Swipe Action): Marks the contact as contacted today.'), // Added swipe action icon
              _buildIconMeaning(Icons.edit_note,
                  'Select phone/email (Import Screen): Opens a dialog to choose specific phone/email to import for a contact.'), // Added import icon
              _buildIconMeaning(Icons.download_done,
                  'Import Selected (Import Screen - Floating Button): Starts the import process for selected contacts.'), // Added import icon
              const SizedBox(height: 16),
            ],
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }

  // Helper widget for section titles
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  // Helper widget for help text
  Widget _buildHelpText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 15, height: 1.5),
    );
  }

  // Helper widget for icon meanings
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
