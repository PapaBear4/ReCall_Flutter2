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
    final now = DateTime.now();
    // First, create a contact object that has the new lastContactDate
    final contactWithJustUpdatedLastContactDate = contact.copyWith(lastContactDate: now);
    // Then, use this object to calculate the nextContactDate
    final updatedContact = contactWithJustUpdatedLastContactDate.copyWith(
      nextContactDate: calculateNextContactDate(contactWithJustUpdatedLastContactDate)
    );
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
          startActionPane: null, 
          // TODO: Add a snooze feature for 1, 3, and 5 days
          /*ActionPane(
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
          ),*/
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
                  contact.nextContactDate, contact.frequency),
              style: TextStyle(
                fontSize: 12,
                color: contact.isActive
                    ? getContactDateColor(
                        contact.nextContactDate, contact.frequency, context)
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
