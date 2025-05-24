import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/widgets/app_drawer.dart';
import 'package:recall/widgets/base_contact_list_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:recall/config/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  @override
  void initState() {
    super.initState();
    context.read<ContactListBloc>().add(
          const LoadContactListEvent(
            filters: {ContactListFilterType.homescreen},
            sortField: ContactListSortField.nextContactDate,
            ascending: true,
          ),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppRouter.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    AppRouter.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when the top route has been popped off, and the current route shows up.
    context.read<ContactListBloc>().add(
          const LoadContactListEvent(
            filters: {ContactListFilterType.homescreen},
            sortField: ContactListSortField.nextContactDate,
            ascending: true,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BaseContactListScaffold(
      screenTitle: 'reCall Home',
      emptyListText: 'No upcoming or overdue reminders.',
      activeContactCount: 0, // Provide a default or fetch if needed for this screen
      maxActiveContacts: 18, // Provide the max limit
      // Always load active contacts that are overdue, due today, or due tomorrow
      onRefreshEvent: const LoadContactListEvent(
        filters: {ContactListFilterType.homescreen},
        sortField: ContactListSortField.nextContactDate,
        ascending: true, // Most overdue first
      ),
      initialScreenLoadEvent: const LoadContactListEvent(
        filters: {ContactListFilterType.homescreen},
        sortField: ContactListSortField.nextContactDate,
        ascending: true, // Most overdue first
      ),

      drawerWidget: buildAppDrawer(context, true),
      fabHeroTagPrefix: 'home',
      showSearchBar: false, // No search bar needed for this screen
      showFilterMenu: false, // No filter menu needed
      showSortMenu: false, // No sort menu needed
      sortMenuItems: (_) => [], // Provide an empty list for sort menu items
      filterMenuItems: (_) => [], // Provide an empty list for filter menu items
      handleListAction:
          (_, __, ___) {}, // Provide an empty callback for list actions
      debugRefreshEvent: const LoadContactListEvent(
        filters: {ContactListFilterType.homescreen},
        sortField: ContactListSortField.nextContactDate,
        ascending: true, // Most overdue first
      ),
      appBarActions: [
        TextButton(
          onPressed: () {
            // Navigate using go_router's named route for the full contact list
            // Using pushNamed to add it to the navigation stack
            context.read<ContactListBloc>().add(
                  const LoadContactListEvent(
                    filters: {
                      ContactListFilterType.active,
                    }, // Pre-load active contacts
                    sortField: ContactListSortField.lastName,
                    ascending: true, // alphabetical order
                  ),
                );
            // Navigate and then refresh HomeScreen when ContactListScreen is popped
            context.pushNamed(AppRouter.contactListRouteName).then((_) {
              if (mounted) { // Check if HomeScreen's state is still mounted
                context.read<ContactListBloc>().add(
                      const LoadContactListEvent(
                        filters: {ContactListFilterType.homescreen}, // Reload with HomeScreen filters
                        sortField: ContactListSortField.nextContactDate,
                        ascending: true,
                      ),
                    );
              }
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'ALL',
                style: TextStyle(
                  // Adapting to AppBar's brightness or using a fixed color
                  color: Theme.of(context).appBarTheme.titleTextStyle?.color ??
                      const Color.fromARGB(255, 98, 3, 241),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_ios,
                size: 16.0,
                color: Theme.of(context).appBarTheme.iconTheme?.color ??
                    const Color.fromARGB(255, 20, 5, 191),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
