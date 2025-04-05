// lib/screens/contact_list_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recall/blocs/contact_details/contact_details_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/screens/scheduled_notifications_screen.dart';
import 'package:recall/utils/logger.dart'; // Adjust path if needed
import 'package:recall/widgets/contact_list_item.dart';
import 'package:recall/screens/help_screen.dart'; // Import HelpScreen
import 'package:recall/main.dart' as main_app;

// Enum to represent the combined Sort/Filter action
enum ListAction {
  sortByDueDateAsc,
  sortByDueDateDesc,
  sortByLastNameAsc,
  sortByLastNameDesc,
  sortByLastContactedAsc,
  sortByLastContactedDesc,
  filterOverdue,
  filterDueSoon,
  filterClear
}

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final TextEditingController _searchController =
      TextEditingController(); // Controller for search
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged); // Use separate handler
    _handleInitialNotification();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged); // Remove listener
    _searchController.dispose();
    _debounce?.cancel(); // Cancel timer on dispose
    super.dispose();
  }

  // Debounce search handler
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel(); // Cancel previous timer
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Wait 500ms
      if (mounted) {
        // Check if still mounted before dispatching
        // Dispatch search event after delay
        context.read<ContactListBloc>().add(
            ContactListEvent.applySearch(searchTerm: _searchController.text));
      }
    });
  }

  void _handleInitialNotification() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (main_app.initialNotificationPayload != null && mounted) {
        // Check mounted
        logger.i(
            '>>> Handling initial notification payload: ${main_app.initialNotificationPayload}');
        final String payload = main_app.initialNotificationPayload!;
        int? contactId;

        if (payload.startsWith('contact_id:')) {
          final String idString = payload.split(':').last;
          contactId = int.tryParse(idString);
          logger.i('>>> Parsed initial contactId: $contactId');
        }

        main_app.initialNotificationPayload = null;

        if (contactId != null) {
          logger.i(
              '>>> Navigating to /contactDetails from initial launch payload.');
          // Ensure BLoC is ready before pushing route
          context
              .read<ContactDetailsBloc>()
              .add(ContactDetailsEvent.loadContact(contactId: contactId));
          Navigator.pushNamed(context, '/contactDetails', arguments: contactId);
        } else {
          logger
              .w('>>> Failed to parse contactId from initial payload.');
        }
      } else {
        logger.i(
            '>>> No initial notification payload detected or widget not mounted.');
      }
    });
  }

  // Helper to dispatch BLoC events from PopupMenuButton
  void _handleListAction(ListAction action) {
    switch (action) {
      // Sorting
      case ListAction.sortByDueDateAsc:
        context.read<ContactListBloc>().add(const ContactListEvent.sortContacts(
            sortField: ContactListSortField.dueDate, ascending: true));
        break;
      case ListAction.sortByDueDateDesc:
        context.read<ContactListBloc>().add(const ContactListEvent.sortContacts(
            sortField: ContactListSortField.dueDate, ascending: false));
        break;
      case ListAction.sortByLastNameAsc:
        context.read<ContactListBloc>().add(const ContactListEvent.sortContacts(
            sortField: ContactListSortField.lastName, ascending: true));
        break;
      case ListAction.sortByLastNameDesc:
        context.read<ContactListBloc>().add(const ContactListEvent.sortContacts(
            sortField: ContactListSortField.lastName, ascending: false));
        break;
      case ListAction.sortByLastContactedAsc:
        context.read<ContactListBloc>().add(const ContactListEvent.sortContacts(
            sortField: ContactListSortField.lastContacted, ascending: true));
        break;
      case ListAction.sortByLastContactedDesc:
        context.read<ContactListBloc>().add(const ContactListEvent.sortContacts(
            sortField: ContactListSortField.lastContacted, ascending: false));
        break;
      // Filtering
      case ListAction.filterOverdue:
        context.read<ContactListBloc>().add(const ContactListEvent.applyFilter(
            filter: ContactListFilter.overdue));
        break;
      case ListAction.filterDueSoon:
        context.read<ContactListBloc>().add(const ContactListEvent.applyFilter(
            filter: ContactListFilter.dueSoon));
        break;
      case ListAction.filterClear:
        context.read<ContactListBloc>().add(const ContactListEvent.applyFilter(
            filter: ContactListFilter.none)); // Apply 'none' filter
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          // Sort/Filter Menu
          PopupMenuButton<ListAction>(
            icon: const Icon(Icons.sort), // Or Icons.filter_list
            tooltip: "Sort & Filter",
            onSelected: _handleListAction, // Call helper function
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
              const PopupMenuDivider(), // Separator
              const PopupMenuItem<ListAction>(
                value: ListAction.filterOverdue,
                child: Text('Filter: Overdue'),
              ),
              const PopupMenuItem<ListAction>(
                value: ListAction.filterDueSoon,
                child: Text('Filter: Due Soon'),
              ),
              const PopupMenuItem<ListAction>(
                value: ListAction.filterClear,
                child: Text('Clear Filter'),
              ),
            ],
          ),
          // Other existing actions
          // HELP BUTTON
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Help',
            onPressed: () {
              // Navigate using MaterialPageRoute and pass argument
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelpScreen(
                        initialSection: HelpSection.list), // Pass list section
                  ));
            },
          ),
          // SETTINGS BUTTON
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
        // Add Search Bar to AppBar bottom
        bottom: PreferredSize(
          preferredSize:
              const Size.fromHeight(kToolbarHeight), // Standard toolbar height
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none, // Hide border line
                ),
                filled: true, // Fill background
                fillColor: Colors
                    .white, // Or Theme.of(context).inputDecorationTheme.fillColor
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 0, horizontal: 16), // Adjust padding
                // Add clear button
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  tooltip: "Clear Search",
                  onPressed: () {
                    _searchController
                        .clear(); // Clears text and triggers listener
                  },
                ),
              ),
              onChanged: (value) {
                // Listener already handles dispatching, but onChanged can be used too
                // context.read<ContactListBloc>().add(ContactListEvent.applySearch(searchTerm: value));
              },
            ),
          ),
        ),
      ),
      // Use BlocBuilder to react to state changes
      body: RefreshIndicator(
        onRefresh: () async {
          // Reloading should clear search/filter and fetch fresh data
          _searchController.clear(); // Clear search field visually
          // Dispatch load event which will reset state in BLoC
          context
              .read<ContactListBloc>()
              .add(const ContactListEvent.loadContacts());
        },
        child: BlocBuilder<ContactListBloc, ContactListState>(
            builder: (context, state) {
          // Handle different states
          return state.map(
            initial: (_) => const Center(child: CircularProgressIndicator()),
            loading: (_) => const Center(child: CircularProgressIndicator()),
            empty: (_) => const Center(
                child: Text('No contacts found.')), // Original list empty
            // Use loadedState.displayedContacts for the list
            loaded: (loadedState) => _buildContactList(
                loadedState.displayedContacts), // Pass displayed list
            error: (errorState) =>
                Center(child: Text("Error: ${errorState.message}")),
          );
        }),
      ),
      // BottomAppBar remains largely the same
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Info text (can be removed if cluttering)
              // const Expanded(
              //   child: Text(
              //     'Swipe/Tap list item to mark as contacted',
              //     style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
              //     overflow: TextOverflow.ellipsis,
              //   ),
              // ),
              const Spacer(), // Pushes buttons to the right
              const SizedBox(width: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton.small(
                    heroTag: "btn1",
                    tooltip: "View Scheduled Notifications",
                    onPressed: () => _viewScheduledNotifications(context),
                    child: const Icon(Icons.notifications),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton.small(
                    heroTag: "btn2",
                    tooltip: "Add New Contact",
                    onPressed: () {
                      // Clear details BLoC for new contact
                      context
                          .read<ContactDetailsBloc>()
                          .add(const ContactDetailsEvent.clearContact());
                      // Navigate to add new contact (passing 0 or null)
                      Navigator.pushNamed(context, '/contactDetails',
                          arguments: 0);
                    },
                    child: const Icon(Icons.add),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
} // End of _ContactListScreenState

// --- Widget for building the list ---
// Takes the list to display as parameter (now the filtered/searched list)
Widget _buildContactList(List<Contact> contactsToDisplay) {
  if (contactsToDisplay.isEmpty) {
    return const Center(child: Text('No contacts match your search/filter.'));
  }
  return ListView.builder(
    itemCount: contactsToDisplay.length,
    itemBuilder: (context, index) {
      final contact = contactsToDisplay[index];
      return ContactListItem(
          contact: contact); // Pass contact to the new widget
    },
  );
}

// Function to navigate to scheduled notifications screen (no change needed)
void _viewScheduledNotifications(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const ScheduledNotificationsScreen()));
  logger.i('LOG: Show notifications button pushed');
}
