// lib/screens/contact_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:recall/blocs/contact_details/contact_details_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:intl/intl.dart';
import 'package:recall/utils/logger.dart'; // Adjust path if needed
import 'package:recall/models/contact_frequency.dart';
import 'package:recall/repositories/usersettings_repository.dart';
import 'package:recall/services/notification_helper.dart';
import 'package:recall/screens/help_screen.dart';
import '../utils/last_contacted_utils.dart';
import 'package:url_launcher/url_launcher.dart';

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
  late TextEditingController _nicknameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _notesController;
  late TextEditingController _youtubeController;
  late TextEditingController _instagramController;
  late TextEditingController _facebookController;
  late TextEditingController _snapchatController;
  late TextEditingController _xHandleController;
  late TextEditingController _linkedInController;
  final List<TextEditingController> _emailControllers = [];

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
    _nicknameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _notesController = TextEditingController();
    _youtubeController = TextEditingController();
    _instagramController = TextEditingController();
    _facebookController = TextEditingController();
    _snapchatController = TextEditingController();
    _xHandleController = TextEditingController();
    _linkedInController = TextEditingController();

    _localContact = Contact(
      id: 0,
      firstName: '',
      lastName: '',
      nickname: null,
      frequency: ContactFrequency.never.value,
      birthday: null,
      lastContacted: null,
      phoneNumber: null,
      emails: [], // Initialize with empty list
      notes: null,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final contactId = ModalRoute.of(context)!.settings.arguments as int?;
      if (contactId != null && contactId != 0) {
        context
            .read<ContactDetailsBloc>()
            .add(LoadContactEvent(contactId: contactId));
      } else {
        // logic for NEW contact
        String fetchedDefaultFrequency = ContactFrequency.never.value;
        try {
          final settingsRepo = context.read<UserSettingsRepository>();
          final settingsList = await settingsRepo.getAll();
          if (settingsList.isNotEmpty) {
            fetchedDefaultFrequency = settingsList.first.defaultFrequency;
          }
        } catch (e) {
          logger.e("Error fetching default frequency: $e");
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
            UpdateContactLocallyEvent(contact: _localContact));
      }
    });
  }

  // Helper to update all controllers from _localContact
  void _updateControllersFromLocalContact() {
    _firstNameController.text = _localContact.firstName;
    _lastNameController.text = _localContact.lastName;
    _nicknameController.text = _localContact.nickname ?? '';
    _phoneNumberController.text = _localContact.phoneNumber ?? '';
    _notesController.text = _localContact.notes ?? '';
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
    _nicknameController.dispose();
    _phoneNumberController.dispose();
    _notesController.dispose();
    _youtubeController.dispose();
    _instagramController.dispose();
    _facebookController.dispose();
    _snapchatController.dispose();
    _xHandleController.dispose();
    _linkedInController.dispose();
    for (var controller in _emailControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine title dynamically using standard instance checks instead of mapOrNull
    final appBarTitle = BlocBuilder<ContactDetailsBloc, ContactDetailsState>(
      builder: (context, state) {
        // Decide title based on nickname presence
        String nameToShow = '';
        
        if (state is LoadedContactDetailsState) {
          nameToShow = (state.contact.nickname != null &&
                  state.contact.nickname!.isNotEmpty)
              ? state.contact.nickname! // Use nickname if available
              : '${state.contact.firstName} ${state.contact.lastName}';
        } else if (state is ClearedContactDetailsState) {
          nameToShow = 'Add Contact';
        }
        
        // If name is still empty (e.g., initial state before load or clear), use defaults
        if (nameToShow.isEmpty) {
          nameToShow = _isEditMode ? 'Add/Edit Contact' : 'Contact Details';
        }

        return Text(_isEditMode ? 'Edit: $nameToShow' : nameToShow);
      },
    );

    // Determine if popping should be prevented *right now*
    // Prevent pop if we are in edit mode AND have unsaved changes
    final bool preventPop = _isEditMode && _hasUnsavedChanges;

    return PopScope(
      canPop: !preventPop,
      child: Scaffold(
        appBar: AppBar(
          title: appBarTitle, // Use dynamic title
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _handleBackNavigation()),
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
            // EDIT/SAVE
            BlocBuilder<ContactDetailsBloc, ContactDetailsState>(
                builder: (context, state) {
              final bool isLoaded = state is LoadedContactDetailsState;
              final bool isNewContactMode = 
                  (state is ClearedContactDetailsState && _isEditMode) ||
                  (_localContact.id == 0 && _isEditMode);
              final bool canEditOrSave = isLoaded || isNewContactMode;
              final bool isDisabledByState = 
                  state is LoadingContactDetailsState || 
                  state is InitialContactDetailsState;
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
                            if (state is LoadedContactDetailsState) {
                              setState(() {
                                _isEditMode = true;
                                // Load state into local contact and update controllers
                                _localContact = state.contact;
                                _updateControllersFromLocalContact();
                              });
                            }
                          }
                        : null),
              );
            }),
          ],
        ),
        body: BlocConsumer<ContactDetailsBloc, ContactDetailsState>(
          listener: (context, state) {
            if (state is LoadedContactDetailsState) {
              if (!_isEditMode ||
                  (state.contact.id != _localContact.id)) {
                // Update local state and controllers ONLY if not editing
                // or if the loaded contact is different from the one being edited
                setState(() {
                  _localContact = state.contact;
                  _updateControllersFromLocalContact(); // Use helper
                  _hasUnsavedChanges = false; // Reset changes flag on load
                });
              }
              if (!_initialized) {
                setState(() {
                  _initialized = true;
                });
              }
            } else if (state is ErrorContactDetailsState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: ${state.message}")));
              logger.e(state.message);
            } else if (state is ClearedContactDetailsState) {
              // When cleared, ensure local state reflects a new contact if in edit mode
              if (_isEditMode) {
                setState(() {
                  // Reset _localContact to default values
                  _localContact = Contact(
                    id: 0,
                    firstName: '',
                    lastName: '',
                    nickname: null,
                    frequency: ContactFrequency.never.value,
                    birthday: null,
                    lastContacted: null,
                    phoneNumber: null,
                    emails: [], // Initialize with empty list
                    notes: null,
                  );
                  _updateControllersFromLocalContact(); // Update controllers to blank
                  _hasUnsavedChanges = true; // New contact needs saving
                  _initialized = true; // Mark as initialized
                });
              }
            }
          },
          builder: (context, state) {
            // Delegate building the main content based on state
            if (state is LoadedContactDetailsState) {
              return _buildLoadedBody();
            } else if (state is InitialContactDetailsState || 
                      state is LoadingContactDetailsState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ClearedContactDetailsState) {
              return _isEditMode
                ? _buildLoadedBody() // Show form for new contact
                : const Center(child: Text('Enter new contact details'));
            } else if (state is ErrorContactDetailsState) {
              return _buildErrorBody(state.message);
            } else {
              // Fallback logic, check if we are setting up a new contact explicitly
              if (_isEditMode && _localContact.id == 0) {
                return _buildLoadedBody(); // Show form for new contact
              }
              return const Center(child: CircularProgressIndicator());
            }
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

  // --- Widget Builder for Error State ---
  Widget _buildErrorBody(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Error: $errorMessage",
              style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 20),
          if (_initialized) // Show last known state if initialized
            Expanded(child: SingleChildScrollView(child: _buildLoadedBody()))
          else
            const Text("Could not load contact details."),
        ],
      ),
    );
  }

  // --- Widget Builder for Loaded/Editing State ---
  Widget _buildLoadedBody() {
    // This replaces the old _buildForm method's core logic
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        // Ensures content scrolls if needed
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (!_isEditMode)
              _buildViewModeSection() // Delegate to view mode builder
            else
              _buildEditModeSection() // Delegate to edit mode builder
          ],
        ),
      ),
    );
  }

  // --- VIEW MODE Section Builder ---
  Widget _buildViewModeSection() {
    // --- Apply phone mask for display ---
    String formattedPhoneNumber = 'Not set';
    String unmaskedPhoneNumber = ''; // Store unmasked for actions
    if (_localContact.phoneNumber != null &&
        _localContact.phoneNumber!.isNotEmpty) {
      unmaskedPhoneNumber = _localContact.phoneNumber!;
      try {
        formattedPhoneNumber = phoneMaskFormatter.maskText(unmaskedPhoneNumber);
      } catch (e) {
        formattedPhoneNumber = unmaskedPhoneNumber; // Fallback
        logger.e("Error masking phone for display: $e");
      }
    }
    // Determine name display based on nickname
    final String nameDisplay =
        (_localContact.nickname != null && _localContact.nickname!.isNotEmpty)
            ? _localContact.nickname!
            : '${_localContact.firstName} ${_localContact.lastName}';
    final String fullNameDisplay =
        '${_localContact.firstName} ${_localContact.lastName}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          // Primary Name Display (Nickname or Full Name)
          padding: const EdgeInsets.only(bottom: 8.0), // Reduced bottom padding
          child: Text(
            nameDisplay,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        // Conditionally display Full Name if Nickname was used above
        if (_localContact.nickname != null &&
            _localContact.nickname!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
                bottom: 20.0), // Add padding below full name
            child: Text(
              '($fullNameDisplay)', // Show full name in parentheses
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.grey[600]),
            ),
          )
        else // Add padding if no nickname was shown
          const SizedBox(height: 24.0), // Original padding if no nickname

        // Basic Date/Time Info
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
        _buildDisplayRow(Icons.repeat, 'Frequency:', _localContact.frequency),
        _buildDisplayRow(
            Icons.next_plan_outlined,
            'Next Due:',
            calculateNextDueDateDisplay(
                _localContact.lastContacted, _localContact.frequency)),

        const Divider(height: 24.0),

        // Actionable Rows (Phone/Email)
        _buildActionableDisplayRow(
          icon: Icons.phone_outlined,
          label: 'Phone:',
          value: formattedPhoneNumber,
          onTap: unmaskedPhoneNumber.isNotEmpty
              ? () => _showPhoneActions(unmaskedPhoneNumber)
              : null,
          actions: unmaskedPhoneNumber.isNotEmpty
              ? [
                  IconButton(
                    icon: const Icon(Icons.message),
                    tooltip: 'Send Message',
                    onPressed: () => _launchUniversalLink(Uri.parse(
                        'sms:${_sanitizePhoneNumber(unmaskedPhoneNumber)}')),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                  IconButton(
                    icon: const Icon(Icons.call),
                    tooltip: 'Call',
                    onPressed: () => _launchUniversalLink(Uri.parse(
                        'tel:${_sanitizePhoneNumber(unmaskedPhoneNumber)}')),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                ]
              : [],
        ),
        Padding(
            // Email List Section
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.email_outlined, size: 20.0, color: Colors.grey[700]),
              const SizedBox(width: 12.0),
              const SizedBox(
                  width: 110,
                  child: Text('Emails:',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  child: _buildEmailDisplayList(
                      _localContact.emails)) // Use helper
            ])),

        // Notes
        _buildDisplayRow(
            Icons.notes_outlined, 'Notes:', _localContact.notes ?? 'Not set'),

        const Divider(height: 24.0),

        const SizedBox(height: 16.0),
      ],
    );
  }

  // --- EDIT MODE Section Builder ---
  Widget _buildEditModeSection() {
    // Helper for section headers (can be local to this method)
    Widget buildEditSectionHeader(String title) {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
        child: Text(title, style: Theme.of(context).textTheme.titleMedium),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildEditSectionHeader('Basic Info'),
        _buildEditBasicInfo(), // Delegate

        buildEditSectionHeader('Contact Schedule'),
        _buildEditSchedule(), // Delegate

        buildEditSectionHeader('Emails'),
        _buildEmailListEditor(), // Keep existing complex editor logic here

        buildEditSectionHeader('Notes'),
        _buildEditNotes(), // Delegate

        const SizedBox(height: 20), // Spacer at bottom
      ],
    );
  }

  // --- Smaller builders for Edit Mode sections ---
  Widget _buildEditBasicInfo() {
    return Column(
      children: [
        TextFormField(
          // First Name
          controller: _firstNameController,
          enabled: _isEditMode, // Use _isEditMode from state
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
        TextFormField(
          // Last Name
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
        TextFormField(
          // Nickname
          controller: _nicknameController,
          enabled: _isEditMode,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
              labelText: 'Nickname (Optional)', border: OutlineInputBorder()),
          // No validator needed for optional field
          onChanged: (value) => setState(() {
            _localContact = _localContact.copyWith(
                nickname: value.isNotEmpty ? value : null);
            _hasUnsavedChanges = true;
          }),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          // Phone Number
          controller: _phoneNumberController,
          enabled: _isEditMode,
          keyboardType: TextInputType.phone,
          inputFormatters: [phoneMaskFormatter], // Use formatter from state
          decoration: const InputDecoration(
              labelText: 'Phone Number',
              hintText: '(123) 456-7890',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone)),
          onChanged: (value) => setState(() {
            _localContact = _localContact.copyWith(
                phoneNumber: phoneMaskFormatter.getUnmaskedText());
            _hasUnsavedChanges = true;
          }),
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }

  Widget _buildEditSchedule() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          // Frequency
          // Ensure value exists in items, use defaultValue if not
          value: ContactFrequency.values
                  .any((f) => f.value == _localContact.frequency)
              ? _localContact.frequency
              : ContactFrequency.defaultValue,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _localContact = _localContact.copyWith(frequency: newValue);
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
        _buildDatePickerButton(
            'Birthday',
            _localContact.birthday,
            (picked) => setState(() {
                  _localContact = _localContact.copyWith(birthday: picked);
                  _hasUnsavedChanges = true;
                })),
        _buildDatePickerButton(
            'Anniversary',
            _localContact.anniversary,
            (picked) => setState(() {
                  _localContact = _localContact.copyWith(anniversary: picked);
                  _hasUnsavedChanges = true;
                })),
      ],
    );
  }

  Widget _buildEditNotes() {
    return TextFormField(
      controller: _notesController,
      enabled: _isEditMode,
      decoration: const InputDecoration(
          labelText: 'Notes',
          border: OutlineInputBorder(),
          alignLabelWithHint: true),
      maxLines: 4,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.multiline,
      onChanged: (value) => setState(() {
        _localContact =
            _localContact.copyWith(notes: value.isNotEmpty ? value : null);
        _hasUnsavedChanges = true;
      }),
      textInputAction: TextInputAction.done,
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
        }),
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

  Future<void> _handleBackNavigation() async {
    if (_isEditMode && _hasUnsavedChanges) {
      final bool? discard = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Discard Changes?'),
          content: const Text(
              'You have unsaved changes. Are you sure you want to discard them?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context)
                  .pop(false), // Return false - Don't discard
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                  foregroundColor: Colors.red), // Return true - Discard
              child: const Text('Discard'),
            ),
          ],
        ),
      ); // Default to null if dialog dismissed

      // IMPORTANT: Check if the widget is still mounted after the await
      if (!mounted) return;

      // If user chose to discard (discard == true), then pop the screen
      if (discard == true) {
        Navigator.of(context).pop();
      }
      // If user chose Cancel (discard == false or null), do nothing (stay on screen)
    } else {
      // If not editing or no unsaved changes, just pop the screen
      // Check mounted state before popping is good practice, though less critical here
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _onSaveButtonPressed(BuildContext context) {
    Contact contactToSave =
        _localContact; // Start with the current local contact

    // --- Create a mutable copy of emails to work with ---
    List<String> updatedEmails = []; // Default to empty list
    if (_localContact.emails != null) {
      // Create a mutable copy from the existing list
      updatedEmails = List<String>.from(_localContact.emails!);
    }

    // --- Sync controllers to the mutable list ---
    if (_isEditMode) {
      // Make sure the updatedEmails list has the same length as controllers
      // (This handles adding new emails that might not be in _localContact.emails yet)
      while (updatedEmails.length < _emailControllers.length) {
        updatedEmails.add(''); // Add placeholders if needed
      }
      // Trim excess if controllers were removed but state update lagged (less likely)
      if (updatedEmails.length > _emailControllers.length) {
        updatedEmails = updatedEmails.sublist(0, _emailControllers.length);
      }

      // Sync text from controllers
      for (int i = 0; i < _emailControllers.length; i++) {
        updatedEmails[i] = _emailControllers[i].text;
      }

      // --- Remove empty emails from the mutable list ---
      updatedEmails.removeWhere((email) => email.trim().isEmpty);

      // --- Update the contactToSave immutably with the final email list ---
      contactToSave = contactToSave.copyWith(emails: updatedEmails);
    }
    // --- End Email List Processing ---

    if (_formKey.currentState!.validate()) {
      // Now use the potentially updated contactToSave
      bool isExistingContact =
          contactToSave.id != null && contactToSave.id != 0;

      // Dispatch event
      if (!isExistingContact) {
        context.read<ContactDetailsBloc>().add(AddContactEvent(
            contact: contactToSave)); // Use contactToSave
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('New contact saved')));
        }
      } else {
        context.read<ContactDetailsBloc>().add(SaveContactEvent(
            contact: contactToSave)); // Use contactToSave
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Changes saved')));
        }
      }

      if (mounted) {
        setState(() {
          // Update _localContact AFTER saving if you want the UI to reflect the saved state immediately
          // If you pop right away, this might not be strictly necessary
          _localContact = contactToSave;
          _hasUnsavedChanges = false;
          _isEditMode = false;
        });
        context
            .read<ContactListBloc>()
            .add(const LoadContactsEvent());
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
          title: const Text('Delete Contact'),
          content: Text(
              'Are you sure you want to delete ${_localContact.firstName} ${_localContact.lastName}?\n\nThis action cannot be undone.'),
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
                      DeleteContactEvent(
                          contactId: contactIdToDelete));
                  context
                      .read<ContactListBloc>()
                      .add(const LoadContactsEvent());
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
        .add(SaveContactEvent(contact: updatedContact));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Marked as contacted: ${DateFormat.yMd().format(now)}')));
      context
          .read<ContactListBloc>()
          .add(const LoadContactsEvent());
    }
  }

  Future<void> _launchUniversalLink(Uri url) async {
    try {
      final bool canLaunch = await canLaunchUrl(url);
      if (!mounted) return; // Check if widget is still in the tree

      if (canLaunch) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
        logger.w('Could not launch $url');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching link: $e')),
      );
      logger.e('Error launching link: $e');
    }
  }

  // Add this helper method to clean phone numbers
  String _sanitizePhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    return phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
  }

  void _showPhoneActions(String unmaskedPhoneNumber) {
    if (unmaskedPhoneNumber.isEmpty) return;

    // Clean the phone number to remove any formatting characters
    String cleanPhoneNumber = _sanitizePhoneNumber(unmaskedPhoneNumber);

    // Use Uri.parse for proper scheme formatting
    final Uri telUri = Uri.parse('tel:$cleanPhoneNumber');
    final Uri smsUri = Uri.parse('sms:$cleanPhoneNumber');

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.call),
              title: const Text('Call'),
              onTap: () {
                Navigator.pop(context); // Close the sheet
                _launchUniversalLink(telUri);
              },
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Send Message'),
              onTap: () {
                Navigator.pop(context); // Close the sheet
                _launchUniversalLink(smsUri);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(context), // Close the sheet
            ),
          ],
        ),
      ),
    );
  }

  void _launchEmail(String emailAddress) {
    if (emailAddress.isEmpty) return;
    // Use Uri.parse for proper mailto formatting
    final Uri emailUri = Uri.parse('mailto:$emailAddress');
    _launchUniversalLink(emailUri);
  }

  // Helper to build display rows consistently, now with tap action and trailing icons
  Widget _buildActionableDisplayRow({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap, // Make the value clickable
    List<Widget> actions = const [], // Optional trailing action icons
  }) {
    Widget valueWidget = Text(value);

    // If onTap is provided, wrap the value Text in a GestureDetector/InkWell
    if (onTap != null && value != 'Not set') {
      // Only make it tappable if value exists
      valueWidget = InkWell(
        onTap: onTap,
        child: Text(
          value,
          style: TextStyle(
            // Add visual cue for tappable text
            color: Theme.of(context).colorScheme.primary,
            // decoration: TextDecoration.underline, // Optional underline
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align items to the top
        children: [
          Icon(icon, size: 20.0, color: Colors.grey[700]),
          const SizedBox(width: 12.0),
          SizedBox(
              width: 110, // Keep consistent label width
              child: Text('$label ',
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              child: valueWidget), // Use the potentially wrapped valueWidget
          // Add trailing action icons if provided
          if (actions.isNotEmpty) ...[
            const SizedBox(width: 8), // Spacing before icons
            Row(
              // Wrap icons in a Row
              mainAxisSize: MainAxisSize.min, // Don't take extra space
              children: actions,
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildEmailDisplayList(List<String>? emails) {
    if (emails == null || emails.isEmpty) {
      // Use same styling as _buildActionableDisplayRow for consistency
      return const Padding(
        padding:
            EdgeInsets.only(top: 6.0, bottom: 6.0), // Match vertical padding
        child: Text('Not set'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: emails.map((email) {
        if (email.trim().isEmpty) {
          return const SizedBox.shrink(); // Don't show empty entries
        }

        return Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 4.0), // Spacing between emails
          child: InkWell(
            onTap: () => _launchEmail(email),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    email,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      // decoration: TextDecoration.underline, // Optional underline
                    ),
                  ),
                ),
                // Optional: Add an icon button next to each email
                IconButton(
                  icon: const Icon(Icons.email_outlined),
                  tooltip: 'Send Email',
                  iconSize: 20, // Smaller icon
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  onPressed: () => _launchEmail(email),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
} // End of _ContactDetailsScreenState
