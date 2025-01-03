import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recall/blocs/contact_details/contact_details_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

var contactDetailScreenLogger = Logger();

class ContactDetailsScreen extends StatefulWidget {
  final int contactId;

  const ContactDetailsScreen({super.key, required this.contactId});

  @override
  State<ContactDetailsScreen> createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late Contact _localContact;
  bool _hasUnsavedChanges = false;
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
      frequency: ContactFrequency.never,
      lastContacted: null,
    );

    //Once everything is loaded up, go back to get the contactId
    //and load the data into the bloc
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final contactId = ModalRoute.of(context)!.settings.arguments as int;
      context.read<ContactDetailsBloc>().add(LoadContact(contactId));
    });
  }

  @override
  // Update UI when dependencies change, especially when contact details are loaded
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.watch<ContactDetailsBloc>().state;
    if (state is ContactDetailsLoaded) {
      _localContact = state.contact;
      _firstNameController.text = _localContact.firstName;
      _lastNameController.text = _localContact.lastName;
        if (_localContact.birthday != null) {
          // Assuming you have a method to update your birthday picker
          _updateBirthdayPicker(_localContact.birthday!); 
      }
    }
  }

  void _updateBirthdayPicker(DateTime date) {
      // This is a placeholder. You'll need to implement the logic 
      // to update the state of your birthday picker based on the 
      // provided date.
      // Example:
      // _birthdayPickerController.text = DateFormat.yMd().format(date);
      // _selectedBirthday = date;
  }

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
          onPressed: () {
            if (_hasUnsavedChanges) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Discard Changes?'),
                  content: const Text(
                      'You have unsaved changes. Are you sure you want to discard them?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); 
                      },
                      child: const Text('Discard'),
                    ),
                  ],
                ),
              );
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: BlocConsumer<ContactDetailsBloc, ContactDetailsState>(
        listener: (context, state) {
          if (state is ContactDetailsError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));          
          }
        },
        builder: (context, state) {
          if (state is ContactDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ContactDetailsLoaded) {
            return _buildForm();
          } else if (state is ContactDetailsError) {
            
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 0),
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {

                final currentState = context.read<ContactDetailsBloc>().state;
                contactDetailScreenLogger
                    .i("LOG: current state: $currentState");
                if (currentState is ContactDetailsLoaded) {
                  final updatedContact = _localContact;
                  contactDetailScreenLogger
                      .i("LOG: new contact: $updatedContact");
                  context
                      .read<ContactDetailsBloc>()
                      .add(UpdateContactDetails(updatedContact));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Changes saved')),
                  );
                  if (_localContact.id == 0) {                    
                    context.read<ContactListBloc>()
                        .add(AddContact(updatedContact));                    
                  } else {
                    context.read<ContactListBloc>().add(ContactUpdated());
                  }
                  Navigator.of(context).pop();
                }
              },
            ),
            IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Deletion'),
                        content: const Text(
                            'Are you sure you want to delete this contact?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();  // Close the dialog
                            },                            
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              contactDetailScreenLogger.i(
                                  "LOG: Delete button pressed for ${_localContact.id}");
                              context
                                  .read<ContactListBloc>()
                                  .add(DeleteContact(_localContact.id));                                
                              Navigator.of(context).pop(); // Close the dialog
                              Navigator.of(context).pop(); // Navigate back
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }

  // Build the form for editing contact details
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a first name';
                }
                return null;
              },
              onChanged: (value) {
                contactDetailScreenLogger
                    .i("LOG: OLD value ${_localContact.firstName}");                
                setState(() {
                  _localContact = _localContact.copyWith(firstName: value);
                });
                contactDetailScreenLogger
                    .i("LOG: new value ${_localContact.firstName}");
                _hasUnsavedChanges = true;
              },
            ),
            TextFormField(              
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a last name';
                }
                return null;
              },
              onChanged: (value) {
                _localContact = _localContact.copyWith(lastName: value);
                _hasUnsavedChanges = true;
              },
            ),
            const SizedBox(height: 8.0),
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text('Birthday:'),
            ),
            ElevatedButton(              
              onPressed: () async {
                contactDetailScreenLogger
                    .i("LOG: pre launch value ${_localContact.firstName}");

                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _localContact.birthday ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                contactDetailScreenLogger
                    .i("LOG: post launch value ${_localContact.firstName}");

                if (picked != null && picked != _localContact.birthday) {
                  setState(() {
                    _localContact = _localContact.copyWith(birthday: picked);
                  });
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
}
