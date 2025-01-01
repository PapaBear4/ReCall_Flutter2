import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/screens/contact_list_screen.dart';
import 'package:recall/blocs/contact_details/contact_details_bloc.dart';
import 'package:recall/screens/contact_details_screen.dart';
import 'package:logger/logger.dart';

void main() {
  // Run the app and initialize the logger.
  runApp(const ReCall());
  var logger = Logger();
  logger.i('LOG:App started'); // Log the app start event.
}

// This is the root widget of the application.
class ReCall extends StatelessWidget {
  const ReCall({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Provide the ContactRepository to all child widgets.
    return RepositoryProvider(
      create: (context) => ContactRepository(),
      // Provide multiple Blocs to the app.
      child: MultiBlocProvider(
        providers: [
          // Provide the ContactListBloc to manage the list of contacts.
          BlocProvider(
            create: (context) => ContactListBloc(
              contactRepository:
                  RepositoryProvider.of<ContactRepository>(context),
            )..add(LoadContacts()),
          ),
          // Provide the ContactDetailsBloc to manage contact details.
          BlocProvider(
            create: (context) => ContactDetailsBloc(
              contactRepository:
                  RepositoryProvider.of<ContactRepository>(context),
            ),
          ),
        ],
        // Build the MaterialApp widget.
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
        ),
      ),
    );
  }
}
