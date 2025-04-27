// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_event.dart';
import 'package:recall/main.dart';
import 'package:recall/services/service_locator.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/repositories/usersettings_repository.dart';
import 'package:recall/screens/about_screen.dart';
import 'package:recall/screens/contact_import_selection_screen.dart';
import 'package:recall/screens/contact_list_screen.dart';
import 'package:recall/blocs/contact_details/contact_details_bloc.dart';
import 'package:recall/screens/contact_details_screen.dart';
import 'package:recall/services/notification_service.dart';
import 'package:recall/screens/settings_screen.dart';

class ReCall extends StatelessWidget {
  const ReCall({super.key});

  @override
  Widget build(BuildContext context) {
    final contactRepository = getIt<ContactRepository>();
    final userSettingsRepository = getIt<UserSettingsRepository>();
    final notificationService = getIt<NotificationService>();

    return ChangeNotifierProvider.value(
        value: notificationService,
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider<ContactRepository>.value(
                value: contactRepository),
            RepositoryProvider<UserSettingsRepository>.value(
                value: userSettingsRepository),
            BlocProvider(
              create: (context) => ContactListBloc()
                ..add(const LoadContacts()),
            ),
            BlocProvider(
              create: (context) => ContactDetailsBloc(),
            ),
          ],
          child: MaterialApp(
            navigatorKey: navigatorKey,
            title: 'reCall App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF5592D9),
              ),
              useMaterial3: true,
            ),
            home: const ContactListScreen(),
            routes: {
              '/contactDetails': (context) =>
                  const ContactDetailsScreen(contactId: 0),
              '/settings': (context) => const SettingsScreen(),
              '/about': (context) => const AboutScreen(),
              '/importContacts': (context) =>
                  const ContactImportSelectionScreen(),
            },
          ),
        ));
  }
}
