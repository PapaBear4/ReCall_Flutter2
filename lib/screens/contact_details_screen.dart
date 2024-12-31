import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recall/blocs/contact_details/contact_details_bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:intl/intl.dart';

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
  ContactFrequency? _selectedFrequency;
  // ...other controllers

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _selectedFrequency = ContactFrequency.daily;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final contactId = ModalRoute.of(context)!.settings.arguments as int;
      print(
          'Received contact ID in ContactDetailsScreen: $contactId'); // <-- Add this line
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
          if (state is ContactDetailsError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ContactDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ContactDetailsLoaded) {
            _firstNameController.text = state.contact.firstName;
            _lastNameController.text = state.contact.lastName;
            _selectedDate = state.contact.birthday;
            _selectedFrequency = state.contact.frequency;
            return _buildForm(state.contact);
          } else if (state is ContactDetailsError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildForm(Contact contact) {
    //print('_selectedDate in _buildForm: $_selectedDate');
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align items to the left
          children: <Widget>[
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
              onChanged: (value) {
                // Update contact details in the state
              },
            ),
            TextFormField(
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
            ElevatedButton(
                onPressed: () {
                  final updatedContact = contact.copyWith(
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    birthday: _selectedDate,
                    frequency: _selectedFrequency,
                  );
                  context
                      .read<ContactDetailsBloc>()
                      .add(UpdateContactDetails(updatedContact));
                },
                child: const Text('Save Changes')),
          ],
        ),
      ),
    );
  }
}
