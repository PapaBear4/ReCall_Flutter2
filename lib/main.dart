import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ReCall/blocs/contact_list/contact_list_bloc.dart';
import 'package:ReCall/repositories/contact_repository.dart';
import 'package:ReCall/screens/contact_list_screen.dart';
import 'package:ReCall/blocs/contact_details/contact_details_bloc.dart';
import 'package:ReCall/screens/contact_details_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
