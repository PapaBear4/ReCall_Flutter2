// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/screens/contact_list_screen.dart';
import 'package:recall/blocs/contact_details/contact_details_bloc.dart';
import 'package:recall/screens/contact_details_screen.dart';
import 'package:recall/services/notification_service.dart';

final logger = Logger();

class ReCall extends StatelessWidget {
  final ContactRepository _contactRepository;

  const ReCall({super.key, required ContactRepository contactRepository})
      : _contactRepository = contactRepository;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: context.read<NotificationService>(),
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider<ContactRepository>.value(
                value: _contactRepository),
            BlocProvider(
              create: (context) => ContactListBloc(
                contactRepository: _contactRepository,
                notificationService: context.read<NotificationService>(),
              )..add(const ContactListEvent.loadContacts()),
            ),
            BlocProvider(
              create: (context) => ContactDetailsBloc(
                contactRepository: _contactRepository,
                notificationService: context.read<NotificationService>(),
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
          ),
        ));
  }
}
