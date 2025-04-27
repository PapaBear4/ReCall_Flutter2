// lib/widgets/contact_list_item.dart
import 'package:flutter/material.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/utils/last_contacted_utils.dart';

/// A ListTile implementation for displaying a contact in a list.
///
/// Shows the contact's name, next due date, and provides selection state.
class ContactListItem extends StatelessWidget {
  /// The contact to display.
  final Contact contact;
  
  /// Whether this contact is selected in multi-select mode.
  final bool isSelected;
  
  /// Callback when the item is tapped.
  final VoidCallback? onTap;
  
  /// Callback when the item is long-pressed.
  final VoidCallback? onLongPress;

  const ContactListItem({
    super.key,
    required this.contact,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    // Get the contact status text ("Overdue", "Today", etc.)
    final dueDateText = calculateNextDueDateDisplay(
      contact.lastContacted, 
      contact.frequency
    );
    
    // Determine the status color
    final statusColor = getStatusColor(dueDateText);
    
    // Get initials for the avatar
    final initials = getInitials(contact);
    
    // Determine visual style modifications based on archived status
    final bool isArchived = !contact.isActive;
    final double opacity = isArchived ? 0.7 : 1.0;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        selected: isSelected,
        selectedTileColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
        onTap: onTap,
        onLongPress: onLongPress,
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColorLight.withOpacity(opacity),
              child: Text(
                initials,
                style: TextStyle(
                  color: Colors.white.withOpacity(opacity),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (isArchived)
              const Positioned(
                right: 0,
                bottom: 0,
                child: Icon(Icons.archive, size: 16, color: Colors.grey),
              ),
          ],
        ),
        title: Opacity(
          opacity: opacity,
          child: Text(
            _getDisplayName(contact),
            style: TextStyle(
              fontWeight: isArchived ? FontWeight.normal : FontWeight.bold,
              decoration: isArchived ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
        subtitle: Opacity(
          opacity: opacity,
          child: Row(
            children: [
              if (isArchived)
                const Padding(
                  padding: EdgeInsets.only(right: 6.0),
                  child: Text(
                    'Archived',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              if (dueDateText.isNotEmpty && dueDateText != 'Never')
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: statusColor.withOpacity(opacity),
                ),
              if (dueDateText.isNotEmpty && dueDateText != 'Never')
                Text(
                  ' $dueDateText',
                  style: TextStyle(
                    color: statusColor.withOpacity(opacity),
                    fontWeight: isOverdue(contact.frequency, contact.lastContacted)
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
            ],
          ),
        ),
        trailing: isSelected
            ? const Icon(Icons.check_circle)
            : (isArchived
                ? const Icon(Icons.archive_outlined, color: Colors.grey)
                : const Icon(Icons.chevron_right)),
      ),
    );
  }

  /// Gets the display name for the contact.
  String _getDisplayName(Contact contact) {
    final firstName = contact.firstName;
    final lastName = contact.lastName;
    final nickname = contact.nickname;

    if (nickname != null && nickname.isNotEmpty) {
      if (lastName.isNotEmpty) {
        return '$nickname $lastName'; // Show nickname and last name
      } else {
        return nickname; // Show only nickname if last name is empty
      }
    }
    
    // Original logic if nickname is empty
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '$firstName $lastName';
    } else if (firstName.isNotEmpty) {
      return firstName;
    } else if (lastName.isNotEmpty) {
      return lastName;
    } else {
      return 'Unnamed Contact';
    }
  }

  /// Gets the initials for the contact's avatar.
  String getInitials(Contact contact) {
    if (contact.nickname != null && contact.nickname!.isNotEmpty) {
      return contact.nickname![0].toUpperCase();
    }
    
    String initials = '';
    
    if (contact.firstName.isNotEmpty) {
      initials += contact.firstName[0].toUpperCase();
    }
    
    if (contact.lastName.isNotEmpty) {
      initials += contact.lastName[0].toUpperCase();
    }
    
    return initials.isEmpty ? '?' : initials;
  }

  /// Gets the appropriate color for the status text.
  Color getStatusColor(String status) {
    switch (status) {
      case 'Overdue':
        return Colors.red;
      case 'Today':
        return Colors.orange;
      case 'Tomorrow':
        return Colors.orange[300]!;
      case 'Never':
        return Colors.grey;
      default:
        return Colors.green;
    }
  }
}
