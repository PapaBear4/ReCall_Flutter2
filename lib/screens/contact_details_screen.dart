import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recall/blocs/contact_details/contact_details_bloc.dart';
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
  final _formKey = GlobalKey<_ContactDetailsScreenState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  DateTime? _selectedDate;
  ContactFrequency? _frequency;
  // ...other controllers

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _frequency = ContactFrequency.daily;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final contactId = ModalRoute.of(context)!.settings.arguments as int;
      contactDetailScreenLogger.i(
          "Received contact ID in ContactDetailsScreen: $contactId"); // <-- Add this line
      context.read<ContactDetailsBloc>().add(LoadContact(contactId));
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Details')),
      body: BlocConsumer<ContactDetailsBloc, ContactDetailsState>(
        listener: (context, state) {
          // This listener handles events emitted by the ContactDetailsBloc
          // and updates the UI accordingly. In this case, it shows a snackbar if there's an error.
          if (state is ContactDetailsError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ContactDetailsLoading) {
            // While the contact details are loading, show a CircularProgressIndicator.
            return const Center(child: CircularProgressIndicator());
          } else if (state is ContactDetailsLoaded) {
            _firstNameController.text = state.contact.firstName;
            _lastNameController.text = state.contact.lastName;
            _selectedDate = state.contact.birthday;
            _frequency = state.contact.frequency;
            contactDetailScreenLogger
                .i("LOG: into _buildForm ${state.contact}");
            // If the contact details are loaded, build the form with the contact data.
            return _buildForm(state.contact);
          } else if (state is ContactDetailsError) {
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
                // When the save button is pressed, update the contact details in the Bloc
                // and navigate back to the previous screen.
                final state = context.read<ContactDetailsBloc>().state;
                contactDetailLogger.i("LOG: current state: $state");
                if (state is ContactDetailsLoaded) {
                  final updatedContact = state.contact.copyWith(
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    birthday: _selectedDate,
                    frequency: _frequency,
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
    // Builds the form for editing contact details.
    contactDetailScreenLogger
        .i("LOG:_selectedDate in _buildForm: $_selectedDate");
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
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (picked != null) {
                  context
                      .read<ContactDetailsBloc>()
                      .add(UpdateBirthday(picked, contact.id));
                }
              },
              child: Text(_selectedDate == null
                  ? 'Select Birthday'
                  : DateFormat.yMd().format(_selectedDate!)),
            ),

            // Other fields...
          ],
        ),
      ),
    );
  }
}
