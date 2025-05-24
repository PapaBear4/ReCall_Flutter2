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

  const BaseContactListScaffold({
    super.key,
    required this.screenTitle,
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
      title: Text(widget.screenTitle),
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
              ),
            )
          : null,
    );
  }

  // MARK: SEL AppBar
  PreferredSizeWidget _buildSelectionAppBar(BuildContext context) {
    final blocState = context.read<ContactListBloc>().state;

    String titleTextToShow;

    if (blocState is LoadedContactListState) {
      // Calculate the number of currently active contacts in the displayed list
      int currentActiveInDisplayed = blocState.displayedContacts.where((c) => c.isActive).length;
      
      int adjustments = 0;

      // Create a map of displayed contacts for efficient lookup by ID
      // Assuming contacts in displayedContacts have non-null IDs as they are selectable
      final displayedContactsMap = {
        for (var c in blocState.displayedContacts)
          if (c.id != null) c.id!: c
      };

      for (var contactId in blocState.selectedContacts) {
        final contact = displayedContactsMap[contactId];
        if (contact != null) {
          if (contact.isActive) {
            adjustments--; // Selected active contact, potential decrease in active count
          } else {
            adjustments++; // Selected inactive contact, potential increase in active count
          }
        } else {
          // This case should ideally not happen if selectedContacts are derived from displayedContacts
          logger.w('Selected contact ID $contactId not found in displayedContactsMap during AppBar title calculation.');
        }
      }
      
      final potentialTotalActive = currentActiveInDisplayed + adjustments;
      const totalContacts = 18; // Use the fixed number 18
      titleTextToShow = '$potentialTotalActive / $totalContacts';
    } else {
      // This block should ideally not be reached if _selectionMode is true,
      // as _selectionMode is set based on LoadedContactListState.
      // Fallback to showing the count of selected items using the local _selectedContactIds.
      titleTextToShow = '${_selectedContactIds.length} selected';
      logger.w('_buildSelectionAppBar called when BLoC state is not LoadedContactListState. This is unexpected.');
    }

    return AppBar(
      backgroundColor: Colors.blueGrey.shade800,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Text(
        titleTextToShow, // Use the new calculated title
        style: const TextStyle(color: Colors.white), 
      ),
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.white),
        onPressed: _toggleSelectionMode, // Dispatches ToggleSelectionModeEvent
      ),
      actions: [
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
          icon: const Icon(Icons.sync_alt,
              color: Colors.white), // Icon for toggling
          tooltip: 'Toggle Active Status',
          onPressed: _selectedContactIds.isEmpty
              ? null
              : _toggleSelectedContactsActiveStatus, // Dispatches ToggleContactsActiveStatusEvent
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
