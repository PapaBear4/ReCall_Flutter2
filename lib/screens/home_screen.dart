import 'package:flutter/material.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/widgets/app_drawer.dart';
import 'package:recall/widgets/base_contact_list_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseContactListScaffold(
      screenTitle: 'reCall Home',
      emptyListText: 'No upcoming or overdue reminders.',
      // Always load active contacts that are overdue, due today, or due tomorrow
      onRefreshEvent: const LoadContactListEvent(
        filters: {ContactListFilterType.homescreen},
        sortField: ContactListSortField.nextContactDate,
        ascending: true, // Most overdue first
      ),
      initialScreenLoadEvent: const LoadContactListEvent(
        filters: {ContactListFilterType.homescreen},
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
      handleListAction:
          (_, __, ___) {}, // Provide an empty callback for list actions
      debugRefreshEvent: const LoadContactListEvent(
        filters: {ContactListFilterType.homescreen},
        sortField: ContactListSortField.nextContactDate,
        ascending: true, // Most overdue first
      ),
      appBarActions: [
        TextButton(
          onPressed: () {
            /*/ Dispatch event to load all active contacts for the ContactListScreen
            context.read<ContactListBloc>().add(
                  const LoadContactListEvent(
                    filters: {
                      ContactListFilterType.active
                    }, // Show active contacts
                    sortField: ContactListSortField
                        .lastName, // Default sort for all contacts
                    ascending: true,
                  ),
                );*/
            // Navigate to the ContactListScreen
            // Ensure you have a route named '/contactList' or use MaterialPageRoute
            Navigator.pushNamed(context, '/contactListFull');
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'ALL',
                style: TextStyle(
                  // Adapting to AppBar's brightness or using a fixed color
                  color: Theme.of(context).appBarTheme.titleTextStyle?.color ??
                      const Color.fromARGB(255, 98, 3, 241),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4), // Spacing between text and icon
              Icon(
                Icons.arrow_forward_ios,
                size: 16.0,
                color: Theme.of(context).appBarTheme.iconTheme?.color ??
                    const Color.fromARGB(255, 20, 5, 191),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
