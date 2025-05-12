import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:recall/blocs/contact_details/contact_details_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/utils/debug_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:recall/config/app_router.dart';

class AddContactSpeedDial extends StatelessWidget {
  final ContactListEvent onRefreshListEvent;

  const AddContactSpeedDial({
    super.key,
    required this.onRefreshListEvent,
  });

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      spacing: 3,
      mini: false,
      // openCloseDial: ValueNotifier<bool>(_isDialOpen), // SpeedDial manages its own state
      buttonSize: const Size(56.0, 56.0),
      childrenButtonSize: const Size(56.0, 56.0),
      visible: true,
      curve: Curves.bounceIn,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      elevation: 8.0,
      shape: const CircleBorder(),
      children: [
        SpeedDialChild(
          child: const Icon(Icons.person_add_alt_1),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          label: 'Add Manually',
          onTap: () {
            context
                .read<ContactDetailsBloc>()
                .add(const ClearContactEvent());
            context.pushNamed(AppRouter.newContactRouteName);
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.import_contacts),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          label: 'Import from Device',
          onTap: () {
            context.pushNamed(AppRouter.importContactsRouteName);
          },
        ),
        if (kDebugMode) // Only show this option in debug mode
          SpeedDialChild(
            child: const Icon(Icons.bug_report),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            label: 'Add Fake Contacts (Debug)',
            onTap: () async {
              final contactRepo = context.read<ContactRepository>();
              final result =
                  await DebugUtils.addSampleAppContacts(contactRepo);
              // Check if the widget is still mounted before showing SnackBar or dispatching event
              if (Navigator.of(context).mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result)),
                );
                // Refresh the contact list
                context.read<ContactListBloc>().add(onRefreshListEvent);
              }
            },
          ),
      ],
    );
  }
}
