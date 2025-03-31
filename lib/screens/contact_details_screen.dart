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
import 'package:recall/screens/help_screen.dart'; // Import HelpScreen
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
  bool _initialized = false;
  bool _isEditMode = false; // State variable for edit mode
  final NotificationHelper notificationHelper = NotificationHelper();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    // Initialize with empty contact, will be populated by BLoC
    _localContact = Contact(
      id: 0,
      firstName: '',
      lastName: '',
      birthday: null,
      frequency: ContactFrequency.never.value,
      lastContacted: null,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final contactId =
          ModalRoute.of(context)!.settings.arguments as int?; // Allow null
      if (contactId != null && contactId != 0) {
        context
            .read<ContactDetailsBloc>()
            .add(ContactDetailsEvent.loadContact(contactId: contactId));
      } else {
        // Handle adding a new contact - Start in edit mode
        setState(() {
          _isEditMode = true;
          _hasUnsavedChanges = true; // Mark as changed since it's new
          _localContact = Contact(
            // Initialize with default new contact structure
            id: 0,
            firstName: '',
            lastName: '',
            frequency:
                ContactFrequency.never.value, // Or your preferred default
            birthday: null,
            lastContacted: null,
          );
          // Update controllers for the new empty contact
          _firstNameController.text = '';
          _lastNameController.text = '';
          _initialized = true; // Mark as initialized since we set it up
        });
        // Update BLoC with the initial empty state for a new contact
        context.read<ContactDetailsBloc>().add(
            ContactDetailsEvent.updateContactLocally(contact: _localContact));
      }
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
    // WillPopScope handles the back button press
    return WillPopScope(
      onWillPop: () => _onBackButtonPressed(context),
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<ContactDetailsBloc, ContactDetailsState>(
            builder: (context, state) {
              // Use maybeMap for safer access to loaded state data
              return Text(state.maybeMap(
                loaded: (loadedState) => _isEditMode
                    ? 'Edit Contact'
                    : '${loadedState.contact.firstName} ${loadedState.contact.lastName}',
                orElse: () => _isEditMode
                    ? 'Add Contact'
                    : 'Contact Details', // Default titles
              ));
            },
          ),
          // Automatically handles back navigation unless overridden by leading
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () =>
                  _onBackButtonPressed(context) // Ensure correct back logic
              ),
          actions: [
            // HELP BUTTON
            IconButton(
              icon: const Icon(Icons.help_outline),
              tooltip: 'Help',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelpScreen(
                          initialSection:
                              HelpSection.details), // Pass details section
                    ));
              },
            ),
            // Delete Button (conditionally enabled)
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete Contact',
              // Enable delete only for existing contacts (id != 0 and not null)
              onPressed: (_localContact.id != null && _localContact.id != 0)
                  ? () => _onDeleteButtonPressed(context)
                  : null,
            ),
            // Edit/Save Button
            BlocBuilder<ContactDetailsBloc, ContactDetailsState>(
                builder: (context, state) {
              final bool isLoaded =
                  state.maybeMap(loaded: (_) => true, orElse: () => false);
              final bool isNewContactMode =
                  (_localContact.id == 0 && _isEditMode);
              final bool canEditOrSave = isLoaded || isNewContactMode;
              final bool isDisabledByState = state.maybeMap(
                  loading: (_) => true,
                  initial: (_) => true,
                  orElse: () => false);

              // Determine if the save button should be enabled
              final bool canSaveChanges = canEditOrSave &&
                  !isDisabledByState &&
                  _isEditMode &&
                  _hasUnsavedChanges;
              // Determine if the edit button should be enabled
              final bool canEnterEdit =
                  canEditOrSave && !isDisabledByState && !_isEditMode;

              return IconButton(
                icon: Icon(_isEditMode ? Icons.save : Icons.edit),
                tooltip: _isEditMode ? 'Save Changes' : 'Edit Contact',
                // Enable Save only if in edit mode with unsaved changes & state allows
                // Enable Edit only if not in edit mode & state allows
                onPressed: _isEditMode
                    ? (canSaveChanges
                        ? () => _onSaveButtonPressed(context)
                        : null) // Enable save conditionally
                    : (canEnterEdit
                        ? () {
                            // Enable edit conditionally
                            state.mapOrNull(loaded: (loadedState) {
                              setState(() {
                                _isEditMode = true;
                                _localContact = loadedState.contact;
                                _firstNameController.text =
                                    _localContact.firstName;
                                _lastNameController.text =
                                    _localContact.lastName;
                              });
                            });
                          }
                        : null),
              );
            }),
          ],
        ),
        body: BlocConsumer<ContactDetailsBloc, ContactDetailsState>(
          listener: (context, state) {
            state.mapOrNull(
              // Use mapOrNull for concise handling of specific states
              loaded: (loadedState) {
                // Update local state ONLY if not currently editing OR if the ID differs
                if (!_isEditMode ||
                    (loadedState.contact.id != _localContact.id)) {
                  _localContact = loadedState.contact;
                  _firstNameController.text = _localContact.firstName;
                  _lastNameController.text = _localContact.lastName;
                }
                if (!_initialized) {
                  _initialized = true;
                }
              },
              error: (errorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: ${errorState.message}")));
                contactDetailScreenLogger.e(errorState.message);
              },
            );
          },
          builder: (context, state) {
            // Use maybeMap for safer state handling in the builder
            return state.maybeMap(
                loaded: (loadedState) => _buildForm(loadedState.contact),
                initial: (_) =>
                    const Center(child: CircularProgressIndicator()),
                loading: (_) =>
                    const Center(child: CircularProgressIndicator()),
                cleared: (_) =>
                    const Center(child: Text('Contact Details Cleared')),
                error: (errorState) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Error: ${errorState.message}",
                              style: const TextStyle(color: Colors.red)),
                          const SizedBox(height: 20),
                          // Show last known form state if available
                          if (_initialized)
                            Expanded(child: _buildForm(_localContact))
                          else
                            const Text("Could not load contact details."),
                        ],
                      ),
                    ),
                // Provide a fallback, especially for the new contact case before 'loaded' is emitted
                orElse: () {
                  // If adding a new contact (_isEditMode is true, id is 0), show the form
                  if (_isEditMode && _localContact.id == 0) {
                    return _buildForm(_localContact);
                  }
                  // Otherwise, it's likely initial/loading state before first load
                  return const Center(child: CircularProgressIndicator());
                });
          },
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                tooltip: 'Mark Contacted Today',
                icon: const Icon(Icons.check_circle_outline),
                onPressed: _onContactedButtonPressed,
              ),
              TextButton(
                onPressed: () {
                  if (_localContact.id != null && _localContact.id != 0) {
                    notificationHelper.showTestNotification(_localContact);
                  } else {
                    // Optional: Show a message if tapped for an unsaved contact
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Cannot send test notification for an unsaved contact.')),
                    );
                  }
                },
                child: const Text('Test Notification'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(Contact contact) {
    // Update controllers only if necessary and not in edit mode
    if ((!_initialized || contact.id != _localContact.id) && !_isEditMode) {
      _firstNameController.text = contact.firstName;
      _lastNameController.text = contact.lastName;
      _localContact = contact;
      if (!_initialized) _initialized = true;
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Display Section (Only visible when NOT in Edit Mode) ---
            if (!_isEditMode) ...[
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 24.0), // Add padding below name
                child: Text(
                  '${_localContact.firstName} ${_localContact.lastName}',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall, // Use a larger style
                ),
              ),
              _buildDisplayRow(
                  Icons.cake,
                  'Birthday:',
                  _localContact.birthday == null
                      ? 'Not set'
                      : DateFormat.yMd().format(_localContact.birthday!)),
              const SizedBox(height: 8.0),
              _buildDisplayRow(
                  Icons.celebration,
                  'Anniversary:', // Example Icon
                  _localContact.anniversary == null
                      ? 'Not set'
                      : DateFormat.yMd().format(_localContact.anniversary!)),
              const SizedBox(height: 8.0),
              _buildDisplayRow(Icons.access_time, 'Last Contacted:',
                  formatLastContacted(_localContact.lastContacted)),
              const SizedBox(height: 8.0),
              _buildDisplayRow(
                  Icons.repeat, 'Frequency:', _localContact.frequency),
              const SizedBox(height: 8.0),
              _buildDisplayRow(
                  Icons.next_plan_outlined,
                  'Next Due:',
                  calculateNextDueDateDisplay(
                    _localContact.lastContacted,
                    _localContact.frequency,
                  )),
              const SizedBox(height: 16.0),
            ],
            // --- End Display Section ---

            // --- Edit Section (Only visible IN Edit Mode) ---
            if (_isEditMode) ...[
              //First Name Input
              TextFormField(
                controller: _firstNameController,
                enabled: _isEditMode,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (_isEditMode && (value == null || value.isEmpty)) {
                    return 'Please enter a first name';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (_isEditMode) {
                    setState(() {
                      _localContact = _localContact.copyWith(firstName: value);
                      _hasUnsavedChanges = true;
                    });
                  }
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16.0),

              //Last Name Input
              TextFormField(
                controller: _lastNameController,
                enabled: _isEditMode,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (_isEditMode && (value == null || value.isEmpty)) {
                    return 'Please enter a last name';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (_isEditMode) {
                    setState(() {
                      _localContact = _localContact.copyWith(lastName: value);
                      _hasUnsavedChanges = true;
                    });
                  }
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 24.0),

              // Frequency Dropdown
              const Text('Contact Frequency:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                value: _localContact.frequency,
                onChanged: _isEditMode
                    ? (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _localContact =
                                _localContact.copyWith(frequency: newValue);
                            _hasUnsavedChanges = true;
                          });
                        }
                      }
                    : null,
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
              const SizedBox(height: 16.0),

              // Birthday Picker
              const Text('Birthday:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: _isEditMode
                    ? () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _localContact.birthday ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (!mounted) return;
                        if (picked != null &&
                            picked != _localContact.birthday) {
                          setState(() {
                            _localContact =
                                _localContact.copyWith(birthday: picked);
                            _hasUnsavedChanges = true;
                          });
                        }
                      }
                    : null,
                child: Text(_localContact.birthday == null
                    ? 'Select Birthday'
                    : DateFormat.yMd().format(_localContact.birthday!)),
              ),
              const SizedBox(height: 20),
              // Anniversary Picker
              const Text('Anniversary:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: _isEditMode
                    ? () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _localContact.anniversary ??
                              DateTime.now(), // Use anniversary or now
                          firstDate: DateTime(1900), // Adjust range as needed
                          lastDate: DateTime.now().add(const Duration(
                              days: 365 *
                                  10)), // Allow future dates? Adjust as needed
                        );
                        if (!mounted) return;
                        if (picked != null &&
                            picked != _localContact.anniversary) {
                          setState(() {
                            // Use copyWith, generated code handles the new field
                            _localContact =
                                _localContact.copyWith(anniversary: picked);
                            _hasUnsavedChanges = true;
                          });
                        }
                      }
                    : null,
                child: Text(_localContact.anniversary == null
                    ? 'Select Anniversary'
                    : DateFormat.yMd().format(_localContact.anniversary!)),
              ),
              const SizedBox(height: 20), // Spacing at the end of the form
            ]
            // --- End Edit Section ---
          ],
        ),
      ),
    );
  }

  // Helper to build display rows consistently
  Widget _buildDisplayRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18.0, color: Colors.grey[700]),
          const SizedBox(width: 12.0),
          SizedBox(
              width: 110,
              child: Text('$label ',
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  // Handles back navigation
  Future<bool> _onBackButtonPressed(BuildContext context) async {
    if (_isEditMode && _hasUnsavedChanges) {
      final bool discard = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Discard Changes?'),
              content: const Text(
                  'You have unsaved changes. Are you sure you want to discard them and exit?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Discard'),
                ),
              ],
            ),
          ) ??
          false;

      if (discard) {
        if (mounted) {
          setState(() {
            _isEditMode = false;
            _hasUnsavedChanges = false;
            _initialized = false;
          });
          Navigator.of(context).pop();
        }
        return Future.value(false);
      } else {
        return Future.value(false);
      }
    } else {
      if (mounted) {
        setState(() {
          _isEditMode = false;
        });
        Navigator.of(context).pop();
      }
      return Future.value(false);
    }
  }

  // Handles the save action
  void _onSaveButtonPressed(BuildContext context) {
   // Form validation check
   if (_formKey.currentState!.validate()) {
     final currentState = context.read<ContactDetailsBloc>().state;
     Contact contactToSave = _localContact;
     bool isExistingContact = contactToSave.id != null && contactToSave.id != 0;

     // Check if state allows saving
     bool canProceed = currentState.maybeMap(
         loaded: (_) => true,
         orElse: () => !isExistingContact
     );

     if (!canProceed && mounted) { // Add mounted check
          ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Cannot save, contact state is inconsistent.')),
          );
          return;
     }

     // --- Dispatch event ---
     if (!isExistingContact) {
       context.read<ContactDetailsBloc>().add(ContactDetailsEvent.addContact(contact: contactToSave));
       if (mounted) { // Add mounted check before showing SnackBar
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('New contact saved')),
         );
       }
     } else {
       context.read<ContactDetailsBloc>().add(ContactDetailsEvent.saveContact(contact: contactToSave));
        if (mounted) { // Add mounted check before showing SnackBar
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Changes saved')),
         );
       }
     }

     // --- Update local state and Navigate Back ---
     // Do this after dispatching the event
      if (mounted) { // Add mounted check before setState and pop
         setState(() {
             _hasUnsavedChanges = false;
             _isEditMode = false; // Exit edit mode
         });
         context.read<ContactListBloc>().add(const ContactListEvent.loadContacts()); // Refresh list
         Navigator.of(context).pop(); // Go back to the list screen
      }

   } else {
     // Form validation failed
      if (mounted) { // Add mounted check before showing SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Please correct the errors before saving.')),
        );
      }
   }
 }

  // Handles the delete action
  void _onDeleteButtonPressed(BuildContext context) {
    if (_localContact.id == null || _localContact.id == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot delete unsaved contact.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text(
              'Are you sure you want to delete ${_localContact.firstName} ${_localContact.lastName}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final contactIdToDelete = _localContact.id!;
                Navigator.of(dialogContext).pop();

                if (mounted) {
                  context.read<ContactDetailsBloc>().add(
                      ContactDetailsEvent.deleteContact(
                          contactId: contactIdToDelete));
                  context
                      .read<ContactListBloc>()
                      .add(const ContactListEvent.loadContacts());
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Handles marking the contact as contacted today.
  void _onContactedButtonPressed() {
    if (_localContact.id == null || _localContact.id == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Save the contact first.')),
      );
      return;
    }

    final now = DateTime.now();
    final updatedContact = _localContact.copyWith(lastContacted: now);

    setState(() {
      _localContact = updatedContact;
      _hasUnsavedChanges = false;
    });

    context
        .read<ContactDetailsBloc>()
        .add(ContactDetailsEvent.saveContact(contact: updatedContact));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('Marked as contacted: ${DateFormat.yMd().format(now)}')),
    );
    context.read<ContactListBloc>().add(const ContactListEvent.loadContacts());
  }
}
