// lib/screens/contact_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:recall/blocs/contact_details/contact_details_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:recall/models/contact_frequency.dart';
import 'package:recall/repositories/usersettings_repository.dart';
import 'package:recall/screens/settings_screen.dart'; // Keep this import if logger is used there
import 'package:recall/services/notification_helper.dart';
import 'package:recall/screens/help_screen.dart';
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
  // --- New Controllers Start ---
  late TextEditingController _phoneNumberController;
  late TextEditingController _notesController;
  late TextEditingController _youtubeController;
  late TextEditingController _instagramController;
  late TextEditingController _facebookController;
  late TextEditingController _snapchatController;
  late TextEditingController _tiktokController;
  // Controller for adding new emails - manages the list internally
  final List<TextEditingController> _emailControllers = [];
  // --- New Controllers End ---

  late Contact _localContact;
  bool _hasUnsavedChanges = false;
  bool _initialized = false;
  bool _isEditMode = false;
  final NotificationHelper notificationHelper = NotificationHelper();

  // Define the formatter instance (can be defined here or inside build)
  final phoneMaskFormatter = MaskTextInputFormatter(
      mask: '(###) ###-####', // Standard US format
      filter: {"#": RegExp(r'[0-9]')}, // Allow only digits where # is
      type: MaskAutoCompletionType.lazy // Or .eager
      );

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    // --- Initialize New Controllers ---
    _phoneNumberController = TextEditingController();
    _notesController = TextEditingController();
    _youtubeController = TextEditingController();
    _instagramController = TextEditingController();
    _facebookController = TextEditingController();
    _snapchatController = TextEditingController();
    _tiktokController = TextEditingController();
    // --- End Initialize New Controllers ---

    _localContact = Contact(
      id: 0,
      firstName: '',
      lastName: '',
      frequency: ContactFrequency.never.value,
      birthday: null,
      lastContacted: null,
      // --- Initialize New Fields in Default Contact ---
      phoneNumber: null,
      emails: [], // Initialize with empty list
      notes: null,
      youtubeUrl: null,
      instagramHandle: null,
      facebookUrl: null,
      snapchatHandle: null,
      tikTokHandle: null,
      // --- End Initialize New Fields ---
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final contactId = ModalRoute.of(context)!.settings.arguments as int?;
      if (contactId != null && contactId != 0) {
        context
            .read<ContactDetailsBloc>()
            .add(ContactDetailsEvent.loadContact(contactId: contactId));
      } else {
        // Existing logic for NEW contact
        String fetchedDefaultFrequency = ContactFrequency.never.value;
        try {
          final settingsRepo = context.read<UserSettingsRepository>();
          final settingsList = await settingsRepo.getAll();
          if (settingsList.isNotEmpty) {
            fetchedDefaultFrequency = settingsList.first.defaultFrequency;
          }
        } catch (e) {
          contactDetailScreenLogger.e("Error fetching default frequency: $e");
        }
        if (!mounted) return;
        setState(() {
          _isEditMode = true;
          _hasUnsavedChanges = true; // New contact starts with changes needed
          _localContact = _localContact.copyWith(
            frequency: fetchedDefaultFrequency,
            emails: [], // Ensure emails is an empty list for new contact
          );
          _updateControllersFromLocalContact(); // Update controllers for new contact defaults
          _updateEmailControllers(); // Ensure email controllers are synced
          _initialized = true;
        });
        context.read<ContactDetailsBloc>().add(
            ContactDetailsEvent.updateContactLocally(contact: _localContact));
      }
    });
  }

  // Helper to update all controllers from _localContact
  void _updateControllersFromLocalContact() {
    _firstNameController.text = _localContact.firstName;
    _lastNameController.text = _localContact.lastName;
    _phoneNumberController.text = _localContact.phoneNumber ?? '';
    _notesController.text = _localContact.notes ?? '';
    _youtubeController.text = _localContact.youtubeUrl ?? '';
    _instagramController.text = _localContact.instagramHandle ?? '';
    _facebookController.text = _localContact.facebookUrl ?? '';
    _snapchatController.text = _localContact.snapchatHandle ?? '';
    _tiktokController.text = _localContact.tikTokHandle ?? '';
    _updateEmailControllers(); // Update email controllers specifically
  }

  // Helper to sync _emailControllers with _localContact.emails
  void _updateEmailControllers() {
    // Dispose old controllers
    for (var controller in _emailControllers) {
      controller.dispose();
    }
    _emailControllers.clear();
    // Create new controllers based on current emails
    if (_localContact.emails != null) {
      for (String email in _localContact.emails!) {
        _emailControllers.add(TextEditingController(text: email));
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    // --- Dispose New Controllers ---
    _phoneNumberController.dispose();
    _notesController.dispose();
    _youtubeController.dispose();
    _instagramController.dispose();
    _facebookController.dispose();
    _snapchatController.dispose();
    _tiktokController.dispose();
    // Dispose email controllers
    for (var controller in _emailControllers) {
      controller.dispose();
    }
    // --- End Dispose New Controllers ---
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackButtonPressed(context),
      child: Scaffold(
        appBar: AppBar(
          // AppBar logic remains largely the same
          title: BlocBuilder<ContactDetailsBloc, ContactDetailsState>(
            builder: (context, state) {
              return Text(state.maybeMap(
                loaded: (loadedState) => _isEditMode
                    ? 'Edit Contact'
                    : '${loadedState.contact.firstName} ${loadedState.contact.lastName}',
                orElse: () => _isEditMode ? 'Add Contact' : 'Contact Details',
              ));
            },
          ),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _onBackButtonPressed(context)),
          actions: [
            IconButton(
              // HELP
              icon: const Icon(Icons.help_outline),
              tooltip: 'Help',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const HelpScreen(initialSection: HelpSection.details),
                    ));
              },
            ),
            IconButton(
              // DELETE
              icon: const Icon(Icons.delete),
              tooltip: 'Delete Contact',
              onPressed: (_localContact.id != null && _localContact.id != 0)
                  ? () => _onDeleteButtonPressed(context)
                  : null,
            ),
            BlocBuilder<ContactDetailsBloc, ContactDetailsState>(// EDIT/SAVE
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
              final bool canSaveChanges = canEditOrSave &&
                  !isDisabledByState &&
                  _isEditMode &&
                  _hasUnsavedChanges;
              final bool canEnterEdit =
                  canEditOrSave && !isDisabledByState && !_isEditMode;

              return IconButton(
                icon: Icon(_isEditMode ? Icons.save : Icons.edit),
                tooltip: _isEditMode ? 'Save Changes' : 'Edit Contact',
                onPressed: _isEditMode
                    ? (canSaveChanges
                        ? () => _onSaveButtonPressed(context)
                        : null)
                    : (canEnterEdit
                        ? () {
                            state.mapOrNull(loaded: (loadedState) {
                              setState(() {
                                _isEditMode = true;
                                // Load state into local contact and update controllers
                                _localContact = loadedState.contact;
                                _updateControllersFromLocalContact();
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
            state.mapOrNull(loaded: (loadedState) {
              if (!_isEditMode ||
                  (loadedState.contact.id != _localContact.id)) {
                // Update local state and controllers ONLY if not editing
                // or if the loaded contact is different from the one being edited
                setState(() {
                  _localContact = loadedState.contact;
                  _updateControllersFromLocalContact(); // Use helper
                  _hasUnsavedChanges = false; // Reset changes flag on load
                });
              }
              if (!_initialized) {
                setState(() {
                  _initialized = true;
                });
              }
            }, error: (errorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: ${errorState.message}")));
              contactDetailScreenLogger.e(errorState.message);
            }, cleared: (_) {
              // Handle state clearing if necessary, e.g., when adding new contact
              // This might already be handled in initState/addPostFrameCallback
            });
          },
          builder: (context, state) {
            return state.maybeMap(
                loaded: (loadedState) =>
                    _buildForm(), // Use helper, no arg needed
                initial: (_) =>
                    const Center(child: CircularProgressIndicator()),
                loading: (_) =>
                    const Center(child: CircularProgressIndicator()),
                cleared: (_) => _isEditMode
                    ? _buildForm()
                    : const Center(
                        child: Text(
                            'Enter new contact details')), // Show form if cleared for new contact
                error: (errorState) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Error: ${errorState.message}",
                              style: const TextStyle(color: Colors.red)),
                          const SizedBox(height: 20),
                          if (_initialized) // Show last known state if initialized
                            Expanded(
                                child:
                                    SingleChildScrollView(child: _buildForm()))
                          else
                            const Text("Could not load contact details."),
                        ],
                      ),
                    ),
                orElse: () {
                  // Handle the initial state for a new contact
                  if (_isEditMode && _localContact.id == 0) {
                    return _buildForm();
                  }
                  return const Center(child: CircularProgressIndicator());
                });
          },
        ),
        bottomNavigationBar: BottomAppBar(
          // Bottom Bar remains the same
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

  // Updated _buildForm - No longer takes contact argument, uses _localContact
  Widget _buildForm() {
    // --- Helper for Edit Mode Sections ---
    Widget buildEditSectionHeader(String title) {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
        child: Text(title, style: Theme.of(context).textTheme.titleMedium),
      );
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        // Ensure content is scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Display Section (Only visible when NOT in Edit Mode) ---
            if (!_isEditMode) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  '${_localContact.firstName} ${_localContact.lastName}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              // Display Existing Fields
              _buildDisplayRow(
                  Icons.cake_outlined,
                  'Birthday:',
                  _localContact.birthday == null
                      ? 'Not set'
                      : DateFormat.yMd().format(_localContact.birthday!)),
              _buildDisplayRow(
                  Icons.celebration_outlined,
                  'Anniversary:',
                  _localContact.anniversary == null
                      ? 'Not set'
                      : DateFormat.yMd().format(_localContact.anniversary!)),
              _buildDisplayRow(Icons.access_time, 'Last Contacted:',
                  formatLastContacted(_localContact.lastContacted)),
              _buildDisplayRow(
                  Icons.repeat, 'Frequency:', _localContact.frequency),
              _buildDisplayRow(
                  Icons.next_plan_outlined,
                  'Next Due:',
                  calculateNextDueDateDisplay(
                      _localContact.lastContacted, _localContact.frequency)),
              const Divider(height: 24.0),
              // --- Display New Fields ---
              _buildDisplayRow(Icons.phone_outlined, 'Phone:',
                  _localContact.phoneNumber ?? 'Not set'),
              _buildDisplayRow(
                  Icons.email_outlined,
                  'Emails:',
                  (_localContact.emails?.isEmpty ?? true)
                      ? 'Not set'
                      : _localContact.emails!.join(', ')),
              _buildDisplayRow(Icons.notes_outlined, 'Notes:',
                  _localContact.notes ?? 'Not set'),
              const Divider(height: 24.0),
              _buildDisplayRow(Icons.play_circle_outline, 'YouTube:',
                  _localContact.youtubeUrl ?? 'Not set'),
              _buildDisplayRow(Icons.photo_camera_outlined, 'Instagram:',
                  _localContact.instagramHandle ?? 'Not set'), // Example icons
              _buildDisplayRow(Icons.facebook_outlined, 'Facebook:',
                  _localContact.facebookUrl ?? 'Not set'),
              _buildDisplayRow(Icons.snapchat_outlined, 'Snapchat:',
                  _localContact.snapchatHandle ?? 'Not set'),
              _buildDisplayRow(Icons.music_note_outlined, 'TikTok:',
                  _localContact.tikTokHandle ?? 'Not set'), // Example icons
              // --- End Display New Fields ---
              const SizedBox(height: 16.0),
            ],
            // --- End Display Section ---

            // --- Edit Section (Only visible IN Edit Mode) ---
            if (_isEditMode) ...[
              buildEditSectionHeader('Basic Info'),
              // First Name
              TextFormField(
                controller: _firstNameController,
                enabled: _isEditMode,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                    labelText: 'First Name', border: OutlineInputBorder()),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter a first name'
                    : null,
                onChanged: (value) => setState(() {
                  _localContact = _localContact.copyWith(firstName: value);
                  _hasUnsavedChanges = true;
                }),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16.0),
              // Last Name
              TextFormField(
                controller: _lastNameController,
                enabled: _isEditMode,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                    labelText: 'Last Name', border: OutlineInputBorder()),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter a last name'
                    : null,
                onChanged: (value) => setState(() {
                  _localContact = _localContact.copyWith(lastName: value);
                  _hasUnsavedChanges = true;
                }),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16.0),
              // Phone Number (with mask)
              TextFormField(
                controller: _phoneNumberController,
                enabled: _isEditMode,
                keyboardType: TextInputType.phone,
                // Apply the input formatter
                inputFormatters: [phoneMaskFormatter], // <-- Add formatter here
                decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    hintText: '(123) 456-7890', // Add hint text
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone)),
                onChanged: (value) => setState(() {
                  // Store the UNMASKED value (just digits) in your model
                  _localContact = _localContact.copyWith(
                      phoneNumber: phoneMaskFormatter.getUnmaskedText());
                  _hasUnsavedChanges = true;
                }),
                textInputAction: TextInputAction.next,
              ),

              buildEditSectionHeader('Contact Schedule'),
              // Frequency Dropdown
              DropdownButtonFormField<String>(
                value: _localContact.frequency.isNotEmpty
                    ? _localContact.frequency
                    : ContactFrequency.defaultValue, // Ensure value exists
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _localContact =
                          _localContact.copyWith(frequency: newValue);
                      _hasUnsavedChanges = true;
                    });
                  }
                },
                items: ContactFrequency.values
                    .map((frequency) => DropdownMenuItem<String>(
                        value: frequency.value, child: Text(frequency.name)))
                    .toList(),
                decoration: const InputDecoration(
                    labelText: 'Frequency', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16.0),
              // Birthday Picker
              _buildDatePickerButton(
                  'Birthday',
                  _localContact.birthday,
                  (picked) => setState(() {
                        _localContact =
                            _localContact.copyWith(birthday: picked);
                        _hasUnsavedChanges = true;
                      })),
              // Anniversary Picker
              _buildDatePickerButton(
                  'Anniversary',
                  _localContact.anniversary,
                  (picked) => setState(() {
                        _localContact =
                            _localContact.copyWith(anniversary: picked);
                        _hasUnsavedChanges = true;
                      })),

              buildEditSectionHeader('Emails'),
              // Email List Editor
              _buildEmailListEditor(),
              const SizedBox(height: 16.0),

              buildEditSectionHeader('Social Media'),
              // Social Media Fields
              _buildSocialMediaInput(
                  Icons.play_circle_outline,
                  'YouTube URL',
                  _youtubeController,
                  (v) => _localContact = _localContact.copyWith(youtubeUrl: v)),
              _buildSocialMediaInput(
                  Icons.photo_camera_outlined,
                  'Instagram Handle',
                  _instagramController,
                  (v) => _localContact =
                      _localContact.copyWith(instagramHandle: v)),
              _buildSocialMediaInput(
                  Icons.facebook_outlined,
                  'Facebook URL',
                  _facebookController,
                  (v) =>
                      _localContact = _localContact.copyWith(facebookUrl: v)),
              _buildSocialMediaInput(
                  Icons.snapchat_outlined,
                  'Snapchat Handle',
                  _snapchatController,
                  (v) => _localContact =
                      _localContact.copyWith(snapchatHandle: v)),
              _buildSocialMediaInput(
                  Icons.music_note_outlined,
                  'TikTok Handle',
                  _tiktokController,
                  (v) =>
                      _localContact = _localContact.copyWith(tikTokHandle: v)),
              const SizedBox(height: 16.0),

              buildEditSectionHeader('Notes'),
              // Notes
              TextFormField(
                controller: _notesController,
                enabled: _isEditMode,
                decoration: const InputDecoration(
                    labelText: 'Notes',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true),
                maxLines: 4, // Allow multiple lines
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                onChanged: (value) => setState(() {
                  _localContact = _localContact.copyWith(
                      notes: value.isNotEmpty ? value : null);
                  _hasUnsavedChanges = true;
                }),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 20),
            ]
            // --- End Edit Section ---
          ],
        ),
      ),
    );
  }

  // Helper for Date Picker Buttons
  Widget _buildDatePickerButton(
      String label, DateTime? currentValue, Function(DateTime) onDatePicked) {
    return Row(
      children: [
        Expanded(
            child: Text('$label:',
                style: const TextStyle(fontWeight: FontWeight.bold))),
        ElevatedButton(
          onPressed: !_isEditMode
              ? null
              : () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: currentValue ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (!mounted) return;
                  if (picked != null && picked != currentValue) {
                    onDatePicked(
                        picked); // Call the callback with the picked date
                  }
                },
          child: Text(currentValue == null
              ? 'Select Date'
              : DateFormat.yMd().format(currentValue)),
        ),
      ],
    );
  }

  // Helper for Social Media Input Fields
  Widget _buildSocialMediaInput(IconData icon, String label,
      TextEditingController controller, Function(String?) onUpdate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        enabled: _isEditMode,
        decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            prefixIcon: Icon(icon)),
        keyboardType:
            label.contains('URL') ? TextInputType.url : TextInputType.text,
        onChanged: (value) => setState(() {
          onUpdate(value.isNotEmpty ? value : null);
          _hasUnsavedChanges = true;
        }),
        textInputAction: TextInputAction.next,
      ),
    );
  }

  // Helper for Email List Editor UI
  Widget _buildEmailListEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Existing email fields
        ..._emailControllers.asMap().entries.map((entry) {
          int index = entry.key;
          TextEditingController controller = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    enabled: _isEditMode,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: 'Email ${index + 1}',
                        border: const OutlineInputBorder()),
                    validator: (value) {
                      // Basic email format check (optional)
                      if (value != null &&
                          value.isNotEmpty &&
                          !value.contains('@')) {
                        return 'Invalid email format';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      // Update immutably
                      if (_localContact.emails != null &&
                          index < _localContact.emails!.length) {
                        // 1. Create a *mutable* copy of the current emails list
                        //    Using List.from() creates a growable list suitable for modification.
                        final List<String> mutableEmails =
                            List<String>.from(_localContact.emails!);

                        // 2. Update the value at the specific index in the *mutable copy*
                        mutableEmails[index] = value;

                        // 3. Update _localContact using copyWith, providing the modified list
                        setState(() {
                          _localContact =
                              _localContact.copyWith(emails: mutableEmails);
                          _hasUnsavedChanges = true;
                        });
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline,
                      color: Colors.red),
                  tooltip: 'Remove Email',
                  onPressed: () {
                    // Check if emails list exists and index is valid
                    if (_localContact.emails != null &&
                        index >= 0 &&
                        index < _localContact.emails!.length) {
                      setState(() {
                        // 1. Dispose the controller that's being removed
                        //    (Make sure 'controller' is accessible here - it should be from the .map entry)
                        _emailControllers[index]
                            .dispose(); // Dispose before removing from list

                        // 2. Remove the controller from the mutable UI list
                        _emailControllers.removeAt(index);

                        // 3. Create a NEW list excluding the item at the specified index
                        //    Create a mutable copy first
                        final List<String> mutableEmails =
                            List<String>.from(_localContact.emails!);
                        //    Remove the item from the mutable copy
                        mutableEmails.removeAt(index);

                        // 4. Update _localContact IMMUTABLY using copyWith the new list
                        _localContact =
                            _localContact.copyWith(emails: mutableEmails);

                        // 5. Mark changes
                        _hasUnsavedChanges = true;
                      });
                    }
                  },
                )
              ],
            ),
          );
        }).toList(),
        // Add Email Button
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Email'),
            onPressed: () {
              setState(() {
                // 1. Create the new controller (this part is fine)
                _emailControllers.add(TextEditingController());

                // 2. Create the *new* list of emails
                // Get the current list (or an empty list if null)
                final List<String> currentEmails = _localContact.emails ?? [];
                // Create a new list by adding an empty string to the current ones
                final List<String> newEmails = [
                  ...currentEmails,
                  ''
                ]; // Use spread operator

                // 3. Update _localContact *immutably* using copyWith
                _localContact = _localContact.copyWith(emails: newEmails);

                // 4. Mark changes (this part is fine)
                _hasUnsavedChanges = true;
              });
            },
          ),
        ),
      ],
    );
  }

  // Helper to build display rows consistently
  Widget _buildDisplayRow(IconData icon, String label, String value) {
    // Wrap value in Expanded to handle long text like notes or multiple emails
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 6.0), // Increased vertical padding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align items to the top
        children: [
          Icon(icon, size: 20.0, color: Colors.grey[700]),
          const SizedBox(width: 12.0),
          SizedBox(
              width: 110,
              child: Text('$label ',
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)), // Value takes remaining space and wraps
        ],
      ),
    );
  }

  // --- Action Handlers (Mostly unchanged, but ensure _localContact is up-to-date) ---

  Future<bool> _onBackButtonPressed(BuildContext context) async {
    // This logic should still work as it relies on _hasUnsavedChanges
    if (_isEditMode && _hasUnsavedChanges) {
      final bool discard = await showDialog<bool>(
              context: context,
              builder: (context) =>
                  AlertDialog(/* ... existing dialog ... */)) ??
          false;

      if (discard) {
        if (mounted) {
          Navigator.of(context).pop();
        }
        return Future.value(false); // Allow pop if discarding
      } else {
        return Future.value(false); // Prevent pop if cancel
      }
    } else {
      if (mounted) {
        Navigator.of(context).pop();
      }
      return Future.value(false); // Allow pop if no changes or not editing
    }
  }

  void _onSaveButtonPressed(BuildContext context) {
    // First, ensure email list in _localContact is synced with controllers
    if (_isEditMode && _localContact.emails != null) {
      for (int i = 0; i < _emailControllers.length; i++) {
        if (i < _localContact.emails!.length) {
          _localContact.emails![i] = _emailControllers[i].text;
        }
      }
      // Remove any empty email entries before saving
      _localContact.emails!.removeWhere((email) => email.trim().isEmpty);
    }

    if (_formKey.currentState!.validate()) {
      // Use the _localContact which should have been updated by onChanged handlers
      Contact contactToSave = _localContact;
      bool isExistingContact =
          contactToSave.id != null && contactToSave.id != 0;

      // Dispatch event
      if (!isExistingContact) {
        context
            .read<ContactDetailsBloc>()
            .add(ContactDetailsEvent.addContact(contact: contactToSave));
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('New contact saved')));
        }
      } else {
        context
            .read<ContactDetailsBloc>()
            .add(ContactDetailsEvent.saveContact(contact: contactToSave));
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Changes saved')));
        }
      }

      if (mounted) {
        setState(() {
          _hasUnsavedChanges = false;
          _isEditMode = false;
        });
        context
            .read<ContactListBloc>()
            .add(const ContactListEvent.loadContacts());
        Navigator.of(context).pop();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please correct the errors before saving.')),
        );
      }
    }
  }

  void _onDeleteButtonPressed(BuildContext context) {
    // Existing logic should be fine
    if (_localContact.id == null || _localContact.id == 0) {
      /* ... */ return;
    }
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          /* ... existing dialog ... */
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel')),
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

  void _onContactedButtonPressed() {
    // Existing logic should be fine
    if (_localContact.id == null || _localContact.id == 0) {
      /* ... */ return;
    }
    final now = DateTime.now();
    // IMPORTANT: Use copyWith on the most up-to-date _localContact
    final updatedContact = _localContact.copyWith(lastContacted: now);

    // Update local state *immediately* for responsiveness
    setState(() {
      _localContact = updatedContact;
      // If marking contacted clears unsaved changes depends on desired UX
      // _hasUnsavedChanges = false; // Optionally reset this
    });

    // Save the update via BLoC
    context
        .read<ContactDetailsBloc>()
        .add(ContactDetailsEvent.saveContact(contact: updatedContact));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Marked as contacted: ${DateFormat.yMd().format(now)}')));
      context
          .read<ContactListBloc>()
          .add(const ContactListEvent.loadContacts());
    }
  }
} // End of _ContactDetailsScreenState
