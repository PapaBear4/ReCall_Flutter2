// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/main.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/repositories/usersettings_repository.dart';
import 'package:recall/screens/about_screen.dart';
import 'package:recall/screens/contact_import_selection_screen.dart';
import 'package:recall/screens/contact_list_screen.dart';
import 'package:recall/blocs/contact_details/contact_details_bloc.dart';
import 'package:recall/screens/contact_details_screen.dart';
import 'package:recall/services/notification_service.dart';
import 'package:recall/screens/settings_screen.dart';
import 'package:recall/screens/home_screen.dart';
import 'package:recall/utils/logger.dart'; // Import HomeScreen

class ReCall extends StatelessWidget {
  final ContactRepository _contactRepository;
  final UserSettingsRepository _userSettingsRepository;

  const ReCall({
    super.key,
    required ContactRepository contactRepository,
    required UserSettingsRepository userSettingsRepository,
  })  : _contactRepository = contactRepository,
        _userSettingsRepository = userSettingsRepository;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: context.read<NotificationService>(),
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider<ContactRepository>.value(
                value: _contactRepository),
            RepositoryProvider<UserSettingsRepository>.value(
                value: _userSettingsRepository),
            BlocProvider(
              create: (context) {
                logger.i('LoadContactListEvent triggered in app.dart');
                return ContactListBloc(
                  contactRepository: _contactRepository,
                  notificationService: context.read<NotificationService>(),
                )..add(const LoadContactListEvent(
                    filters: {ContactListFilterType.active},
                    sortField: ContactListSortField.nextContactDate,
                    ascending: true, // Most overdue first
                  ));
              },
            ),
            BlocProvider(
              create: (context) => ContactDetailsBloc(
                contactRepository: _contactRepository,
                notificationService: context.read<NotificationService>(),
              ),
            ),
          ],
          child: MaterialApp(
            navigatorKey: navigatorKey, // Assign the global key here
            // Set the title of the app.
            title: 'reCall App',
            // Set the theme of the app.
            theme: ThemeData(
              // Use ColorScheme.fromSeed for Material 3
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF5592D9), // Use hex code from SCSS
              ),
              useMaterial3: true, // Keep this enabled
            ),
            // Set the initial route of the app.
            home: const HomeScreen(), // Changed to HomeScreen
            // Define the routes for the app.
            routes: {
              '/contactDetails': (context) =>
                  const ContactDetailsScreen(contactId: 0),
              '/settings': (context) => const SettingsScreen(),
              '/about': (context) => const AboutScreen(),
              '/importContacts': (context) =>
                  const ContactImportSelectionScreen(),
              '/contactListFull': (context) =>
                  const ContactListScreen(), // Added route for full contact list
            },
          ),
        ));
  }
}
