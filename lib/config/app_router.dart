// lib/config/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recall/main.dart'; // Import main.dart to access the global navigatorKey
import 'package:recall/screens/home_screen.dart';
import 'package:recall/screens/contact_list_screen.dart';
import 'package:recall/screens/contact_details_screen.dart';
import 'package:recall/screens/settings_screen.dart';
import 'package:recall/screens/about_screen.dart';
import 'package:recall/screens/contact_import_selection_screen.dart';
import 'package:recall/screens/scheduled_notifications_screen.dart'; // For debug
import 'package:recall/utils/logger.dart';

// MARK: - Router Configuration
class AppRouter {
  static final _rootNavigatorKey =
      navigatorKey; // Use the global key from main.dart

  // Using route names is a good practice for type-safe navigation
  // and makes it easier to manage routes.
  static const String homeRouteName = 'home';
  static const String contactListRouteName = 'contacts';
  static const String contactDetailsRouteName = 'contact-details';
  static const String newContactRouteName = 'new-contact';
  static const String settingsRouteName = 'settings';
  static const String aboutRouteName = 'about';
  static const String importContactsRouteName = 'import-contacts';
  static const String debugNotificationsRouteName = 'debug-notifications';

  // MARK: - GoRouter Instance
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey, // Assigning the global navigator key
    initialLocation: '/', // Initial route
    debugLogDiagnostics: true, // Useful for debugging routing issues
    routes: <RouteBase>[
      // MARK: - Home Route
      GoRoute(
        name: homeRouteName,
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
        routes: <RouteBase>[
          // MARK: - Contact List Route (Full List)
          // This is nested under home but could be top-level if preferred.
          // For now, keeping it similar to your existing structure where
          // "ALL" button on HomeScreen navigates to a full list.
          GoRoute(
            name: contactListRouteName,
            path: 'contacts', // Path will be /contacts
            builder: (BuildContext context, GoRouterState state) {
              return const ContactListScreen();
            },
          ),
          // MARK: - Contact Details Route
          GoRoute(
            name: contactDetailsRouteName,
            path: 'contact/:id', // Path will be /contact/123
            builder: (BuildContext context, GoRouterState state) {
              final String? idString = state.pathParameters['id'];
              final int contactId = int.tryParse(idString ?? '0') ?? 0;
              // Pass contactId to the screen.
              // The screen will need to be updated to accept this.
              return ContactDetailsScreen(contactId: contactId);
            },
          ),
          // MARK: - New Contact Route
          GoRoute(
            name: newContactRouteName,
            path: 'new-contact', // Path will be /new-contact
            builder: (BuildContext context, GoRouterState state) {
              // Pass 0 or null to indicate a new contact, similar to current logic.
              // The screen will need to be updated to accept this.
              return const ContactDetailsScreen(contactId: 0);
            },
          ),
          // MARK: - Settings Route
          GoRoute(
            name: settingsRouteName,
            path: 'settings', // Path will be /settings
            builder: (BuildContext context, GoRouterState state) {
              return const SettingsScreen();
            },
          ),
          // MARK: - About Route
          GoRoute(
            name: aboutRouteName,
            path: 'about', // Path will be /about
            builder: (BuildContext context, GoRouterState state) {
              return const AboutScreen();
            },
          ),
          // MARK: - Import Contacts Route
          GoRoute(
            name: importContactsRouteName,
            path: 'import-contacts', // Path will be /import-contacts
            builder: (BuildContext context, GoRouterState state) {
              return const ContactImportSelectionScreen();
            },
          ),
          // MARK: - Debug Scheduled Notifications Route
          GoRoute(
            name: debugNotificationsRouteName,
            path: 'debug/notifications', // Path will be /debug/notifications
            builder: (BuildContext context, GoRouterState state) {
              return const ScheduledNotificationsScreen();
            },
          ),
        ],
      ),
    ],
    
    // MARK: - Redirection Logic
    redirect: (BuildContext context, GoRouterState state) {
      // Check if there's an initial payload from a terminated notification launch
      if (initialNotificationPayload != null) {
        logger.i(
            'Redirect: Detected initial payload: $initialNotificationPayload');
        final payload = initialNotificationPayload;
        initialNotificationPayload = null; // Consume the payload!

        if (payload != null && payload.startsWith('contact_id:')) {
          final idString = payload.split(':').last;
          final contactId = int.tryParse(idString);

          if (contactId != null && contactId != 0) {
            // Ensure we are not already trying to go there to avoid loops
            final targetPath = '/contact/$contactId';
            if (state.uri.toString() != targetPath) {
              logger.i(
                  'Redirect: Redirecting to $targetPath from initial payload.');
              return targetPath; // Redirect to the contact details screen
            } else {
              logger.i(
                  'Redirect: Already at target path $targetPath, no redirection needed.');
            }
          } else {
            logger.w(
                'Redirect: Failed to parse contactId from payload: $payload');
          }
        }
      }
      // No redirection needed, proceed to the original location
      return null;
    },

// MARK: - Error Handling
    errorBuilder: (context, state) {
      logger.e('Routing error: No route found for ${state.uri.toString()}');
      return Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(
          child: Text('Oops! The page ${state.uri.toString()} was not found.'),
        ),
      );
    },
  );
}
