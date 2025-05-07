// lib/widgets/contact_list_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/models/enums.dart';
import 'package:recall/utils/last_contacted_utils.dart';

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
        isOverdue(contact.nextContact, contact.frequency);
    final String nextDueDateDisplayString =
        calculateNextDueDateDisplay(contact.nextContact, contact.frequency);

    final String displayName = (contact.nickname != null &&
            contact.nickname!.isNotEmpty)
        ? contact.nickname!
        : '${contact.firstName} ${contact.lastName}';
    final String secondaryName = (contact.nickname != null &&
            contact.nickname!.isNotEmpty)
        ? '${contact.firstName} ${contact.lastName}'
        : '';

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
            title: Text(displayName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (secondaryName.isNotEmpty)
                  Text(secondaryName,
                      style: const TextStyle(fontSize: 11, color: Colors.grey)),
                Text(
                  nextDueDateDisplayString,
                  style: TextStyle(
                    fontSize: 12,
                    color: getDueDateColor(
                        contact.nextContact, contact.frequency, context),
                  ),
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatLastContacted(contact.lastContacted),
                  style: TextStyle(
                      fontSize: 12,
                      color: isNextContactOverdue ? Colors.red.shade700 : null),
                ),
                Text(
                    contact.frequency != ContactFrequency.never.value
                        ? contact.frequency
                        : '',
                    style: const TextStyle(
                        fontSize: 10, color: Colors.grey)),
                if (showActiveStatus)
                  Icon(
                    contact.isActive
                        ? Icons.check_circle
                        : Icons.pause_circle_outline,
                    color: contact.isActive ? Colors.green : Colors.grey,
                    semanticLabel: contact.isActive ? "Active" : "Inactive",
                  ),
              ],
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
