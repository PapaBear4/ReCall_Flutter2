// lib/widgets/contact_list_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:recall/blocs/contact_details/contact_details_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/models/contact_frequency.dart';
import 'package:recall/utils/last_contacted_utils.dart';
import 'package:recall/utils/logger.dart'; // Adjust path if needed

class ContactListItem extends StatelessWidget {
  final Contact contact;

  const ContactListItem({
    super.key,
    required this.contact,
  });

  // Helper function to dispatch the update event
  // Helper function to dispatch the update event
  void _markContacted(BuildContext context, Contact contact) {
     final updatedContact = contact.copyWith(lastContacted: DateTime.now());
     // Dispatch event to update contact in BLoC
     context.read<ContactListBloc>().add(
        ContactListEvent.updateContactFromList(updatedContact));
      ScaffoldMessenger.of(context).clearSnackBars();
      // Determine name for snackbar based on nickname presence
      final nameForSnackbar = (contact.nickname != null && contact.nickname!.isNotEmpty)
                              ? contact.nickname!
                              : contact.firstName;
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
             content: Text('Marked $nameForSnackbar as contacted.'), // Use dynamic name
             duration: const Duration(seconds: 2),
         ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final bool isContactOverdue = isOverdue(contact.frequency, contact.lastContacted);
    // Determine the primary display name based on nickname presence
    final String displayName = (contact.nickname != null && contact.nickname!.isNotEmpty)
                             ? contact.nickname! // Use nickname if available
                             : '${contact.firstName} ${contact.lastName}'; // Fallback to first + last

    // Determine the secondary name display (full name if nickname was used, or empty)
    final String secondaryName = (contact.nickname != null && contact.nickname!.isNotEmpty)
                               ? '${contact.firstName} ${contact.lastName}' // Show full name below if nickname used
                               : ''; // Empty if nickname wasn't used

    return Column(
      children: [
        Slidable(
          key: ValueKey(contact.id), // Use contact ID for stable key
          endActionPane: ActionPane(
             motion: const DrawerMotion(),
             children: [
                SlidableAction(
                   onPressed: (context) => _markContacted(context, contact),
                   backgroundColor: Colors.blue,
                   foregroundColor: Colors.white,
                   icon: Icons.check,
                   label: 'Mark Contacted',
                ),
             ]),
          startActionPane: ActionPane( // Keep start action pane for consistency
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
             title: Text(displayName),
             subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (secondaryName.isNotEmpty) // Only show if there's a secondary name
                    Text(secondaryName, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  Text(
                     calculateNextDueDateDisplay(
                        contact.lastContacted, contact.frequency),
                     style: const TextStyle(fontSize: 12)),
                ],
             ),
             trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                   Text( // Show last contacted relative time
                      formatLastContacted(contact.lastContacted),
                      style: isContactOverdue // Highlight if overdue
                         ? const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
                         : const TextStyle(fontSize: 12), // Smaller font size for non-overdue
                   ),
                   Text( // Show frequency
                      contact.frequency != ContactFrequency.never.value
                         ? contact.frequency
                         : '', // Don't show 'never' explicitly
                      style: const TextStyle(fontSize: 10, color: Colors.grey)), // Smaller/greyed out
                ],
             ),
             onTap: () {
                if (contact.id == null) {
                  // Log or handle error, should not happen for list items
                  logger.e("Error: Tapped contact with null ID.");
                  return;
                }
                // Load details for the tapped contact
                context.read<ContactDetailsBloc>().add(
                   ContactDetailsEvent.loadContact(contactId: contact.id!));
                // Navigate to details screen
                Navigator.pushNamed(
                   context,
                   '/contactDetails',
                   arguments: contact.id,
                );
             },
          ),
        ),
        const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16), // Keep divider
      ],
    );
  }
}