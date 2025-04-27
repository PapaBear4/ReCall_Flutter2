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
import 'package:recall/utils/logger.dart'; // Adjust path if needed
import 'package:recall/screens/widgets/contact_list_item.dart';
import 'package:recall/main.dart' as main_app;

// Import the new widget files
import 'package:recall/screens/widgets/contact_list_app_bar.dart';
import 'package:recall/screens/widgets/contact_list_drawer.dart';
import 'package:recall/screens/widgets/contact_list_speed_dial.dart';
import 'package:recall/screens/widgets/contact_list_filter_chips.dart';

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
  filterActive,
  filterArchived,
  filterClear
}

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  // Selection mode state
  bool _selectionMode = false;
  final Set<int> _selectedContactIds = {};

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _handleInitialNotification();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // Debounce search handler
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        context
            .read<ContactListBloc>()
            .add(ApplySearch(searchTerm: _searchController.text));
      }
    });
  }

  void _handleInitialNotification() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (main_app.initialNotificationPayload != null && mounted) {
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

  void _handleListAction(ListAction action) {
    switch (action) {
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
      case ListAction.filterOverdue:
        context.read<ContactListBloc>().add(
          ToggleFilter(filter: ContactListFilter.overdue, enabled: true),
        );
        break;
      case ListAction.filterDueSoon:
        context.read<ContactListBloc>().add(
          ToggleFilter(filter: ContactListFilter.dueSoon, enabled: true),
        );
        break;
      case ListAction.filterActive:
        context.read<ContactListBloc>().add(
          ToggleFilter(filter: ContactListFilter.active, enabled: true),
        );
        break;
      case ListAction.filterArchived:
        context.read<ContactListBloc>().add(
          ToggleFilter(filter: ContactListFilter.archived, enabled: true),
        );
        break;
      case ListAction.filterClear:
        context.read<ContactListBloc>().add(
          const ClearFilters(filtersToKeep: {}),
        );
        break;
    }
  }

  void _toggleSelectionMode() {
    setState(() {
      _selectionMode = !_selectionMode;
      if (!_selectionMode) {
        _selectedContactIds.clear();
      }
    });
  }

  void _toggleContactSelection(int contactId) {
    setState(() {
      if (_selectedContactIds.contains(contactId)) {
        _selectedContactIds.remove(contactId);
        if (_selectedContactIds.isEmpty) {
          _selectionMode = false;
        }
      } else {
        _selectedContactIds.add(contactId);
      }
    });
  }

  void _deleteSelectedContacts() async {
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
        false;

    if (confirmDelete && mounted) {
      final count = _selectedContactIds.length;
      context
          .read<ContactListBloc>()
          .add(DeleteContacts(contactIds: _selectedContactIds.toList()));

      setState(() {
        _selectionMode = false;
        _selectedContactIds.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$count contacts deleted'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _markSelectedAsContacted() async {
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
        false;

    if (!confirmMark || !mounted) {
      return;
    }

    final count = _selectedContactIds.length;
    context.read<ContactListBloc>().add(UpdateContacts.markAsContacted(
        contactIds: _selectedContactIds.toList()));

    setState(() {
      _selectionMode = false;
      _selectedContactIds.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$count contacts marked as contacted.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _archiveSelectedContacts(bool archive) async {
    final String actionText = archive ? 'Archive' : 'Unarchive';

    final bool confirmAction = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('$actionText Contacts'),
              content: Text(
                  '$actionText ${_selectedContactIds.length} selected contacts?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: Text(actionText),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        ) ??
        false;

    if (confirmAction && mounted) {
      final count = _selectedContactIds.length;
      context.read<ContactListBloc>().add(UpdateContacts.setArchiveStatus(
        contactIds: _selectedContactIds.toList(),
        archived: archive,
      ));

      setState(() {
        _selectionMode = false;
        _selectedContactIds.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '$count contacts ${archive ? 'archived' : 'unarchived'}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
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

  void _importContacts() {
    Navigator.pushNamed(context, '/importContacts');
  }

  void _addNewContact() {
    context.read<ContactDetailsBloc>().add(const ClearContact());
    Navigator.pushNamed(context, '/contactDetails', arguments: 0);
  }

  void _addSampleContacts() {
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
                Navigator.of(context).pop();
                context.read<ContactListBloc>().add(const AddSampleContacts());
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
                Navigator.of(context).pop();
                context.read<ContactListBloc>().add(const ClearAllData());
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

  @override
  Widget build(BuildContext context) {
    bool isArchivedView = false;
    final currentState = context.watch<ContactListBloc>().state;
    if (currentState is Loaded) {
      isArchivedView =
          currentState.appliedFilters.contains(ContactListFilter.archived);
    }

    return Scaffold(
      drawer: ContactListDrawer(
        onAddSampleContacts: _addSampleContacts,
        onClearAppData: _clearAppData,
      ),
      appBar: ContactListAppBar(
        selectionMode: _selectionMode,
        selectedCount: _selectedContactIds.length,
        onCancelSelection: _toggleSelectionMode,
        onDeleteSelected: _deleteSelectedContacts,
        onMarkSelectedContacted: _markSelectedAsContacted,
        onArchiveSelected: _archiveSelectedContacts,
        onListAction: _handleListAction,
        searchController: _searchController,
        isArchivedView: isArchivedView,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _searchController.clear();
          Set<ContactListFilter> filtersToKeep = {
            isArchivedView ? ContactListFilter.archived : ContactListFilter.active
          };
          context.read<ContactListBloc>().add(const LoadContacts());
          context.read<ContactListBloc>().add(
              ToggleFilter(filter: filtersToKeep.first, enabled: true));
        },
        child: BlocBuilder<ContactListBloc, ContactListState>(
            builder: (context, state) {
          if (state is Initial) {
            return const Center(child: Text('Initializing contact list...'));
          } else if (state is Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is Loaded) {
            return Column(
              children: [
                ContactListFilterChips(
                  appliedFilters: state.appliedFilters,
                  onFilterToggled: (filter, enabled) {
                    context.read<ContactListBloc>().add(
                      ToggleFilter(filter: filter, enabled: enabled),
                    );
                  },
                  onFiltersCleared: (filtersToKeep) {
                    context.read<ContactListBloc>().add(
                      ClearFilters(filtersToKeep: filtersToKeep),
                    );
                  },
                  onSwitchView: () {
                    context.read<ContactListBloc>().add(
                      ToggleFilter(
                        filter: isArchivedView
                            ? ContactListFilter.active
                            : ContactListFilter.archived,
                        enabled: true,
                      ),
                    );
                  },
                ),
                if (state.displayedContacts.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        _getEmptyListMessage(state.appliedFilters),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  Expanded(child: _buildContactList(state.displayedContacts)),
              ],
            );
          } else if (state is Empty) {
            return Column(
              children: [
                ContactListFilterChips(
                  appliedFilters: const {ContactListFilter.active},
                  onFilterToggled: (filter, enabled) {
                    context.read<ContactListBloc>().add(
                      ToggleFilter(filter: filter, enabled: enabled),
                    );
                  },
                  onFiltersCleared: (filtersToKeep) {
                    context.read<ContactListBloc>().add(
                      ClearFilters(filtersToKeep: filtersToKeep),
                    );
                  },
                  onSwitchView: () {
                    context.read<ContactListBloc>().add(
                      const ToggleFilter(
                          filter: ContactListFilter.archived, enabled: true),
                    );
                  },
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                        'No contacts found. Add one using the + button below!'),
                  ),
                ),
              ],
            );
          } else if (state is Error) {
            return Center(
                child: Text('Error loading contacts: ${state.message}'));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        }),
      ),
      floatingActionButton: ContactListSpeedDial(
        onAddNewContact: _addNewContact,
        onImportContacts: _importContacts,
        onAddSampleContacts: _addSampleContacts, // Pass the method here
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  String _getEmptyListMessage(Set<ContactListFilter> filters) {
    if (filters.contains(ContactListFilter.archived)) {
      return 'No archived contacts found.';
    } else if (filters.contains(ContactListFilter.overdue) ||
        filters.contains(ContactListFilter.dueSoon)) {
      return 'No contacts match the selected filters.';
    } else {
      return 'No active contacts found.\nAdd one using the + button below!';
    }
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
