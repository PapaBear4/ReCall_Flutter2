import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recall/blocs/contact_details/contact_details_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/screens/scheduled_notifications_screen.dart';
import 'package:recall/utils/last_contacted_utils.dart';
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
      // Remove the original floatingActionButton property

      // Add the bottomNavigationBar
      bottomNavigationBar: BottomAppBar(
        child: Container( // Use Container for padding
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out items
            children: <Widget>[
              // Your static text
              const Expanded( // Allow text to take available space
                child: Text(
                  'Swipe/Tap list item to mark as contacted',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                  overflow: TextOverflow.ellipsis, // Prevent overflow on small screens
                ),
              ),
              const SizedBox(width: 10), // Add spacing between text and buttons
              // Keep your FloatingActionButtons here, maybe in a Row or Column
              Row( // Use a Row for the buttons
                mainAxisSize: MainAxisSize.min, // Take minimum space
                children: [
                   FloatingActionButton.small( // Use .small for less space
                    heroTag: "btn1", // Add unique heroTags
                    onPressed: () => _viewScheduledNotifications(context),
                    child: const Icon(Icons.notifications),
                  ),
                  const SizedBox(width: 8), // Space between buttons
                  FloatingActionButton.small( // Use .small for less space
                    heroTag: "btn2", // Add unique heroTags
                    onPressed: () {
                      context
                          .read<ContactDetailsBloc>()
                          .add(ContactDetailsEvent.updateContactLocally(
                              contact: Contact(
                            id: 0,
                            firstName: '',
                            lastName: '',
                            frequency: ContactFrequency.never.value,
                            birthday: null,
                            lastContacted: null,
                          )));
                      Navigator.pushNamed(context, '/contactDetails',
                          arguments: 0);
                    },
                    child: const Icon(Icons.add),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }}

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
                  calculateNextDueDateDisplay(
                      contact.lastContacted, contact.frequency),
                  style: const TextStyle(fontSize: 12)),
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
                // set the state of the detials bloc
                context.read<ContactDetailsBloc>().add(
                    ContactDetailsEvent.loadContact(contactId: contact.id!));
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

void _viewScheduledNotifications(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const ScheduledNotificationsScreen()));
  contactListScreenLogger.i('LOG: Show notifications button pushed');
}
