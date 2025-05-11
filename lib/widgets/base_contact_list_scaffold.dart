import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recall/blocs/contact_details/contact_details_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/screens/scheduled_notifications_screen.dart';
import 'package:recall/utils/logger.dart';
import 'package:recall/widgets/contact_list_item.dart';
import 'package:recall/main.dart' as main_app;
import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:recall/widgets/add_contact_speed_dial.dart'; // Import the new widget

// Re-define or import ListAction if not globally accessible
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

  // MARK: Lifecycle
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _handleInitialNotification();
    if (widget.initialScreenLoadEvent != null) {
      context.read<ContactListBloc>().add(widget.initialScreenLoadEvent!);
    }
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

  void _handleInitialNotification() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (main_app.initialNotificationPayload != null && mounted) {
        final String payload = main_app.initialNotificationPayload!;
        int? contactId;
        if (payload.startsWith('contact_id:')) {
          contactId = int.tryParse(payload.split(':').last);
        }
        main_app.initialNotificationPayload = null;
        if (contactId != null) {
          context
              .read<ContactDetailsBloc>()
              .add(LoadContactEvent(contactId: contactId));
          Navigator.pushNamed(context, '/contactDetails', arguments: contactId);
        }
      }
    });
  }

  void _toggleSelectionMode() {
    setState(() {
      _selectionMode = !_selectionMode;
      if (!_selectionMode) _selectedContactIds.clear();
    });
  }

  void _toggleContactSelection(int contactId) {
    setState(() {
      if (_selectedContactIds.contains(contactId)) {
        _selectedContactIds.remove(contactId);
        if (_selectedContactIds.isEmpty) _selectionMode = false;
      } else {
        _selectedContactIds.add(contactId);
      }
    });
  }

  void _deleteSelectedContacts() async {
    final bool confirmDelete = await showDialog(
          context: context,
          builder: (BuildContext dialogContext) => AlertDialog(
            title: const Text('Delete Contacts'),
            content:
                Text('Delete ${_selectedContactIds.length} selected contacts?'),
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

    if (confirmDelete && mounted) {
      context
          .read<ContactListBloc>()
          .add(DeleteContactsEvent(contactIds: _selectedContactIds.toList()));
      setState(() {
        _selectionMode = false;
        _selectedContactIds.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('${_selectedContactIds.length} contacts deleted')),
      );
    }
  }

  void _toggleSelectedContactsActiveStatus() {
    if (_selectedContactIds.isEmpty) return;
    context.read<ContactListBloc>().add(ToggleContactsActiveStatusEvent(
        contactIds: _selectedContactIds.toList()));
    // Exit selection mode after action
    setState(() {
      _selectionMode = false;
      _selectedContactIds.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Toggled active status for selected contacts.')),
    );
  }

  void _onContactLongPress(Contact contact) {
    if (contact.id == null) return;
    if (!_selectionMode) {
      setState(() {
        _selectionMode = true;
        _selectedContactIds.add(contact.id!);
      });
    } else {
      _toggleContactSelection(contact.id!);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
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
                      heroTag: "${widget.fabHeroTagPrefix}_debug_notifications",
                      tooltip: "View Scheduled Notifications",
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const ScheduledNotificationsScreen())),
                      child: const Icon(Icons.notifications),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildNormalAppBar(BuildContext context) {
    return AppBar(
      leading: widget.drawerWidget == null // Show back button if no drawerWidget
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // Dispatch the homescreen filter event before popping
                context.read<ContactListBloc>().add(const LoadContactListEvent(
                      filters: {ContactListFilterType.homescreen},
                      sortField: ContactListSortField.nextContactDate,
                      ascending: true, // Most overdue first
                    ));
                Navigator.of(context).pop();
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

  PreferredSizeWidget _buildSelectionAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueGrey.shade800,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Text('${_selectedContactIds.length} selected'),
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.white),
        onPressed: _toggleSelectionMode,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.sync_alt,
              color: Colors.white), // Icon for toggling
          tooltip: 'Toggle Active Status',
          onPressed: _selectedContactIds.isEmpty
              ? null
              : _toggleSelectedContactsActiveStatus,
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.white),
          tooltip: 'Delete Selected',
          onPressed:
              _selectedContactIds.isEmpty ? null : _deleteSelectedContacts,
        ),
        IconButton(
          icon: const Icon(Icons.select_all, color: Colors.white),
          tooltip: 'Select All',
          onPressed: () {
            final state = context.read<ContactListBloc>().state;
            if (state is LoadedContactListState) {
              setState(() {
                _selectedContactIds.addAll(state.displayedContacts
                    .where((c) => c.id != null)
                    .map((contact) => contact.id!));
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildContactList(List<Contact> contactsToDisplay) {
    return ListView.builder(
      itemCount: contactsToDisplay.length,
      itemBuilder: (context, index) {
        final contact = contactsToDisplay[index];
        final bool isSelected =
            contact.id != null && _selectedContactIds.contains(contact.id!);
        return ContactListItem(
          contact: contact,
          isSelected: isSelected,
          showActiveStatus:
              widget.displayActiveStatusInList, // Pass the new param
          onTap: () {
            if (contact.id == null) return;
            if (_selectionMode) {
              _toggleContactSelection(contact.id!);
            } else {
              context
                  .read<ContactDetailsBloc>()
                  .add(LoadContactEvent(contactId: contact.id!));
              Navigator.pushNamed(context, '/contactDetails',
                  arguments: contact.id!);
            }
          },
          onLongPress: () => _onContactLongPress(contact),
        );
      },
    );
  }
}
