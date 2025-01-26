// lib/screens/contact_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recall/blocs/contact_details/contact_details_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:recall/models/contact_frequency.dart';
import 'package:recall/services/notification_helper.dart';

import '../utils/last_contacted_utils.dart';

var contactDetailScreenLogger = Logger();

class ContactDetailsScreen extends StatefulWidget {
  final int? contactId;

  const ContactDetailsScreen({super.key, this.contactId});

  @override
  State<ContactDetailsScreen> createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late Contact _localContact;
  bool _hasUnsavedChanges = false;
  bool _initialized = false; // Build the form for editing contact details
  final NotificationHelper notificationHelper = NotificationHelper();

  // ...other controllers

  @override
  // Initialize state, controllers, and load contact data
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _localContact = Contact(
      id: 0,
      firstName: '',
      lastName: '',
      birthday: null,
      frequency: ContactFrequency.never.value,
      lastContacted: null,
    );

    //Once everything is loaded up, go back to get the contactId
    //and load the data into the bloc
    //TODO: Might need to add an IF statement in here for the contactId=null
    //case for when adding a new contact is something that happens before
    //viewing an existing contact.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final contactId = ModalRoute.of(context)!.settings.arguments as int;
      //contactDetailLogger.i("LOG received ID $contactId");
      if (contactId != 0) {
        context
            .read<ContactDetailsBloc>()
            .add(ContactDetailsEvent.loadContact(contactId: contactId));
      } else {
        context
            .read<ContactDetailsBloc>()
            .add(ContactDetailsEvent.updateContactLocally(
                contact: Contact(
              id: 0,
              firstName: '',
              lastName: '',
              frequency: ContactFrequency.never.value,
              birthday: null,
              lastContacted: null,
            )));
      }
    });
  }
/*
  @override
  // Update UI when dependencies change, especially when contact details are loaded
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.watch<ContactDetailsBloc>().state;
    if (state is ContactDetailsState.loaded) {
      _localContact = state.contact;
      _firstNameController.text = _localContact.firstName;
      _lastNameController.text = _localContact.lastName;
    }
  }*/

  @override
  // Dispose of controllers to prevent memory leaks
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  // Build the contact details screen UI
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Details'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _onBackButtonPressed(context)),
      ),
      body: BlocConsumer<ContactDetailsBloc, ContactDetailsState>(
        listener: (context, state) {
          state.mapOrNull(error: (errorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(errorState.message)));
            contactDetailScreenLogger.e('$errorState.message');
          });
        },
        builder: (context, state) {
          return state.map(
            initial: (_) => const Center(child: CircularProgressIndicator()),
            loading: (_) => const Center(child: CircularProgressIndicator()),
            loaded: (loadedState) =>
                _buildForm(loadedState.contact), // We'll define this later
            cleared: (_) => const Center(child: Text('Contact Cleared')),
            error: (errorState) => Center(child: Text(errorState.message)),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () => _onSaveButtonPressed(context),
            ),
            ElevatedButton(
              onPressed: () {
                notificationHelper.showTestNotification(_localContact);
              },
              child: const Text('Send Test Notification'),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _onDeleteButtonPressed(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(Contact contact) {
    if (!_initialized) {
      _firstNameController.text = contact.firstName;
      _lastNameController.text = contact.lastName;
      _localContact = contact;
      _initialized = true;
    }
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //First Name
            TextFormField(
              controller: _firstNameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'First Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a first name';
                }
                return null;
              },
              onChanged: (value) {
                _hasUnsavedChanges = true;
                setState(() {
                  _localContact = _localContact.copyWith(firstName: value);
                });
              },
              onFieldSubmitted: (value) {
                context.read<ContactDetailsBloc>().add(
                    ContactDetailsEvent.updateContactLocally(
                        contact: _localContact));
              },
              textInputAction: TextInputAction.next,
            ),
            //Display when they are next due to be contacted
            Text(calculateNextDueDateDisplay(
              _localContact.lastContacted,
              _localContact.frequency,
            )),
            TextFormField(
              //Last Name
              controller: _lastNameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Last Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a last name';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _localContact = _localContact.copyWith(lastName: value);
                });
                _hasUnsavedChanges = true;
              },
              textInputAction: TextInputAction.done,
            ),
            // Dropdown for Contact Frequency
            const SizedBox(height: 16.0),
            const Text('Contact Frequency:'),
            DropdownButtonFormField<String>(
              value: _localContact.frequency,
              onTap: () {
                context.read<ContactDetailsBloc>().add(
                    ContactDetailsEvent.updateContactLocally(
                        contact: _localContact));
              },
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _localContact = _localContact.copyWith(frequency: newValue);
                  });
                  //update bloc again with selection
                  context.read<ContactDetailsBloc>().add(
                      ContactDetailsEvent.updateContactLocally(
                          contact: _localContact));
                  _hasUnsavedChanges = true;
                }
              },
              items: ContactFrequency.values.map((frequency) {
                return DropdownMenuItem<String>(
                  value: frequency.value,
                  child: Text(frequency.name),
                );
              }).toList(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              ),
            ),

            const SizedBox(height: 8.0),
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text('Birthday:'),
            ),
            ElevatedButton(
              onPressed: () async {
                //update bloc before launching dialog
                context.read<ContactDetailsBloc>().add(
                    ContactDetailsEvent.updateContactLocally(
                        contact: _localContact));

                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _localContact.birthday ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (!mounted) return;
                if (picked != null && picked != _localContact.birthday) {
                  setState(() {
                    _localContact = _localContact.copyWith(birthday: picked);
                  });
                  context.read<ContactDetailsBloc>().add(
                      ContactDetailsEvent.updateContactLocally(
                          contact: _localContact));

                  _hasUnsavedChanges = true;
                }
              },
              child: Text(_localContact.birthday == null
                  ? 'Select Birthday'
                  : DateFormat.yMd().format(_localContact.birthday!)),
            ),

            // Other fields...
          ],
        ),
      ),
    );
  }

  void _onBackButtonPressed(BuildContext context) {
    context
        .read<ContactDetailsBloc>()
        .add(ContactDetailsEvent.updateContactLocally(contact: _localContact));
    if (_hasUnsavedChanges) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Discard Changes?'),
          content: const Text(
              'You have unsaved changes. Are you sure you want to discard them?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(), //close dialog
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); //close dialog
                context
                    .read<ContactDetailsBloc>()
                    .add(ContactDetailsEvent.clearContact());
                Navigator.of(context).pop(); //return to list
              },
              child: const Text('Discard'),
            ),
          ],
        ),
      );
    } else {
      Navigator.of(context).pop(); //close dialog
    }
  }

  void _onSaveButtonPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final state = context.read<ContactDetailsBloc>().state;
      state.mapOrNull(loaded: (loadedState) {
        // IF Id = 0, add the new contact
        if (loadedState.contact.id == 0) {
          context
              .read<ContactDetailsBloc>()
              .add(ContactDetailsEvent.addContact(contact: _localContact));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('New contact saved')),
          );
        } else {
          //otherwise update the current contact
          //contactDetailScreenLogger.i('LOG: initiate save');
          context
              .read<ContactDetailsBloc>()
              .add(ContactDetailsEvent.saveContact(contact: _localContact));
          //context
          //    .read<ContactDetailsBloc>()
          //    .add(ContactDetailsEvent.clearContact());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Changes saved')),
          );
        }
        //reload the list
        context.read<ContactListBloc>().add(ContactListEvent.loadContacts());
        Navigator.of(context).pop(); //close details screen
      });
    }
  }

  void _onDeleteButtonPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this contact?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                //Delete contact
                context.read<ContactDetailsBloc>().add(
                    ContactDetailsEvent.deleteContact(
                        contactId: _localContact.id!));
                //Reload list screen
                context
                    .read<ContactListBloc>()
                    .add(ContactListEvent.loadContacts());
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Navigate back
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
