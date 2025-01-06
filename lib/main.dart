import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/screens/contact_list_screen.dart';
import 'package:recall/blocs/contact_details/contact_details_bloc.dart';
import 'package:recall/screens/contact_details_screen.dart';
import 'package:logger/logger.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'objectbox.g.dart'; // Import the generated ObjectBox model

late final Store store; // Declare the store

Future<Store> openStore() async {
  final docsDir = await getApplicationDocumentsDirectory();
  return Store(getObjectBoxModel(), directory: '${docsDir.path}/objectbox');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized

  store = await openStore(); // Initialize the store

  runApp(ReCall(
      contactRepository:
          ContactRepository(store))); // Pass the store to the repository
  var logger = Logger();
  logger.i('LOG:App started');
}

class ReCall extends StatelessWidget {
  final ContactRepository _contactRepository; // Add contactRepository parameter

  const ReCall({super.key, required ContactRepository contactRepository})
      : _contactRepository = contactRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      // Use RepositoryProvider.value
      value: _contactRepository, // Provide the initialized repository
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ContactListBloc(
              contactRepository:
                  _contactRepository, // Access repository directly
            )..add(const ContactListEvent.loadContacts()),
          ),
          BlocProvider(
            create: (context) => ContactDetailsBloc(
              contactRepository:
                  _contactRepository, // Access repository directly
            ),
          ),
        ],
        child: MaterialApp(
          // Set the title of the app.
          title: 'Contact App',
          // Set the theme of the app.
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          // Set the initial route of the app.
          home: const ContactListScreen(),
          // Define the routes for the app.
          routes: {
            '/contactDetails': (context) =>
                const ContactDetailsScreen(contactId: 0),
          },
          // ... (rest of your MaterialApp) ...
        ),
      ),
    );
  }
}
