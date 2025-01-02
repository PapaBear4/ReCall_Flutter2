import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:intl/intl.dart';
import 'package:recall/utils/last_contacted_helper.dart';
import 'package:logger/logger.dart';

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
              context.read<ContactListBloc>().add(LoadContacts());
            },
          ),
        ],
      ),
      // BlocBuilder listens to changes in ContactListBloc state.
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ContactListBloc>().add(LoadContacts());
        },
        child: BlocBuilder<ContactListBloc, ContactListState>(
          builder: (context, state) {
            // Displays a loading indicator while fetching contacts.
            if (state is ContactListEmpty) {
              return const Center(child: Text('No contacts available'));
            } else if (state is ContactListLoading) {
              return const Center(child: CircularProgressIndicator());
              // Displays a list of contacts if data is loaded successfully.
            } else if (state is ContactListLoaded) {
              return ListView.builder(
                itemCount: state.contacts.length,
                itemBuilder: (context, index) {
                  final contact = state.contacts[index];
                  return Column(
                    children: [
                      // ListTile displays each contact's information.
                      ListTile(
                        title: Text('${contact.firstName} ${contact.lastName}'),
                        subtitle: Text(
                          contact.birthday != null
                              ? DateFormat('MM/dd').format(contact.birthday!)
                              : '',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing:
                            Text(formatLastContacted(contact.lastContacted)),
                        onTap: () {
                          // Navigate to the contact details screen
                          contactListScreenLogger.i(
                              'LOG: Navigating to details for contact ID: ${contact.id}'); // <-- Add this line
                          Navigator.pushNamed(
                            context,
                            '/contactDetails',
                            arguments: contact.id,
                          );
                        },
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
            } else if (state is ContactListError) {
              // Displays an error message if fetching contacts fails.
              return Center(child: Text(state.message));
            }
            // Fallback widget if the state is not recognized.
            return Container();
          },
        ),
      ),
      // Floating action button for adding a new contact.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the add contact screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
