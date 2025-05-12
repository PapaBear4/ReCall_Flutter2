import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/repositories/usersettings_repository.dart';
import 'package:recall/widgets/debug_widgets.dart'; // Import DebugOptionsTile
import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:go_router/go_router.dart';
import 'package:recall/config/app_router.dart';

Widget buildAppDrawer(BuildContext context, bool isHome) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('ReCall',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Keep in touch',
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          selected: isHome,
          onTap: () {
            Navigator.pop(context); // Close the drawer
            // Navigate to home using go_router, replacing the current stack if not already home
            if (!isHome) {
              // context.goNamed clears the stack and goes to the route
              context.goNamed(AppRouter.homeRouteName);
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.contacts),
          title: const Text('All Contacts'),
          selected: !isHome &&
              GoRouter.of(context)
                      .routeInformationProvider
                      .value
                      .uri
                      .toString() ==
                  '/contacts', // Correct way to get location
          onTap: () {
            Navigator.pop(context);
            // Navigate using go_router, pushing onto the stack if not already there
            if (GoRouter.of(context)
                    .routeInformationProvider
                    .value
                    .uri
                    .toString() !=
                '/contacts') {
              context.read<ContactListBloc>().add(const LoadContactListEvent(
                    filters: {ContactListFilterType.active},
                  )); // Pre-load
              context.pushNamed(AppRouter.contactListRouteName);
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          selected: GoRouter.of(context)
                  .routeInformationProvider
                  .value
                  .uri
                  .toString() ==
              '/settings', // Select if current
          onTap: () {
            Navigator.pop(context);
            context.pushNamed(AppRouter.settingsRouteName); // Use pushNamed
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('About'),
          selected: GoRouter.of(context)
                  .routeInformationProvider
                  .value
                  .uri
                  .toString() ==
              '/about', // Select if current
          onTap: () {
            Navigator.pop(context);
            context.pushNamed(AppRouter.aboutRouteName); // Use pushNamed
          },
        ),
        if (kDebugMode) // Only show in debug mode
          const Divider(), // Visually separate debug options
        if (kDebugMode)
          DebugOptionsTile(
            contactRepo: context.read<ContactRepository>(),
            settingsRepo: context.read<UserSettingsRepository>(),
          ),
      ],
    ),
  );
}
