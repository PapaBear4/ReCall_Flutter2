// lib/screens/contact_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/widgets/base_contact_list_scaffold.dart';
import 'package:recall/screens/home_screen.dart' show buildAppDrawer; 

// Common ListAction enum is in base_contact_list_scaffold.dart

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  static void _handleAllContactsListAction(ListAction action, BuildContext context, TextEditingController searchController) {
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
      case ListAction.sortByLastContactedAsc:
        bloc.add(const SortContactsEvent(sortField: ContactListSortField.lastContacted, ascending: true));
        break;
      case ListAction.sortByLastContactedDesc:
        bloc.add(const SortContactsEvent(sortField: ContactListSortField.lastContacted, ascending: false));
        break;
      case ListAction.filterOverdue:
        bloc.add(const ApplyFilterEvent(filterType: ContactListFilterType.overdue, isActive: true));
        break;
      case ListAction.filterDueSoon:
        bloc.add(const ApplyFilterEvent(filterType: ContactListFilterType.dueSoon, isActive: true));
        break;
      case ListAction.filterClear:
        searchController.clear(); // Clear search field as well
        bloc.add(const ClearFiltersEvent());
        break;
    }
  }

  static List<PopupMenuEntry<ListAction>> _buildSortMenuItems(BuildContext context) {
    return [
      const PopupMenuItem<ListAction>(value: ListAction.sortByDueDateAsc, child: Text('Sort by Due Date (Soonest)')),
      const PopupMenuItem<ListAction>(value: ListAction.sortByDueDateDesc, child: Text('Sort by Due Date (Latest)')),
      const PopupMenuItem<ListAction>(value: ListAction.sortByLastNameAsc, child: Text('Sort by Last Name (A-Z)')),
      const PopupMenuItem<ListAction>(value: ListAction.sortByLastNameDesc, child: Text('Sort by Last Name (Z-A)')),
      const PopupMenuItem<ListAction>(value: ListAction.sortByLastContactedAsc, child: Text('Sort by Last Contacted (Oldest)')),
      const PopupMenuItem<ListAction>(value: ListAction.sortByLastContactedDesc, child: Text('Sort by Last Contacted (Newest)')),
    ];
  }

  static List<PopupMenuEntry<ListAction>> _buildFilterMenuItems(BuildContext context) {
    return [
      const PopupMenuItem<ListAction>(value: ListAction.filterOverdue, child: Text('Filter: Overdue')),
      const PopupMenuItem<ListAction>(value: ListAction.filterDueSoon, child: Text('Filter: Due Soon')),
      const PopupMenuItem<ListAction>(value: ListAction.filterClear, child: Text('Clear Filters')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BaseContactListScaffold(
      screenTitle: 'All Contacts',
      emptyListText: 'No contacts found. Add some!',
      onRefreshEvent: const LoadContactsEvent(),
      drawerWidget: buildAppDrawer(context, false), 
      sortMenuItems: _buildSortMenuItems,
      filterMenuItems: _buildFilterMenuItems,
      handleListAction: _handleAllContactsListAction,
      fabHeroTagPrefix: 'all_contacts',
      initialScreenLoadEvent: const LoadContactsEvent(), 
      displayActiveStatusInList: true, // Show indicator on this screen
    );
  }
}
