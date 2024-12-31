import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/blocs/contact_list/contact_list_bloc.dart';
import 'package:intl/intl.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: BlocBuilder<ContactListBloc, ContactListState>(
        builder: (context, state) {
          if (state is ContactListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ContactListLoaded) {
            return ListView.builder(
              itemCount: state.contacts.length,
              itemBuilder: (context, index) {
                final contact = state.contacts[index];
                return Column(
                  children: [
                    ListTile(
                      title: Align(
                        alignment: Alignment.topLeft,
                        child: Text('${contact.firstName} ${contact.lastName}'),
                      ),
                      subtitle: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          contact.birthday != null
                              ? DateFormat('MM/dd').format(contact.birthday!)
                              : '',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      trailing: contact.lastContacted != null
                          ? Text(
                              DateFormat('MM/dd/yyyy')
                                  .format(contact.lastContacted!),
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey))
                          : null,
                      onTap: () {
                        // Navigate to the contact details screen
                      },
                    ),
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
            return Center(child: Text(state.message));
          }
          return Container(); // Or a more appropriate fallback widget
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the add contact screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
