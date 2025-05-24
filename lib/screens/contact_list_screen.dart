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
        sortField = ContactListSortField.lastContactDate;
        ascending = true;
        break;
      case ListAction.sortByLastContactedDesc:
        sortField = ContactListSortField.lastContactDate;
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
    return BlocBuilder<ContactListBloc, ContactListState>(
      builder: (context, state) {
        String screenTitleText = 'Active'; // Default title
        Color? screenTitleColor; // Default color (null, so AppBar uses its default)
        const int totalContacts = 18; // Use the fixed number 18

        if (state is LoadingContactListState || state is InitialContactListState) {
          screenTitleText = 'Active (...)';
        } else if (state is LoadedContactListState) {
          final activeContactCount = state.originalContacts.where((contact) => contact.isActive).length;

          if (state.isSelectionMode && state.selectedContacts.isNotEmpty) {
            // Title for selection mode is handled by _buildSelectionAppBar, so no specific text needed here for screenTitle
            // However, we pass the base title part to BaseContactListScaffold, which it might use or ignore depending on mode.
            // The actual dynamic title "X / Y active" with color changes is in _buildSelectionAppBar.
            // For the normal app bar (when not in selection mode), we set the title here.
            // We can keep screenTitleText as the base 'Active' and let _buildSelectionAppBar handle its own title.
            // Or, we can calculate the *potential* count here if we want the normal AppBar to also show it *before* selection mode is fully active in UI.
            // For now, let's assume the normal AppBar title remains simpler.
            // The color change for selection mode is handled in _buildSelectionAppBar.
            // The `screenTitle` for `BaseContactListScaffold` will be used by its normal AppBar.
            // The selection AppBar in `BaseContactListScaffold` constructs its own title and color.
            
            // Let's calculate the title for the normal app bar part, which will be shown if selection mode is exited.
            screenTitleText = 'Active ($activeContactCount / $totalContacts)';
            if (activeContactCount > totalContacts) {
              screenTitleColor = Colors.red;
            }

          } else {
            // Not in selection mode or no contacts selected, show current active count out of total
            screenTitleText = 'Active ($activeContactCount / $totalContacts)';
            if (activeContactCount > totalContacts) {
              screenTitleColor = Colors.red;
            }
          }
        } else if (state is EmptyContactListState) {
          screenTitleText = 'Active (0 / $totalContacts)';
          // 0 is not > 18, so no color change needed.
        }
        // For ErrorContactListState, it will use the default 'Active' and no color change.

        return BaseContactListScaffold(
          screenTitle: screenTitleText,
          screenTitleColor: screenTitleColor, // Pass the color to the scaffold
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
      },
    );
  }
}
