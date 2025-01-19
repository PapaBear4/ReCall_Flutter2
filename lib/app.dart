// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/screens/contact_list_screen.dart';
import 'package:recall/blocs/contact_details/contact_details_bloc.dart';
import 'package:recall/screens/contact_details_screen.dart';
import 'package:recall/services/notification_service.dart';

final logger = Logger();

class ReCall extends StatelessWidget {
  final ContactRepository _contactRepository; // Add contactRepository parameter
  final NotificationService _notificationService;

  const ReCall(
      {super.key,
      required ContactRepository contactRepository,
      required NotificationService notificationService})
      : _contactRepository = contactRepository,
        _notificationService = notificationService;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ContactRepository>.value(value: _contactRepository),
        RepositoryProvider<NotificationService>.value(
            value: _notificationService),
      ],
      // Use RepositoryProvider.value
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ContactListBloc(
              contactRepository:
                  _contactRepository, // Access repository directly
                  notificationService: _notificationService,
            )..add(const ContactListEvent.loadContacts()),
          ),
          BlocProvider(
            create: (context) => ContactDetailsBloc(
              contactRepository:
                  _contactRepository, // Access repository directly
                  notificationService:_notificationService,
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
