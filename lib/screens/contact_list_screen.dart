// lib/screens/contact_list_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recall/blocs/contact_details/contact_details_bloc.dart';
import 'package:recall/blocs/contact_details/contact_details_event.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_event.dart';
import 'package:recall/blocs/contact_list/contact_list_state.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/models/contact_enums.dart';
import 'package:recall/screens/scheduled_notifications_screen.dart';
import 'package:recall/utils/logger.dart'; // Adjust path if needed
import 'package:recall/widgets/contact_list_item.dart';
import 'package:recall/main.dart' as main_app;
import 'package:flutter/foundation.dart'; // For kDebugMode

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

class _ContactListScreenState extends State<ContactListScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController =
      TextEditingController(); // Controller for search
  Timer? _debounce;

  // Speed dial animation controller
  late AnimationController _animationController;
  late Animation<double> _buttonAnimationScale;
  late Animation<double> _childButtonAnimation1;
  late Animation<double> _childButtonAnimation2;

  bool _isSpeedDialOpen = false;

  // Selection mode state
  bool _selectionMode = false;
  final Set<int> _selectedContactIds =
      {}; // Using a Set to store selected contact IDs

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged); // Use separate handler
    _handleInitialNotification();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Button animations
    _buttonAnimationScale = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Child buttons animations with different intervals
    _childButtonAnimation1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _childButtonAnimation2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged); // Remove listener
    _searchController.dispose();
    _debounce?.cancel(); // Cancel timer on dispose
    _animationController.dispose(); // Dispose animation controller
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
        context
            .read<ContactListBloc>()
            .add(ApplySearch(searchTerm: _searchController.text));
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
              .add(LoadContact(contactId: contactId));
          Navigator.pushNamed(context, '/contactDetails', arguments: contactId);
        } else {
          logger.w('>>> Failed to parse contactId from initial payload.');
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
        context.read<ContactListBloc>().add(SortContacts(
            sortField: ContactListSortField.dueDate, ascending: true));
        break;
      case ListAction.sortByDueDateDesc:
        context.read<ContactListBloc>().add(SortContacts(
            sortField: ContactListSortField.dueDate, ascending: false));
        break;
      case ListAction.sortByLastNameAsc:
        context.read<ContactListBloc>().add(SortContacts(
            sortField: ContactListSortField.lastName, ascending: true));
        break;
      case ListAction.sortByLastNameDesc:
        context.read<ContactListBloc>().add(SortContacts(
            sortField: ContactListSortField.lastName, ascending: false));
        break;
      case ListAction.sortByLastContactedAsc:
        context.read<ContactListBloc>().add(SortContacts(
            sortField: ContactListSortField.lastContacted, ascending: true));
        break;
      case ListAction.sortByLastContactedDesc:
        context.read<ContactListBloc>().add(SortContacts(
            sortField: ContactListSortField.lastContacted, ascending: false));
        break;
      // Filtering
      case ListAction.filterOverdue:
        context
            .read<ContactListBloc>()
            .add(ApplyFilter(filter: ContactListFilter.overdue));
        break;
      case ListAction.filterDueSoon:
        context
            .read<ContactListBloc>()
            .add(ApplyFilter(filter: ContactListFilter.dueSoon));
        break;
      case ListAction.filterClear:
        context.read<ContactListBloc>().add(
            ApplyFilter(filter: ContactListFilter.none)); // Apply 'none' filter
        break;
    }
  }

  // Toggle selection mode
  void _toggleSelectionMode() {
    setState(() {
      _selectionMode = !_selectionMode;
      // Clear selections when exiting selection mode
      if (!_selectionMode) {
        _selectedContactIds.clear();
      }
    });
  }

  // Toggle selection for a specific contact
  void _toggleContactSelection(int contactId) {
    setState(() {
      if (_selectedContactIds.contains(contactId)) {
        _selectedContactIds.remove(contactId);
        // Exit selection mode if no contacts are selected
        if (_selectedContactIds.isEmpty) {
          _selectionMode = false;
        }
      } else {
        _selectedContactIds.add(contactId);
      }
    });
  }

  // Delete selected contacts
  void _deleteSelectedContacts() async {
    // Show confirmation dialog
    final bool confirmDelete = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Contacts'),
              content: Text(
                  'Delete ${_selectedContactIds.length} selected contacts?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child:
                      const Text('Delete', style: TextStyle(color: Colors.red)),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        ) ??
        false; // Default to false if dialog is dismissed

    if (confirmDelete && mounted) {
      // Process deletion through the bloc
      context
          .read<ContactListBloc>()
          .add(DeleteContacts(contactIds: _selectedContactIds.toList()));

      // Exit selection mode
      setState(() {
        _selectionMode = false;
        _selectedContactIds.clear();
      });

      // Show a snackbar indicating successful deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_selectedContactIds.length} contacts deleted'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // --- Handler for Marking Selected as Contacted ---
  void _markSelectedAsContacted(BuildContext context) async {
    // Optional: Confirmation Dialog
    final bool confirmMark = await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Mark as Contacted'),
              content: Text(
                  'Mark ${_selectedContactIds.length} selected contacts as contacted today?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                ),
                TextButton(
                  child: const Text('Mark Contacted'),
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                ),
              ],
            );
          },
        ) ??
        false; // Default to false if dialog dismissed

    if (!confirmMark || !mounted) {
      return; // Exit if not confirmed or widget unmounted
    }

    // Use the new UpdateContacts event instead of MarkContactsAsContacted
    context.read<ContactListBloc>().add(UpdateContacts.markAsContacted(
        contactIds: _selectedContactIds.toList()));

    // Exit selection mode after dispatching
    setState(() {
      _selectionMode = false;
      _selectedContactIds.clear();
    });

    // Optional: Show confirmation SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('${_selectedContactIds.length} contacts marked as contacted.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  // --- END ---

// Handle long press on a contact
  void _onContactLongPress(Contact contact) {
    // Start selection mode if not already in it
    if (!_selectionMode) {
      setState(() {
        _selectionMode = true;
        if (contact.id != null) {
          _selectedContactIds.add(contact.id!);
        }
      });
    } else {
      // If already in selection mode, toggle this contact's selection
      _toggleContactSelection(contact.id!);
    }
  }

  // Toggle speed dial
  void _toggleSpeedDial() {
    setState(() {
      _isSpeedDialOpen = !_isSpeedDialOpen;
      if (_isSpeedDialOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  // Import contacts action
  void _importContacts() {
    // Close the speed dial
    _toggleSpeedDial();

    Navigator.pushNamed(context, '/importContacts');
  }

  // Add new contact action
  void _addNewContact() {
    // Close the speed dial
    _toggleSpeedDial();

    // Clear details BLoC for new contact
    context.read<ContactDetailsBloc>().add(const ClearContact());

    // Navigate to add new contact (passing 0 or null)
    Navigator.pushNamed(context, '/contactDetails', arguments: 0);
  }

  // Add helper methods for the debug functions
  void _addSampleContacts() {
    // Show confirmation dialog first
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Sample Contacts'),
          content: const Text(
              'This will add several sample contacts to your database for testing purposes. Continue?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add Samples'),
              onPressed: () {
                // Close dialog
                Navigator.of(context).pop();

                // Add sample contacts via BLoC
                context.read<ContactListBloc>().add(const AddSampleContacts());

                // Show confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sample contacts added')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _clearAppData() {
    // Show confirmation dialog with warning
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear All App Data'),
          content: const Text(
              'WARNING: This will delete ALL contacts and settings. This action cannot be undone. Continue?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Clear Everything',
                  style: TextStyle(color: Colors.red)),
              onPressed: () {
                // Close dialog
                Navigator.of(context).pop();

                // Clear all data via BLoC
                context.read<ContactListBloc>().add(const ClearAllData());

                // Show confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All app data cleared')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Moved drawer build into the state class
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'ReCall',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Keep in touch with people who matter',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.contact_phone),
            title: const Text('Contacts'),
            onTap: () {
              Navigator.pop(context);
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

          // Add debug section only in debug mode
          if (kDebugMode) const Divider(),

          if (kDebugMode)
            ListTile(
              leading: const Icon(Icons.bug_report, color: Colors.orange),
              title: const Text('Developer Debug',
                  style: TextStyle(color: Colors.orange)),
              onTap: () {
                Navigator.pop(context);
                _showDebugMenu();
              },
            ),
        ],
      ),
    );
  }

  // Debug menu implementation
  void _showDebugMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: double.infinity,
                color: Colors.orange.shade100,
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                child: const Text(
                  'Developer Debug Options',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.deepOrange,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('View Scheduled Notifications'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ScheduledNotificationsScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Add Sample Contacts'),
                onTap: () {
                  Navigator.pop(context);
                  _addSampleContacts();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text('Clear ALL App Data',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _clearAppData();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: _selectionMode
          ? _buildSelectionAppBar(context)
          : _buildNormalAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async {
          // Reloading should clear search/filter and fetch fresh data
          _searchController.clear(); // Clear search field visually
          // Dispatch load event which will reset state in BLoC
          context.read<ContactListBloc>().add(const LoadContacts());
        },
        child: BlocBuilder<ContactListBloc, ContactListState>(
            builder: (context, state) {
          if (state is Initial) {
            return const Center(child: Text('Initializing contact list...'));
          } else if (state is Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is Loaded) {
            return _buildContactList(state.displayedContacts);
          } else if (state is Empty) {
            return const Center(
                child: Text(
                    'No contacts found. Add one using the + button below!'));
          } else if (state is Error) {
            return Center(
                child: Text('Error loading contacts: ${state.message}'));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        }),
      ),
      floatingActionButton: _buildSpeedDial(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Build the speed dial FAB system
  Widget _buildSpeedDial() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Import contacts button (first child)
        ScaleTransition(
          scale: _childButtonAnimation1,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: FloatingActionButton(
              heroTag: "importBtn",
              backgroundColor: Colors.amber[700],
              mini: true,
              onPressed: _importContacts,
              tooltip: 'Import Contacts',
              child: const Icon(Icons.file_download),
            ),
          ),
        ),

        // Add contact button (second child)
        ScaleTransition(
          scale: _childButtonAnimation2,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: FloatingActionButton(
              heroTag: "addBtn",
              backgroundColor: Colors.green,
              mini: true,
              onPressed: _addNewContact,
              tooltip: 'Add New Contact',
              child: const Icon(Icons.person_add),
            ),
          ),
        ),

        // Main button
        ScaleTransition(
          scale: _buttonAnimationScale,
          child: FloatingActionButton(
            heroTag: "mainBtn",
            backgroundColor:
                Theme.of(context).primaryColor.withAlpha((255 * 0.6).round()),
            onPressed: _toggleSpeedDial,
            tooltip: 'Add Contact Options',
            child: AnimatedRotation(
              duration: const Duration(milliseconds: 300),
              turns: _isSpeedDialOpen ? 0.125 : 0, // 45 degrees when open
              child: const Icon(Icons.add, size: 30),
            ),
          ),
        ),
      ],
    );
  }

  // Build normal app bar
  PreferredSizeWidget _buildNormalAppBar(BuildContext context) {
    final Color debugContainerColor =
        Colors.orange.shade100; // Example: Light Orange
    final Color debugIconColor =
        Colors.deepOrange.shade700; // Example: Darker Orange

    return AppBar(
      title: const Text('Contacts'),
      actions: [
        // Sort Menu
        PopupMenuButton<ListAction>(
          icon: const Icon(Icons.sort),
          tooltip: "Sort",
          onSelected: _handleListAction,
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
            onSelected: _handleListAction,
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
                // --- Change Container Background Color ---
                color: debugContainerColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search contacts (DEBUG)...',
                    prefixIcon: const Icon(
                        Icons.search), // Keep default color or change too
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    // Adjust fill color for contrast with new background
                    fillColor: Colors.white.withAlpha(
                        (255 * 0.85).round()), // Calculate alpha from opacity
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    suffixIcon: IconButton(
                      icon: const Icon(
                          Icons.clear), // Keep default color or change too
                      tooltip: "Clear Search",
                      onPressed: () {
                        _searchController.clear();
                      },
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  // Build selection mode app bar
  PreferredSizeWidget _buildSelectionAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors
          .blueGrey.shade800, // Different color to indicate selection mode
      elevation: 0, // Remove the shadow effect
      scrolledUnderElevation: 0, // Explicitly remove elevation when scrolled
      title: Text('${_selectedContactIds.length} selected'),
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.white),
        onPressed: _toggleSelectionMode, // Exit selection mode
      ),
      actions: [
        // --- Mark as Contacted Button ---
        IconButton(
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
          tooltip: 'Mark as Contacted',
          // Disable if no contacts are selected
          onPressed: _selectedContactIds.isEmpty
              ? null
              : () => _markSelectedAsContacted(context), // Call new handler
        ),
        // --- END Mark as Contacted Button ---
        // Delete button
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.white),
          tooltip: 'Delete Selected',
          onPressed:
              _selectedContactIds.isEmpty ? null : _deleteSelectedContacts,
        ),
        // Select all button
        IconButton(
          icon: const Icon(Icons.select_all, color: Colors.white),
          tooltip: 'Select All',
          onPressed: () {
            final currentState = context.read<ContactListBloc>().state;
            if (currentState is Loaded) {
              final contacts = currentState.displayedContacts;
              setState(() {
                _selectedContactIds
                    .addAll(contacts.map((contact) => contact.id!));
              });
            }
          },
        ),
      ],
    );
  }

  // --- Widget for building the list ---
  Widget _buildContactList(List<Contact> contactsToDisplay) {
    if (contactsToDisplay.isEmpty) {
      return const Center(child: Text('No contacts match your search/filter.'));
    }

    return ListView.builder(
      itemCount: contactsToDisplay.length,
      itemBuilder: (context, index) {
        final contact = contactsToDisplay[index];
        final bool isSelected =
            contact.id != null && _selectedContactIds.contains(contact.id!);

        return ContactListItem(
            contact: contact,
            isSelected: isSelected,
            onTap: () {
              if (contact.id == null) {
                logger.e("Error: Tapped contact with null ID.");
                return;
              }
              if (_selectionMode) {
                _toggleContactSelection(contact.id!);
              } else {
                context
                    .read<ContactDetailsBloc>()
                    .add(LoadContact(contactId: contact.id!));
                Navigator.pushNamed(
                  context,
                  '/contactDetails',
                  arguments: contact.id!,
                );
              }
            },
            onLongPress: () {
              if (contact.id != null) {
                _onContactLongPress(contact);
              } else {
                logger.e("Error: Long-pressed contact with null ID.");
              }
            });
      },
    );
  }
}
