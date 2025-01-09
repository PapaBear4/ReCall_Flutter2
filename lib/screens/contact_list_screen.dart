import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recall/blocs/contact_details/contact_details_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:intl/intl.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/utils/last_contacted_helper.dart';
import 'package:recall/models/contact_frequency.dart';
import 'package:logger/logger.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

var contactListScreenLogger = Logger();

// Widget representing the contact list screen.
class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the basic structure of the screen.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context
                  .read<ContactListBloc>()
                  .add(ContactListEvent.loadContacts());
            },
          ),
        ],
      ),
      // BlocBuilder listens to changes in ContactListBloc state.
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ContactListBloc>().add(ContactListEvent.loadContacts());
        },
        child: BlocBuilder<ContactListBloc, ContactListState>(
            builder: (context, state) {
          return state.map(
            initial: (_) => const Center(child: CircularProgressIndicator()),
            empty: (_) => const Center(child: Text('No contacts available')),
            loading: (_) => const Center(child: CircularProgressIndicator()),
            loaded: (loadedState) => _contactList(loadedState.contacts),
            error: (errorState) => Center(child: Text(errorState.message)),
          );
        }),
      ),
      // Floating action button for adding a new contact.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Load up a new contact in the details bloc
          context
              .read<ContactDetailsBloc>()
              .add(ContactDetailsEvent.clearContact());
          // Navigate to the add contact screen
          Navigator.pushNamed(context, '/contactDetails',
              arguments: 0); // Pass null to prevent errors
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Widget _contactList(List<Contact> contacts) {
  return ListView.builder(
    itemCount: contacts.length,
    itemBuilder: (context, index) {
      final contact = contacts[index];
      return Column(
        children: [
          // ListTile displays each contact's information.
          Slidable(
            key: UniqueKey(),
            endActionPane: ActionPane(motion: const DrawerMotion(), children: [
              SlidableAction(
                onPressed: (context) {
                  final updatedContact =
                      contact.copyWith(lastContacted: DateTime.now());
                  context.read<ContactListBloc>().add(
                      ContactListEvent.updateContactFromList(updatedContact));
                },
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                icon: Icons.check,
                label: 'Tap to mark Contacted',
              ),
            ]),
            startActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    final updatedContact =
                        contact.copyWith(lastContacted: DateTime.now());
                    context.read<ContactListBloc>().add(
                        ContactListEvent.updateContactFromList(updatedContact));
                  },
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  icon: Icons.check,
                  label: 'Tap to mark Contacted',
                ),
              ],
            ),
            child: ListTile(
              title: Text('${contact.firstName} ${contact.lastName}'),
              subtitle: Text(
                contact.birthday != null
                    ? DateFormat('MM/dd').format(contact.birthday!)
                    : '',
                style: const TextStyle(fontSize: 12),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatLastContacted(contact.lastContacted),
                    style: isOverdue(contact.frequency, contact.lastContacted)
                        ? const TextStyle(color: Colors.red)
                        : null,
                  ),
                  Text(
                      contact.frequency != ContactFrequency.never.value
                          ? contact.frequency
                          : 'Frequency not set',
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
              onTap: () {
                // Navigate to the contact details screen with the
                // arguement being the contact ID
                Navigator.pushNamed(
                  context,
                  '/contactDetails',
                  arguments: contact.id,
                );
              },
            ),
          ),
          // Divider separates each contact in the list.
          const Divider(
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
            color: Colors.grey,
          ),
        ],
      );
    },
  );
}
