import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/utils/logger.dart';
import 'package:recall/widgets/contact_list_item.dart';
import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:recall/widgets/add_contact_speed_dial.dart'; // Import the new widget
import 'package:go_router/go_router.dart';
import 'package:recall/config/app_router.dart';

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

typedef ListActionCallback = void Function(ListAction action,
    BuildContext context, TextEditingController searchController);
typedef PopupMenuBuilder<T> = List<PopupMenuEntry<T>> Function(
    BuildContext context);

class BaseContactListScaffold extends StatefulWidget {
  final String screenTitle;
  final Color? screenTitleColor; // New parameter for normal AppBar title color
  final String emptyListText;
  final ContactListEvent onRefreshEvent;
  final Widget? drawerWidget; // Make drawerWidget optional
  final PopupMenuBuilder<ListAction> sortMenuItems;
  final PopupMenuBuilder<ListAction> filterMenuItems;
  final ListActionCallback handleListAction;
  final String fabHeroTagPrefix;
  final ContactListEvent?
      initialScreenLoadEvent; // For specific screen first load
  final bool showSearchBar;
  final bool showFilterMenu;
  final bool showSortMenu;
  final bool displayActiveStatusInList; // New parameter
  final ContactListEvent? debugRefreshEvent; // Add debugRefreshEvent parameter
  final List<Widget>? appBarActions; // New parameter for custom AppBar actions
  final int activeContactCount; // Add activeContactCount parameter
  final int maxActiveContacts; // Add maxActiveContacts parameter

  const BaseContactListScaffold({
    super.key,
    required this.screenTitle,
    this.screenTitleColor, // Initialize new parameter
    required this.emptyListText,
    required this.onRefreshEvent,
    required this.sortMenuItems,
    required this.filterMenuItems,
    required this.handleListAction,
    required this.fabHeroTagPrefix,
    this.drawerWidget,
    this.initialScreenLoadEvent,
    this.showSearchBar = true,
    this.showFilterMenu = true,
    this.showSortMenu = true,
    this.displayActiveStatusInList = false, // Default to false
    this.debugRefreshEvent, // Initialize debugRefreshEvent
    this.appBarActions, // Initialize appBarActions
    required this.activeContactCount, // Initialize activeContactCount
    required this.maxActiveContacts, // Initialize maxActiveContacts
  });

  @override
  State<BaseContactListScaffold> createState() =>
      _BaseContactListScaffoldState();
}

class _BaseContactListScaffoldState extends State<BaseContactListScaffold> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _selectionMode = false;
  final Set<int> _selectedContactIds = {};

  // Store current filter and sort state to pass to details screen
  // Set<ContactListFilterType> _currentFilters = {
  //   ContactListFilterType.active
  // }; // Default
  // ContactListSortField _currentSortField =
  //     ContactListSortField.lastName; // Default
  // bool _currentAscending = true; // Default

  // MARK: Lifecycle
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);

    ContactListEvent eventToLoad;
    if (widget.initialScreenLoadEvent != null) {
      eventToLoad = widget.initialScreenLoadEvent!;
    } else {
      eventToLoad = widget.onRefreshEvent;
    }

    // if (eventToLoad is LoadContactListEvent) {
    //   // Directly assign as analyzer indicates these are non-null for LoadContactListEvent
    //   _currentFilters = eventToLoad.filters;
    //   _currentSortField = eventToLoad.sortField;
    //   _currentAscending = eventToLoad.ascending;
    // }
    // Ensure an event is always added
    context.read<ContactListBloc>().add(eventToLoad);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // MARK: METHODS
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        context
            .read<ContactListBloc>()
            .add(ApplySearchEvent(searchTerm: _searchController.text));
      }
    });
  }

  // MARK: SELECTION
  void _toggleSelectionMode() {
    context.read<ContactListBloc>().add(const ToggleSelectionModeEvent());
  }

  void _toggleContactSelection(int contactId) {
    context.read<ContactListBloc>().add(ToggleContactSelectionEvent(contactId: contactId));
  }

  void _deleteSelectedContacts() async {
    final state = context.read<ContactListBloc>().state;
    if (state is! LoadedContactListState || state.selectedContacts.isEmpty) return;

    final bool confirmDelete = await showDialog(
          context: context,
          builder: (BuildContext dialogContext) => AlertDialog(
            title: const Text('Delete Contacts'),
            content:
                Text('Delete ${state.selectedContacts.length} selected contacts?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text('Delete',
                      style: TextStyle(color: Colors.red))),
            ],
          ),
        ) ??
        false;
    logger.i('Delete confirmation: $confirmDelete');
    if (confirmDelete && mounted) {
      logger.i('Deleting contacts: ${state.selectedContacts}');
      final int deletedContactsCount = state.selectedContacts.length;
      context
          .read<ContactListBloc>()
          .add(DeleteContactsEvent(contactIds: state.selectedContacts.toList()));
      // No need to manage local state for selection mode or selected IDs, BLoC will handle it.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$deletedContactsCount contacts deleted')),
      );
    }
  }

  void _toggleSelectedContactsActiveStatus() {
    final state = context.read<ContactListBloc>().state;
    if (state is! LoadedContactListState || state.selectedContacts.isEmpty) return;

    context.read<ContactListBloc>().add(ToggleContactsActiveStatusEvent(
        contactIds: state.selectedContacts.toList()));
    // No need to manage local state for selection mode or selected IDs, BLoC will handle it.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Toggled active status for selected contacts.')),
    );
  }

  void _onContactLongPress(Contact contact) {
    if (contact.id == null) return;
    // Always dispatch toggle selection, BLoC will handle entering selection mode
    context.read<ContactListBloc>().add(ToggleContactSelectionEvent(contactId: contact.id!));
  }

  // MARK: REFRESH
  Future<void> _refreshContacts() async {
    logger.i('Triggering onRefreshEvent: ${widget.onRefreshEvent}');
    _searchController.clear(); // Also clear search on refresh
    context.read<ContactListBloc>().add(widget.onRefreshEvent);
  }

  Future<void> _debugRefreshContacts() async {
    if (widget.debugRefreshEvent != null) {
      logger.i('Triggering debugRefreshEvent: ${widget.debugRefreshEvent}');
      context.read<ContactListBloc>().add(widget.debugRefreshEvent!);
    }
  }

  // MARK: BUILD
  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactListBloc, ContactListState>(
      listener: (context, state) {
        if (state is LoadedContactListState) {
          // Update current filter/sort state when the list reloads
          // _currentFilters = state.activeFilters;
          // _currentSortField = state.sortField;
          // _currentAscending = state.ascending;
          // Update local _selectionMode and _selectedContactIds based on BLoC state
          // This is to keep the AppBar and other UI elements in sync
          // However, actions should dispatch events to the BLoC
          if (_selectionMode != state.isSelectionMode) {
            setState(() {
              _selectionMode = state.isSelectionMode;
            });
          }
          if (!setEquals(_selectedContactIds, state.selectedContacts)) {
             setState(() {
              _selectedContactIds.clear();
              _selectedContactIds.addAll(state.selectedContacts);
            });
          }
          logger.i(
              'BaseContactListScaffold: Listener updated _selectionMode: $_selectionMode, _selectedContactIds: $_selectedContactIds from LoadedContactListState');
        } else if (state is EmptyContactListState || state is InitialContactListState || state is LoadingContactListState) {
          // If the state is not Loaded, ensure selection mode is off.
          if (_selectionMode) {
            setState(() {
              _selectionMode = false;
              _selectedContactIds.clear();
            });
          }
        }
      },
      child: Scaffold(
        drawer: widget.drawerWidget,
        appBar: _selectionMode
            ? _buildSelectionAppBar(context)
            : _buildNormalAppBar(context),
        body: RefreshIndicator(
          onRefresh: _refreshContacts,
          child: BlocBuilder<ContactListBloc, ContactListState>(
            builder: (context, state) {
              if (state is InitialContactListState ||
                  state is LoadingContactListState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is EmptyContactListState) {
                return Center(child: Text(widget.emptyListText));
              } else if (state is LoadedContactListState) {
                if (state.displayedContacts.isEmpty &&
                    _searchController.text.isNotEmpty) {
                  return const Center(
                      child: Text('No contacts match your search.'));
                } else if (state.displayedContacts.isEmpty &&
                    state.activeFilters.isNotEmpty) {
                  return const Center(
                      child: Text('No contacts match your current filters.'));
                } else if (state.displayedContacts.isEmpty) {
                  return Center(child: Text(widget.emptyListText));
                }
                return _buildContactList(state.displayedContacts);
              } else if (state is ErrorContactListState) {
                return Center(child: Text("Error: ${state.message}"));
              }
              return Center(child: Text(widget.emptyListText));
            },
          ),
        ),
        floatingActionButton: AddContactSpeedDial(
          onRefreshListEvent: widget.onRefreshEvent,
          activeContactCount: widget.activeContactCount,
          maxActiveContacts: widget.maxActiveContacts,
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (kDebugMode && widget.debugRefreshEvent != null)
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Debug Refresh',
                        onPressed: _debugRefreshContacts,
                      ),
                    if (kDebugMode)
                      FloatingActionButton.small(
                        heroTag:
                            "${widget.fabHeroTagPrefix}_debug_notifications",
                        tooltip: "View Scheduled Notifications",
                        onPressed: () => (
                          // Replace with GoRouter navigation:
                          context
                              .pushNamed(AppRouter.debugNotificationsRouteName),
                        ),
                        child: const Icon(Icons.notifications),
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // MARK: STD AppBar
  PreferredSizeWidget _buildNormalAppBar(BuildContext context) {
    return AppBar(
      leading:
          widget.drawerWidget == null // Show back button if no drawerWidget
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    // The above logic is specific to HomeScreen's desired behavior when it *has* a back button.
                    // For a generic back button, we just pop. The calling screen (if it's a BaseContactListScaffold based one)
                    // will handle its own refresh via RouteAware.
                    context.pop(); // Use context.pop() from go_router
                  },
                )
              : null,
      title: Text(widget.screenTitle, style: widget.screenTitleColor != null ? TextStyle(color: widget.screenTitleColor) : null), // Use screenTitleColor
      actions: [
        if (widget.showSortMenu)
          PopupMenuButton<ListAction>(
            icon: const Icon(Icons.sort),
            tooltip: "Sort",
            onSelected: (action) =>
                widget.handleListAction(action, context, _searchController),
            itemBuilder: widget.sortMenuItems,
          ),
        if (widget.showFilterMenu)
          PopupMenuButton<ListAction>(
            icon: const Icon(Icons.filter_alt),
            tooltip: "Filter",
            onSelected: (action) =>
                widget.handleListAction(action, context, _searchController),
            itemBuilder: widget.filterMenuItems,
          ),
        if (widget.appBarActions != null)
          ...widget.appBarActions!, // Add custom actions
      ],
      bottom: widget.showSearchBar
          ? PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      tooltip: "Clear Search",
                      onPressed: () => _searchController.clear(),
                    ),
                  ),
                ),
              )
            )
          : null,
    );
  }

  // MARK: SEL AppBar
  PreferredSizeWidget _buildSelectionAppBar(BuildContext context) {
    final blocState = context.read<ContactListBloc>().state;
    String titleTextToShow;
    Color titleColor = Colors.white; // Default color
    // const int maxActiveContacts = 18; // Use widget.maxActiveContacts instead

    if (blocState is LoadedContactListState) {
      // Calculate potential active count based on ALL contacts, not just displayed ones
      // This requires knowing the total active count from originalContacts
      int currentTotalActive = blocState.originalContacts.where((c) => c.isActive).length;
      int potentialActiveCount = currentTotalActive;

      // Adjust potentialActiveCount based on selected contacts from the original list perspective
      // This ensures accuracy even if selected items are not currently displayed due to search/filter
      final originalContactsMap = {
        for (var c in blocState.originalContacts)
          if (c.id != null) c.id!: c
      };

      for (final contactId in blocState.selectedContacts) {
          final contact = originalContactsMap[contactId];
          if (contact != null) {
            if (contact.isActive) { // If it's currently active and selected
              potentialActiveCount--; // It will be toggled to inactive
            } else { // If it's currently inactive and selected
              potentialActiveCount++; // It will be toggled to active
            }
          }
      }
      
      titleTextToShow = '$potentialActiveCount / ${widget.maxActiveContacts} active';
      if (potentialActiveCount > widget.maxActiveContacts) {
        titleColor = Colors.red;
      }
    } else {
      // Default for other states (Loading, Empty, Initial)
      // Assuming 0 active contacts if not loaded.
      titleTextToShow = '0 / ${widget.maxActiveContacts} active';
      // No color change needed here as 0 <= 18
    }

    Color toggleIconColor = Colors.white; // Default color for toggle icon
    if (blocState is LoadedContactListState && blocState.isSelectionMode) {
        int currentTotalActive = blocState.originalContacts.where((c) => c.isActive).length;
        int potentialActiveCountAfterToggle = currentTotalActive;
        final originalContactsMap = { for (var c in blocState.originalContacts) if (c.id != null) c.id!: c };

        for (final contactId in blocState.selectedContacts) {
            final contact = originalContactsMap[contactId];
            if (contact != null) {
                if (contact.isActive) { // If it's currently active and selected, it would be toggled to inactive
                    potentialActiveCountAfterToggle--;
                } else { // If it's currently inactive and selected, it would be toggled to active
                    potentialActiveCountAfterToggle++;
                }
            }
        }
        if (potentialActiveCountAfterToggle > widget.maxActiveContacts) {
            toggleIconColor = Colors.red;
        }
    }

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: _toggleSelectionMode, // Use the existing method to exit selection mode
      ),
      title: Text(titleTextToShow, style: TextStyle(color: titleColor)), // Apply dynamic color
      backgroundColor: Colors.blueGrey[700], // Example color, adjust as needed
      actions: <Widget>[
        if (_selectedContactIds.isNotEmpty) ...[
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: () {
              context.read<ContactListBloc>().add(MarkContactsAsContactedEvent(
                  contactIds: _selectedContactIds.toList()));
              // BLoC will manage exiting selection mode if needed after this action.
            },
          ),
        ],
        IconButton(
          icon: Icon(Icons.sync_alt, color: toggleIconColor), // Use dynamic color
          tooltip: 'Toggle Active Status',
          onPressed: () {
            if (toggleIconColor == Colors.red) { // Check if the icon is red (limit exceeded)
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text('Active Contact Limit Reached'),
                    content: const Text('Toggling these contacts would exceed the 18 active contact limit.'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            } else {
              _toggleSelectedContactsActiveStatus(); // Original action
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.white), // This is the second delete button
          tooltip: 'Delete Selected',
          onPressed:
              _selectedContactIds.isEmpty ? null : _deleteSelectedContacts, // Dispatches DeleteContactsEvent
        ),
        IconButton(
          icon: const Icon(Icons.select_all, color: Colors.white),
          tooltip: 'Select All',
          onPressed: () {
            context.read<ContactListBloc>().add(const SelectAllContactsEvent());
          },
        ),
      ],
    );
  }

  // MARK: CONTACT LIST
  Widget _buildContactList(List<Contact> contactsToDisplay) {
    return RefreshIndicator(
      onRefresh: _refreshContacts,
      child: ListView.builder(
        itemCount: contactsToDisplay.length,
        itemBuilder: (context, index) {
          final contact = contactsToDisplay[index];
          return ContactListItem(
            contact: contact,
            isSelected: _selectedContactIds.contains(contact.id),
            showActiveStatus: widget.displayActiveStatusInList,
            onTap: () {
              if (_selectionMode) {
                _toggleContactSelection(contact.id!);
              } else {
                // Navigate to contact details
                context.pushNamed(
                  AppRouter.contactDetailsRouteName,
                  pathParameters: {'id': contact.id.toString()},
                );
              }
            },
            onLongPress: () => _onContactLongPress(contact),
          );
        },
      ),
    );
  }
}
