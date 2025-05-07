import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/widgets/base_contact_list_scaffold.dart';
import 'package:recall/screens/help_screen.dart'; // For HelpSection

// Common ListAction enum is in base_contact_list_scaffold.dart

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static void _handleHomeScreenListAction(ListAction action, BuildContext context, TextEditingController searchController) {
    final bloc = context.read<ContactListBloc>();
    switch (action) {
      case ListAction.sortByDueDateAsc:
        bloc.add(const SortContactsEvent(sortField: ContactListSortField.dueDate, ascending: true));
        break;
      case ListAction.sortByDueDateDesc:
        bloc.add(const SortContactsEvent(sortField: ContactListSortField.dueDate, ascending: false));
        break;
      case ListAction.sortByLastNameAsc:
        bloc.add(const SortContactsEvent(sortField: ContactListSortField.lastName, ascending: true));
        break;
      case ListAction.sortByLastNameDesc:
        bloc.add(const SortContactsEvent(sortField: ContactListSortField.lastName, ascending: false));
        break;
      case ListAction.filterOverdue: // Show only overdue
        bloc.add(const ClearFiltersEvent()); // Clear others first
        bloc.add(const ApplyFilterEvent(filterType: ContactListFilterType.overdue, isActive: true));
        break;
      case ListAction.filterDueSoon: // Show only due soon
        bloc.add(const ClearFiltersEvent()); // Clear others first
        bloc.add(const ApplyFilterEvent(filterType: ContactListFilterType.dueSoon, isActive: true));
        break;
      case ListAction.filterClear: // Reset to default home view
        searchController.clear(); // Clear search field as well
        bloc.add(const LoadHomeScreenContactsEvent());
        break;
      default:
        // sortByLastContactedAsc, sortByLastContactedDesc not typically on home, but can be added if needed
        break;
    }
  }

  static List<PopupMenuEntry<ListAction>> _buildSortMenuItems(BuildContext context) {
    return [
      const PopupMenuItem<ListAction>(value: ListAction.sortByDueDateAsc, child: Text('Sort by Due Date (Soonest)')),
      const PopupMenuItem<ListAction>(value: ListAction.sortByDueDateDesc, child: Text('Sort by Due Date (Latest)')),
      const PopupMenuItem<ListAction>(value: ListAction.sortByLastNameAsc, child: Text('Sort by Last Name (A-Z)')),
      const PopupMenuItem<ListAction>(value: ListAction.sortByLastNameDesc, child: Text('Sort by Last Name (Z-A)')),
    ];
  }

  static List<PopupMenuEntry<ListAction>> _buildFilterMenuItems(BuildContext context) {
    return [
      const PopupMenuItem<ListAction>(value: ListAction.filterOverdue, child: Text('Show Overdue Only')),
      const PopupMenuItem<ListAction>(value: ListAction.filterDueSoon, child: Text('Show Due Soon Only')),
      const PopupMenuItem<ListAction>(value: ListAction.filterClear, child: Text('Reset Default View')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BaseContactListScaffold(
      screenTitle: 'Upcoming Reminders',
      emptyListText: 'No upcoming or overdue reminders.',
      onRefreshEvent: const LoadHomeScreenContactsEvent(),
      drawerWidget: buildAppDrawer(context, true), // Pass true for home
      sortMenuItems: _buildSortMenuItems,
      filterMenuItems: _buildFilterMenuItems,
      handleListAction: _handleHomeScreenListAction,
      fabHeroTagPrefix: 'home',
      // initialScreenLoadEvent is handled by app.dart for HomeScreen
    );
  }
}

// Drawer can be a shared utility or defined per screen if differences are significant
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
              // Dispatch event to ensure home screen loads its specific data
              context.read<ContactListBloc>().add(const LoadHomeScreenContactsEvent());
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