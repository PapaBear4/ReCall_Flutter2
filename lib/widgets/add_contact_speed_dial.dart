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
  final int activeContactCount;
  final int maxActiveContacts;

  const AddContactSpeedDial({
    super.key,
    required this.onRefreshListEvent,
    required this.activeContactCount,
    required this.maxActiveContacts,
  });

  @override
  Widget build(BuildContext context) {
    final bool limitReached = activeContactCount >= maxActiveContacts;
    final Color fabColor = limitReached ? Colors.red : Theme.of(context).colorScheme.primary;

    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      spacing: 3,
      mini: false,
      buttonSize: const Size(56.0, 56.0),
      childrenButtonSize: const Size(56.0, 56.0),
      visible: true,
      curve: Curves.bounceIn,
      backgroundColor: fabColor,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      elevation: 8.0,
      shape: const CircleBorder(),
      // onTap will be triggered when the main FAB is tapped.
      // We use this to show the dialog if the limit is reached.
      onPress: limitReached ? () {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Active Contact Limit Reached'),
              content: const Text('You may only have 18 Active contacts. Please deactivate some contacts first.'),
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
      } : null, // If null, the default behavior (opening the dial) occurs.
      children: limitReached ? [] : [ // Only show children if limit is NOT reached
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
