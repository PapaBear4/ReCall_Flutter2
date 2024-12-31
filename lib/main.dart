import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/screens/contact_list_screen.dart';
import 'package:recall/blocs/contact_details/contact_details_bloc.dart';
import 'package:recall/screens/contact_details_screen.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(const ReCall());
  var logger = Logger();
  logger.i("LOG:App started");
}

class ReCall extends StatelessWidget {
  const ReCall({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ContactRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ContactListBloc(
              contactRepository:
                  RepositoryProvider.of<ContactRepository>(context),
            )..add(LoadContacts()),
          ),
          BlocProvider(
            create: (context) => ContactDetailsBloc(
              contactRepository:
                  RepositoryProvider.of<ContactRepository>(context),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Contact App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const ContactListScreen(),
          routes: {
            '/contactDetails': (context) =>
                const ContactDetailsScreen(contactId: 0),
          },
        ),
      ),
    );
  }
}
