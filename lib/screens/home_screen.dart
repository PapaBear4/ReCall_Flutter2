import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/screens/help_screen.dart';
import 'package:recall/widgets/base_contact_list_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseContactListScaffold(
      screenTitle: 'reCall Home',
      emptyListText: 'No upcoming or overdue reminders.',
      // Always load active contacts that are overdue, due today, or due tomorrow
      onRefreshEvent: const LoadContactsEvent(
        filters: {ContactListFilterType.active},
        sortField: ContactListSortField.nextContactDate,
        ascending: true, // Most overdue first
      ),
      drawerWidget: buildAppDrawer(context, true),
      fabHeroTagPrefix: 'home',
      showSearchBar: false, // No search bar needed for this screen
      showFilterMenu: false, // No filter menu needed
      showSortMenu: false, // No sort menu needed
      sortMenuItems: (_) => [], // Provide an empty list for sort menu items
      filterMenuItems: (_) => [], // Provide an empty list for filter menu items
      handleListAction: (_, __, ___) {}, // Provide an empty callback for list actions
    );
  }
}

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
              Text('ReCall', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Keep in touch', style: TextStyle(color: Colors.white70, fontSize: 14)),
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
          selected: !isHome && ModalRoute.of(context)?.settings.name == '/contactListFull',
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
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('Help'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpScreen(initialSection: HelpSection.list)));
          },
        ),
      ],
    ),
  );
}