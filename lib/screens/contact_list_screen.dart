// lib/screens/contact_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/widgets/base_contact_list_scaffold.dart';

// Common ListAction enum is in base_contact_list_scaffold.dart

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  bool _includeArchived = false; // Toggle state for showing archived contacts
  final TextEditingController _searchController = TextEditingController(); // Controller for search input

  static void _handleAllContactsListAction(ListAction action,
      BuildContext context, TextEditingController searchController) {
    final bloc = context.read<ContactListBloc>();

    // Define default parameters for LoadContactListEvent
    String searchTerm = searchController.text;
    Set<ContactListFilterType> filters = {ContactListFilterType.active};
    ContactListSortField sortField = ContactListSortField.lastName;
    bool ascending = true;

    // Update parameters based on the selected action
    switch (action) {
      case ListAction.sortByDueDateAsc:
        sortField = ContactListSortField.nextContactDate;
        ascending = true;
        break;
      case ListAction.sortByDueDateDesc:
        sortField = ContactListSortField.nextContactDate;
        ascending = false;
        break;
      case ListAction.sortByLastNameAsc:
        sortField = ContactListSortField.lastName;
        ascending = true;
        break;
      case ListAction.sortByLastNameDesc:
        sortField = ContactListSortField.lastName;
        ascending = false;
        break;
      case ListAction.sortByLastContactedAsc:
        sortField = ContactListSortField.lastContacted;
        ascending = true;
        break;
      case ListAction.sortByLastContactedDesc:
        sortField = ContactListSortField.lastContacted;
        ascending = false;
        break;
      case ListAction.filterOverdue:
        filters.add(ContactListFilterType.overdue);
        break;
      case ListAction.filterDueSoon:
        filters.add(ContactListFilterType.dueSoon);
        break;
      case ListAction.filterClear:
        searchController.clear(); // Clear search field as well
        searchTerm = '';
        filters = {};
        break;
    }

    // Dispatch the consolidated LoadContactListEvent
    // TODO: do I need this?
    bloc.add(LoadContactListEvent(
      searchTerm: searchTerm,
      filters: filters,
      sortField: sortField,
      ascending: ascending,
    ));
  }

  static List<PopupMenuEntry<ListAction>> _buildSortMenuItems(
      BuildContext context) {
    return [
      const PopupMenuItem<ListAction>(
          value: ListAction.sortByDueDateAsc,
          child: Text('Sort by Due Date (Soonest)')),
      const PopupMenuItem<ListAction>(
          value: ListAction.sortByDueDateDesc,
          child: Text('Sort by Due Date (Latest)')),
      const PopupMenuItem<ListAction>(
          value: ListAction.sortByLastNameAsc,
          child: Text('Sort by Last Name (A-Z)')),
      const PopupMenuItem<ListAction>(
          value: ListAction.sortByLastNameDesc,
          child: Text('Sort by Last Name (Z-A)')),
      const PopupMenuItem<ListAction>(
          value: ListAction.sortByLastContactedAsc,
          child: Text('Sort by Last Contacted (Oldest)')),
      const PopupMenuItem<ListAction>(
          value: ListAction.sortByLastContactedDesc,
          child: Text('Sort by Last Contacted (Newest)')),
    ];
  }

  static List<PopupMenuEntry<ListAction>> _buildFilterMenuItems(
      BuildContext context) {
    return [
      const PopupMenuItem<ListAction>(
          value: ListAction.filterOverdue, child: Text('Filter: Overdue')),
      const PopupMenuItem<ListAction>(
          value: ListAction.filterDueSoon, child: Text('Filter: Due Soon')),
      const PopupMenuItem<ListAction>(
          value: ListAction.filterClear, child: Text('Clear Filters')),
    ];
  }

  void _includeArchivedContacts() {
    setState(() {
      _includeArchived = !_includeArchived;
    });
    context.read<ContactListBloc>().add(LoadContactListEvent(
          filters: _includeArchived 
          ? {} 
          : {ContactListFilterType.active}, // Show only active contacts
        ));
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose the controller to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseContactListScaffold(
      screenTitle: 'All Contacts',
      emptyListText: 'No contacts found. Add some!',
    onRefreshEvent: LoadContactListEvent(
      searchTerm: _searchController.text, // Use the current search term
      filters: _includeArchived
          ? {} // No filters if archived contacts are included
          : {ContactListFilterType.active}, // Apply active filter otherwise
      sortField: ContactListSortField.lastName, // Use the current sort field
      ascending: true, // Use the current sort order
    ),
      sortMenuItems: _buildSortMenuItems,
      filterMenuItems: _buildFilterMenuItems,
      handleListAction: _handleAllContactsListAction,
      fabHeroTagPrefix: 'all_contacts',
      initialScreenLoadEvent:
          const LoadContactListEvent(filters: {ContactListFilterType.active}),
      displayActiveStatusInList: true, // Show indicator on this screen
      appBarActions: [
        IconButton(
          icon: Icon(
            _includeArchived ? Icons.visibility_off : Icons.visibility,
            color: const Color.fromARGB(255, 1, 255, 98),
          ),
          tooltip: _includeArchived ? 'Hide Archived' : 'Show Archived',
          onPressed: _includeArchivedContacts,
        ),
      ],
    );
  }
}
