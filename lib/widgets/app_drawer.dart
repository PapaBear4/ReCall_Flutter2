import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/repositories/usersettings_repository.dart';
import 'package:recall/widgets/debug_widgets.dart'; // Import DebugOptionsTile
import 'package:flutter/foundation.dart'; // For kDebugMode

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
            Navigator.pop(context);
            if (!isHome) {
              context.read<ContactListBloc>().add(const LoadContactsEvent(
                    filters: {ContactListFilterType.active},
                    sortField: ContactListSortField.nextContactDate,
                    ascending: true,
                  ));
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.contacts),
          title: const Text('All Contacts'),
          selected: !isHome &&
              ModalRoute.of(context)?.settings.name == '/contactListFull',
          onTap: () {
            Navigator.pop(context);
            if (ModalRoute.of(context)?.settings.name != '/contactListFull') {
              context.read<ContactListBloc>().add(const LoadContactsEvent());
              Navigator.pushNamed(context, '/contactListFull');
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/settings');
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('About'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/about');
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