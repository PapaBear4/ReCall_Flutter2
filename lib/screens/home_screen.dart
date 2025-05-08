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
      handleListAction:
          (_, __, ___) {}, // Provide an empty callback for list actions
    );
  }
}

