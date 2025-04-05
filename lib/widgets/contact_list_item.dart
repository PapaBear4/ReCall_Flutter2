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
  void _markContacted(BuildContext context, Contact contact) {
     final updatedContact = contact.copyWith(lastContacted: DateTime.now());
     // Dispatch event to update contact in BLoC
     context.read<ContactListBloc>().add(
        ContactListEvent.updateContactFromList(updatedContact)); // Pass the updated contact
      // Optional: Show a quick confirmation SnackBar
      // Clear previous snackbars to avoid buildup if user swipes rapidly
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
             content: Text('Marked ${contact.firstName} as contacted.'),
             duration: const Duration(seconds: 2),
         ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final bool isContactOverdue = isOverdue(contact.frequency, contact.lastContacted);

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
             title: Text('${contact.firstName} ${contact.lastName}'),
             subtitle: Text(
                calculateNextDueDateDisplay(
                   contact.lastContacted, contact.frequency),
                style: const TextStyle(fontSize: 12)),
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