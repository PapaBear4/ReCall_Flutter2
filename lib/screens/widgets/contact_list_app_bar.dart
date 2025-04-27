import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recall/models/contact_enums.dart'; // For ContactListFilter
import 'package:recall/screens/contact_list_screen.dart'; // For ListAction

typedef ListActionCallback = void Function(ListAction action);
typedef VoidCallback = void Function();
typedef BoolCallback = void Function(bool value);

class ContactListAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool selectionMode;
  final int selectedCount;
  final VoidCallback onCancelSelection;
  final VoidCallback onDeleteSelected;
  final VoidCallback onMarkSelectedContacted;
  final BoolCallback onArchiveSelected;
  final ListActionCallback onListAction;
  final TextEditingController searchController;
  final bool isArchivedView; // To determine archive/unarchive action text

  const ContactListAppBar({
    super.key,
    required this.selectionMode,
    required this.selectedCount,
    required this.onCancelSelection,
    required this.onDeleteSelected,
    required this.onMarkSelectedContacted,
    required this.onArchiveSelected,
    required this.onListAction,
    required this.searchController,
    required this.isArchivedView,
  });

  @override
  Widget build(BuildContext context) {
    return selectionMode
        ? _buildSelectionAppBar(context)
        : _buildNormalAppBar(context);
  }

  PreferredSizeWidget _buildNormalAppBar(BuildContext context) {
    final Color debugContainerColor = Colors.orange.shade100;
    final Color debugIconColor = Colors.deepOrange.shade700;

    return AppBar(
      title: const Text('All Contacts'),
      actions: [
        // Sort Menu
        PopupMenuButton<ListAction>(
          icon: const Icon(Icons.sort),
          tooltip: "Sort",
          onSelected: onListAction,
          itemBuilder: (BuildContext context) => <PopupMenuEntry<ListAction>>[
            const PopupMenuItem<ListAction>(
              value: ListAction.sortByDueDateAsc,
              child: Text('Sort by Due Date (Soonest)'),
            ),
            const PopupMenuItem<ListAction>(
              value: ListAction.sortByDueDateDesc,
              child: Text('Sort by Due Date (Latest)'),
            ),
            const PopupMenuItem<ListAction>(
              value: ListAction.sortByLastNameAsc,
              child: Text('Sort by Last Name (A-Z)'),
            ),
            const PopupMenuItem<ListAction>(
              value: ListAction.sortByLastNameDesc,
              child: Text('Sort by Last Name (Z-A)'),
            ),
            const PopupMenuItem<ListAction>(
              value: ListAction.sortByLastContactedAsc,
              child: Text('Sort by Last Contacted (Oldest)'),
            ),
            const PopupMenuItem<ListAction>(
              value: ListAction.sortByLastContactedDesc,
              child: Text('Sort by Last Contacted (Newest)'),
            ),
          ],
        ),
        // FILTER Menu - Debug only
        if (kDebugMode)
          PopupMenuButton<ListAction>(
            icon: Icon(Icons.filter_alt, color: debugIconColor),
            tooltip: "Filter (DEBUG)",
            onSelected: onListAction,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<ListAction>>[
              const PopupMenuItem<ListAction>(
                value: ListAction.filterOverdue,
                child: Text('Filter: Overdue'),
              ),
              const PopupMenuItem<ListAction>(
                value: ListAction.filterDueSoon,
                child: Text('Filter: Due Soon'),
              ),
              const PopupMenuItem<ListAction>(
                value: ListAction.filterActive,
                child: Text('Filter: Active Contacts'),
              ),
              const PopupMenuItem<ListAction>(
                value: ListAction.filterArchived,
                child: Text('Filter: Archived Contacts'),
              ),
              const PopupMenuItem<ListAction>(
                value: ListAction.filterClear,
                child: Text('Clear Filter'),
              ),
            ],
          ),
      ],
      // Add Search Bar to AppBar bottom
      bottom: kDebugMode
          ? PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Container(
                color: debugContainerColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search contacts (DEBUG)...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white.withAlpha((255 * 0.85).round()),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      tooltip: "Clear Search",
                      onPressed: () {
                        searchController.clear();
                      },
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  PreferredSizeWidget _buildSelectionAppBar(BuildContext context) {
    final String archiveActionText = isArchivedView ? 'Unarchive' : 'Archive';
    final IconData archiveActionIcon = isArchivedView ? Icons.unarchive : Icons.archive;

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        tooltip: "Cancel Selection",
        onPressed: onCancelSelection,
      ),
      title: Text('$selectedCount selected'),
      actions: [
        IconButton(
          icon: const Icon(Icons.check_circle_outline),
          tooltip: 'Mark as Contacted',
          onPressed: onMarkSelectedContacted,
        ),
        IconButton(
          icon: Icon(archiveActionIcon),
          tooltip: archiveActionText,
          onPressed: () => onArchiveSelected(!isArchivedView), // Pass true to archive, false to unarchive
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Delete Selected',
          onPressed: onDeleteSelected,
        ),
      ],
    );
  }

  @override
  Size get preferredSize {
    // Calculate height based on whether the search bar is shown
    final double baseHeight = kToolbarHeight;
    final double searchBarHeight = kDebugMode ? kToolbarHeight : 0;
    return Size.fromHeight(baseHeight + searchBarHeight);
  }
}
