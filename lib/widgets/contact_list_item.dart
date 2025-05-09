// lib/widgets/contact_list_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/models/enums.dart';
import 'package:recall/utils/contact_utils.dart';

class ContactListItem extends StatelessWidget {
  final Contact contact;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showActiveStatus; // New parameter

  const ContactListItem({
    super.key,
    required this.contact,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
    this.showActiveStatus = false, // Default to false
  });

  // Helper function to dispatch the update event
  void _markContacted(BuildContext context, Contact contact) {
    final updatedContact = contact.copyWith(lastContacted: DateTime.now());
    context
        .read<ContactListBloc>()
        .add(UpdateContactFromListEvent(updatedContact));
    ScaffoldMessenger.of(context).clearSnackBars();
    final nameForSnackbar =
        (contact.nickname != null && contact.nickname!.isNotEmpty)
            ? contact.nickname!
            : contact.firstName;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Marked $nameForSnackbar as contacted.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use contact.nextContact for overdue checks and display related to next due date
    final bool isNextContactOverdue =   // Changed to use contact.nextContact
        isOverdue(contact);
    final String nextDueDateDisplayString =
        calculateNextContactDateDisplay(contact.nextContact, contact.frequency);

    final String displayName = (contact.nickname != null &&
            contact.nickname!.isNotEmpty)
        ? '${contact.nickname!} ${contact.lastName} (${contact.firstName})'
        : '${contact.firstName} ${contact.lastName}';

    return Column(
      children: [
        Slidable(
          key: ValueKey(contact.id),
          endActionPane: ActionPane(motion: const DrawerMotion(), children: [
            SlidableAction(
              onPressed: (context) => _markContacted(context, contact),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.check,
              label: 'Mark Contacted',
            ),
          ]),
          startActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => _markContacted(context, contact),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                icon: Icons.check,
                label: 'Mark Contacted',
              ),
            ],
          ),
          child: ListTile(
            selected: isSelected,
            selectedTileColor: Colors.blue.withAlpha(26),
            tileColor: contact.isActive
                ? Colors.white // Background for active contacts
                : Colors.grey.shade200, // Background for archived contacts
            leading: CircleAvatar(
              backgroundColor: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade300,
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white)
                  : Text(contact.firstName.isNotEmpty
                      ? contact.firstName[0].toUpperCase()
                      : (contact.lastName.isNotEmpty
                          ? contact.lastName[0].toUpperCase()
                          : '?')),
            ),
            title: Text(
              displayName,
              style: TextStyle(
                color: contact.isActive ? Colors.black : Colors.grey, // Text color
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.frequency != ContactFrequency.never.value
                      ? contact.frequency
                      : '',
                  style: TextStyle(
                    fontSize: 12,
                    color: contact.isActive ? Colors.grey : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
            trailing: Text(
              calculateNextContactDateDisplay(
                  contact.nextContact, contact.frequency),
              style: TextStyle(
                fontSize: 12,
                color: contact.isActive
                    ? getContactDateColor(
                        contact.nextContact, contact.frequency, context)
                    : Colors.grey.shade400,
              ),
            ),
            onTap: onTap,
            onLongPress: onLongPress,
          ),
        ),
        const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
      ],
    );
  }
}
