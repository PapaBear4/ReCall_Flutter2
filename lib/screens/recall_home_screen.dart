import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_state.dart';
import 'package:recall/screens/widgets/contact_list_item.dart';

class ReCallHomeScreen extends StatelessWidget {
  const ReCallHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a constant for a very distant future date for sorting nulls
    final distantFuture = DateTime(9999);

    return Scaffold(
      appBar: AppBar(
        title: const Text('reCall Home - Due Today/Overdue'),
        actions: [
          // Optional: Add navigation to other screens like All Contacts or Settings
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'All Contacts',
            onPressed: () {
              Navigator.pushNamed(context, '/allContacts');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: BlocBuilder<ContactListBloc, ContactListState>(
        builder: (context, state) {
          if (state is Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is Loaded) {
            final allContacts = state.displayedContacts;
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final dueContacts = allContacts.where((contact) {
              final nextContactDate = contact.nextContact;
              if (nextContactDate == null) return false;
              final nextContactDay = DateTime(nextContactDate.year, nextContactDate.month, nextContactDate.day);
              return nextContactDay.isAtSameMomentAs(today) || nextContactDay.isBefore(today);
            }).toList();

            dueContacts.sort((a, b) => (a.nextContact ?? distantFuture)
                .compareTo(b.nextContact ?? distantFuture));

            if (dueContacts.isEmpty) {
              return const Center(
                child: Text('No contacts due today or overdue.'),
              );
            }

            return ListView.builder(
              itemCount: dueContacts.length,
              itemBuilder: (context, index) {
                final contact = dueContacts[index];
                return ContactListItem(contact: contact);
              },
            );
          } else if (state is Error) {
            return Center(child: Text('Error loading contacts: ${state.message}'));
          } else if (state is Initial) {
            return const Center(child: Text('Initializing contact list...'));
          } else if (state is Empty) {
            return const Center(child: Text('No contacts found.'));
          } else {
            return const Center(child: Text('Loading contacts...'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/importContacts');
        },
        tooltip: 'Import Contacts',
        child: const Icon(Icons.add),
      ),
    );
  }
}
