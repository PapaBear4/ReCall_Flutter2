import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recall/blocs/contact_details/contact_details_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

var contactDetailScreenLogger = Logger();

// Widget representing the screen for viewing and editing contact details.
class ContactDetailsScreen extends StatefulWidget {
  final int contactId;

  const ContactDetailsScreen({super.key, required this.contactId});

  @override
  State<ContactDetailsScreen> createState() => _ContactDetailsScreenState();
}

// State class for managing the ContactDetailsScreen widget.
class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  final _formKey = GlobalKey<_ContactDetailsScreenState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late DateTime? _birthday;
  //ContactFrequency? _frequency;
  Contact? _localContact; // Local variable to hold temporary state
  bool _hasUnsavedChanges = false;
  // ...other controllers

  @override
  // Initializes the state of the widget, setting up controllers and loading initial contact data.
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: 'First name');
    _lastNameController = TextEditingController(text: 'Last name');
    _birthday = null;
    _localContact = null;
    //_frequency = ContactFrequency.daily;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final contactId = ModalRoute.of(context)!.settings.arguments as int;
      //contactDetailScreenLogger          .i("LOG: Received request for ID: $contactId"); // <-- Add this line
      context.read<ContactDetailsBloc>().add(LoadContact(contactId));
      //contactDetailScreenLogger.i("LOG: Loaded: ");
    });
  }

  @override
  // Disposes of controllers when the widget is removed from the tree.
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  // Builds the UI of the ContactDetailsScreen.
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // If there are unsaved changes, show a confirmation dialog
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
                          Navigator.of(context).pop(), // Close the dialog
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        Navigator.of(context).pop(); // Navigate back
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
        // BlocConsumer listens for state changes and rebuilds the UI or performs actions accordingly.
        listener: (context, state) {
          // This listener is called whenever the state of the ContactDetailsBloc changes.
          // This listener handles events emitted by the ContactDetailsBloc
          // and updates the UI accordingly. In this case, it shows a snackbar if there's an error.
          if (state is ContactDetailsError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          // This builder function is responsible for building the UI based on the current state.
          if (state is ContactDetailsLoading) {
            // If the state is ContactDetailsLoading, show a CircularProgressIndicator.
            // While the contact details are loading, show a CircularProgressIndicator.
            return const Center(child: CircularProgressIndicator());
          } else if (state is ContactDetailsLoaded) {
            // If the state is ContactDetailsLoaded, populate the form with contact data.
            _localContact = state.contact; // Initialize localContact if null
            //contactListLogger.i("LOG: state is $state.contact");
            //contactListLogger.i("LOG: loaded: $_localContact");
            _firstNameController.text = _localContact!.firstName;
            _lastNameController.text = _localContact!.lastName;
            _birthday = _localContact!.birthday;
            //_frequency = state.contact.frequency;
            //contactDetailScreenLogger
            //    .i("LOG: into _buildForm ${state.contact}");
            // If the contact details are loaded, build the form with the contact data.
            return _buildForm(state.contact);
          } else if (state is ContactDetailsError) {
            // If the state is ContactDetailsError, display an error message.
            // If there's an error loading the contact details, display an error message.
            return Center(child: Text(state.message));
          }
          // Default case: Return an empty container if the state is not recognized.
          return Container();
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 0), // Empty space on the left
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                // Save Button: When pressed, updates the contact with the new values.
                // When the save button is pressed, update the contact details in the Bloc
                // and navigate back to the previous screen.
                final currentState = context.read<ContactDetailsBloc>().state;
                contactDetailScreenLogger
                    .i("LOG: current state: $currentState");
                if (currentState is ContactDetailsLoaded) {
                  final updatedContact = _localContact!.copyWith(
                      //firstName: _firstNameController.text,
                      //lastName: _lastNameController.text,
                      //birthday: _birthday,
                      ////frequency: _frequency,
                      );
                  contactDetailScreenLogger
                      .i("LOG: new contact: $updatedContact");
                  context
                      .read<ContactDetailsBloc>()
                      .add(UpdateContactDetails(updatedContact));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Changes saved')),
                  );
                  // Navigate back to the contact list
                  context.read<ContactListBloc>().add(ContactUpdated());
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
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              contactDetailScreenLogger.i(
                                  "LOG: Delete button pressed for ${_localContact!.id}");
                              context
                                  .read<ContactListBloc>()
                                  .add(DeleteContact(_localContact!.id));
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

  Widget _buildForm(Contact contact) {
    // This function builds the form for editing contact details.
    // Builds the form for editing contact details.
    //contactDetailScreenLogger.i("LOG:_selectedDate in _buildForm: $_birthday");
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align items to the left
          children: <Widget>[
            TextFormField(
              // Input field for the first name
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
              onChanged: (value) {
                // Update contact details in the state
                _localContact = _localContact!
                    .copyWith(firstName: _firstNameController.text);
                _hasUnsavedChanges = true;
              },
            ),
            TextFormField(
              // Input field for the last name
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
              onChanged: (value) {
                _localContact =
                    _localContact!.copyWith(lastName: _lastNameController.text);
                _hasUnsavedChanges = true;
                // Update contact details in the state
              },
            ),
            const SizedBox(height: 8.0), // Add vertical space
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text('Birthday:'),
            ),
            ElevatedButton(
              // Button to select the birthday using a date picker
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _birthday ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (picked != null) {
                  setState(() {
                    _localContact = _localContact!.copyWith(birthday: picked);
                    _birthday = picked;
                  });
                  //context.read<ContactDetailsBloc>().add(UpdateBirthday(picked, contact.id));
                  _hasUnsavedChanges = true;
                }
              },
              child: Text(_birthday == null
                  ? 'Select Birthday'
                  : DateFormat.yMd().format(_birthday!)),
            ),

            // Other fields...
          ],
        ),
      ),
    );
  }
}
