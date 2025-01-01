import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recall/blocs/contact_details/contact_details_bloc.dart';
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
  // ...other controllers

  @override
  // Initializes the state of the widget, setting up controllers and loading initial contact data.
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: 'First name');
    _lastNameController = TextEditingController(text: 'Last name');
    _birthday = null;
    //_frequency = ContactFrequency.daily;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final contactId = ModalRoute.of(context)!.settings.arguments as int;
      contactDetailScreenLogger.i(
          "LOG: Received contact ID in ContactDetailsScreen: $contactId"); // <-- Add this line
      context.read<ContactDetailsBloc>().add(LoadContact(contactId));
      contactDetailScreenLogger.i("LOG: ContactDetailsBloc is loaded");
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
      appBar: AppBar(title: const Text('Contact Details')),
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
            _firstNameController.text = state.contact.firstName;
            _lastNameController.text = state.contact.lastName;
            _birthday = state.contact.birthday;
            //_frequency = state.contact.frequency;
            contactDetailScreenLogger
                .i("LOG: into _buildForm ${state.contact}");
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
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                // Save Button: When pressed, updates the contact with the new values.
                // When the save button is pressed, update the contact details in the Bloc
                // and navigate back to the previous screen.
                final currentState = context.read<ContactDetailsBloc>().state;
                contactDetailScreenLogger.i("LOG: current state: $currentState");
                if (currentState is ContactDetailsLoaded) {
                  final updatedContact = currentState.contact.copyWith(
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    birthday: _birthday,
                    //frequency: _frequency,
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
                  //Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(Contact contact) {
    // This function builds the form for editing contact details.
    // Builds the form for editing contact details.
    contactDetailScreenLogger.i("LOG:_selectedDate in _buildForm: $_birthday");
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
              },
            ),
            TextFormField(
              // Input field for the last name
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
              onChanged: (value) {
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
                  context
                      .read<ContactDetailsBloc>()
                      .add(UpdateBirthday(picked, contact.id));
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
