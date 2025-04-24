// lib/screens/contact_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:recall/blocs/contact_details/contact_details_bloc.dart';
import 'package:recall/blocs/contact_details/contact_details_state.dart';
import 'package:recall/blocs/contact_details/contact_details_event.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_event.dart';
import 'package:recall/models/contact.dart';
import 'package:intl/intl.dart';
import 'package:recall/utils/logger.dart'; // Adjust path if needed
import 'package:recall/models/contact_enums.dart';
import 'package:recall/repositories/usersettings_repository.dart';
import 'package:recall/services/notification_helper.dart';
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
      youtubeUrl: null,
      instagramHandle: null,
      facebookUrl: null,
      snapchatHandle: null,
      xHandle: null, // Added
      linkedInUrl: null, // Added
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final contactId = ModalRoute.of(context)!.settings.arguments as int?;
      if (contactId != null && contactId != 0) {
        context.read<ContactDetailsBloc>().add(LoadContact(contactId: contactId));
      } else {
        // --- Logic for NEW contact ---
        // Fetch default frequency first
        String fetchedDefaultFrequency = ContactFrequency.never.value;
        try {
          // Use read outside async gap if possible, or ensure mounted check
          if (!mounted) return;
          final settingsRepo = context.read<UserSettingsRepository>();
          final settingsList = await settingsRepo.getAll();
          if (settingsList.isNotEmpty) {
            fetchedDefaultFrequency = settingsList.first.defaultFrequency;
          }
        } catch (e) {
          logger.e("Error fetching default frequency: $e");
          // Handle error appropriately, maybe show a message
        }

        // Check mounted again after await
        if (!mounted) return;

        // Dispatch an event to prepare the BLoC for a new contact
        context.read<ContactDetailsBloc>().add(PrepareNewContact(defaultFrequency: fetchedDefaultFrequency));
        // --- End NEW contact logic ---
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
    _youtubeController.text = _localContact.youtubeUrl ?? '';
    _instagramController.text = _localContact.instagramHandle ?? '';
    _facebookController.text = _localContact.facebookUrl ?? '';
    _snapchatController.text = _localContact.snapchatHandle ?? '';
    _xHandleController.text = _localContact.xHandle ?? '';
    _linkedInController.text = _localContact.linkedInUrl ?? '';
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
    // Determine title dynamically
    final appBarTitle = BlocBuilder<ContactDetailsBloc, ContactDetailsState>(
      builder: (context, state) {
        // Decide title based on nickname presence
        String nameToShow = '';
        if (state is Loaded) {
          final contact = state.contact;
          nameToShow = (contact.nickname != null && contact.nickname!.isNotEmpty)
              ? contact.nickname!
              : '${contact.firstName} ${contact.lastName}';
        } else if (state is Cleared) {
          nameToShow = 'Add Contact';
        } else {
          // Keep existing fallback logic
          if (nameToShow.isEmpty) {
            nameToShow = _isEditMode ? 'Add/Edit Contact' : 'Contact Details';
          }
        }

        // If name is still empty (e.g., initial state before load or clear), use defaults
        if (nameToShow.isEmpty) {
          nameToShow = _isEditMode ? 'Add/Edit Contact' : 'Contact Details';
        }

        return Text(_isEditMode ? 'Edit: $nameToShow' : nameToShow);
      },
    );

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
              // DELETE
              icon: const Icon(Icons.delete),
              tooltip: 'Delete Contact',
              onPressed: (_localContact.id != null && _localContact.id != 0)
                  ? () => _onDeleteButtonPressed(context)
                  : null,
            ),
            // EDIT/SAVE IconButton
            BlocBuilder<ContactDetailsBloc, ContactDetailsState>(
              builder: (context, state) {
                // Determine if the BLoC state allows interaction
                final bool blocAllowsInteraction = state is Loaded;

                // Can enter edit mode if BLoC is loaded and we're not already editing
                final bool canEnterEdit = blocAllowsInteraction && !_isEditMode;

                // Can save changes if we ARE in edit mode AND have unsaved changes
                final bool canSaveChanges = _isEditMode && _hasUnsavedChanges;

                return IconButton(
                  icon: Icon(_isEditMode ? Icons.save : Icons.edit),
                  tooltip: _isEditMode ? 'Save Changes' : 'Edit Contact',
                  // Enable Save only if in edit mode with changes
                  // Enable Edit only if bloc allows interaction and not already editing
                  onPressed: _isEditMode
                      ? (canSaveChanges ? () => _onSaveButtonPressed(context) : null) // Save action
                      : (canEnterEdit
                          ? () {
                              // Entering edit mode
                              setState(() {
                                // _localContact should already be correct from the listener
                                _isEditMode = true;
                                _hasUnsavedChanges = false; // Reset flag when starting edit
                              });
                              logger.d("Edit button pressed. Entering edit mode.");
                            }
                          : null), // Edit action
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<ContactDetailsBloc, ContactDetailsState>(
          listener: (context, state) {
            if (state is Loaded) {
              final bool isNewContactForm = state.contact.id == 0;

              // If we are not currently editing, OR if the loaded contact ID
              // is different from our local one (meaning BLoC loaded a different record),
              // update the local state and controllers.
              if (!_isEditMode || state.contact.id != _localContact.id) {
                setState(() {
                  _localContact = state.contact;
                  _updateControllersFromLocalContact();
                  _hasUnsavedChanges =
                      false; // Reset changes flag when loading data
                  // Enter edit mode automatically for a new contact form
                  _isEditMode = isNewContactForm;
                  // Ensure initialized is true once loaded
                  _initialized = true;
                });
                logger.d("Listener updated local state from BLoC. isEditMode: $_isEditMode");
              } else {
                // If we ARE in edit mode and the BLoC emits the SAME contact
                // (e.g., after a background save confirmation), do NOT overwrite local state.
                // We might still want to reset flags if the save was successful.
                setState(() {
                  _hasUnsavedChanges =
                      false; // Assume save was successful if state re-emitted
                  _isEditMode =
                      false; // Exit edit mode after successful save confirmation
                  _initialized = true; // Ensure initialized
                });
                logger.d("Listener: In edit mode, BLoC re-emitted same contact. Exiting edit mode.");
              }
            } else if (state is Error) {
              if (mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Error: ${state.message}")));
              }
              logger.e(state.message);
              // Keep existing UI or show error placeholder in builder
              setState(() {
                _initialized =
                    true; // Mark as initialized even on error to show something
              });
            } else if (state is Cleared) {
              // This state now primarily means a deletion was successful.
              // The navigation back should handle leaving the screen.
              // We don't need to reset the form here as we're likely popping.
              logger.d("Listener: Cleared received (likely post-delete).");
              setState(() {
                _initialized = true; // Mark as initialized
              });
            } else if (state is Loading || state is Initial) {
              // Optionally handle loading/initial states (e.g., disable buttons)
              // The builder already shows a progress indicator.
              setState(() {
                // Don't set initialized = true here, wait for Loaded/Error/Cleared
              });
            }
          },
          builder: (context, state) {
            // Builder logic remains largely the same, relying on the state type
            // and the _isEditMode flag managed by the listener/button actions.
            if (state is Loaded) {
              // Show loaded body (view or edit mode determined by _isEditMode)
              return _buildLoadedBody();
            } else if (state is Initial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is Loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is Cleared) {
              // If cleared and in edit mode, show the form for the new contact
              if (_isEditMode) {
                return _buildLoadedBody();
              } else {
                // If cleared and not in edit mode (e.g., after delete before navigation)
                // show a placeholder or loading indicator.
                return const Center(child: Text('Contact cleared or not loaded.'));
              }
            } else if (state is Error) {
              // Show error body, potentially including the form with last known data
              return _buildErrorBody(state.message);
            } else {
              // Fallback for any unexpected state
              return const Center(child: Text('Unknown state'));
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
          Text("Error: $errorMessage", style: const TextStyle(color: Colors.red)),
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
    if (_localContact.phoneNumber != null && _localContact.phoneNumber!.isNotEmpty) {
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
        if (_localContact.nickname != null && _localContact.nickname!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0), // Add padding below full name
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
                    onPressed: () => _launchUniversalLink(
                        Uri.parse('sms:${_sanitizePhoneNumber(unmaskedPhoneNumber)}')),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                  IconButton(
                    icon: const Icon(Icons.call),
                    tooltip: 'Call',
                    onPressed: () => _launchUniversalLink(
                        Uri.parse('tel:${_sanitizePhoneNumber(unmaskedPhoneNumber)}')),
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
              Expanded(child: _buildEmailDisplayList(_localContact.emails)) // Use helper
            ])),

        // Notes
        _buildDisplayRow(
            Icons.notes_outlined, 'Notes:', _localContact.notes ?? 'Not set'),

        const Divider(height: 24.0),

        // Social Media
        _buildDisplayRow(Icons.play_circle_outline, 'YouTube:',
            _localContact.youtubeUrl ?? 'Not set'),
        _buildDisplayRow(Icons.photo_camera_outlined, 'Instagram:',
            _localContact.instagramHandle ?? 'Not set'),
        _buildDisplayRow(Icons.facebook_outlined, 'Facebook:',
            _localContact.facebookUrl ?? 'Not set'),
        _buildDisplayRow(Icons.snapchat_outlined, 'Snapchat:',
            _localContact.snapchatHandle ?? 'Not set'),
        _buildDisplayRow(Icons.alternate_email, 'X Handle:',
            _localContact.xHandle ?? 'Not set'), // Using X icon
        _buildDisplayRow(Icons.link, 'LinkedIn URL:',
            _localContact.linkedInUrl ?? 'Not set'), // Using link icon

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

        buildEditSectionHeader('Social Media'),
        _buildEditSocialMedia(), // Delegate

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
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Please enter a first name' : null,
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
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Please enter a last name' : null,
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
            _localContact =
                _localContact.copyWith(nickname: value.isNotEmpty ? value : null);
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
            _localContact =
                _localContact.copyWith(phoneNumber: phoneMaskFormatter.getUnmaskedText());
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
          value: ContactFrequency.values.any((f) => f.value == _localContact.frequency)
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

  Widget _buildEditSocialMedia() {
    return Column(
      children: [
        _buildSocialMediaInput(
            Icons.play_circle_outline,
            'YouTube URL',
            _youtubeController,
            (v) => setState(() {
                  _localContact = _localContact.copyWith(youtubeUrl: v);
                  _hasUnsavedChanges = true;
                })),
        _buildSocialMediaInput(
            Icons.photo_camera_outlined,
            'Instagram Handle',
            _instagramController,
            (v) => setState(() {
                  _localContact = _localContact.copyWith(instagramHandle: v);
                  _hasUnsavedChanges = true;
                })),
        _buildSocialMediaInput(
            Icons.facebook_outlined,
            'Facebook URL',
            _facebookController,
            (v) => setState(() {
                  _localContact = _localContact.copyWith(facebookUrl: v);
                  _hasUnsavedChanges = true;
                })),
        _buildSocialMediaInput(
            Icons.snapchat_outlined,
            'Snapchat Handle',
            _snapchatController,
            (v) => setState(() {
                  _localContact = _localContact.copyWith(snapchatHandle: v);
                  _hasUnsavedChanges = true;
                })),
        _buildSocialMediaInput(
            Icons.alternate_email,
            'X Handle',
            _xHandleController,
            (v) => setState(() {
                  _localContact = _localContact.copyWith(xHandle: v);
                  _hasUnsavedChanges = true;
                })),
        _buildSocialMediaInput(
            Icons.link,
            'LinkedIn URL',
            _linkedInController,
            (v) => setState(() {
                  _localContact = _localContact.copyWith(linkedInUrl: v);
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
                    decoration: InputDecoration(
                      labelText: 'Email ${index + 1}',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                        // Update the email in the list
                        List<String> updatedEmails =
                            List<String>.from(_localContact.emails ?? []);
                        if (index < updatedEmails.length) {
                          updatedEmails[index] = value;
                        } else {
                          updatedEmails.add(value);
                        }
                        _localContact =
                            _localContact.copyWith(emails: updatedEmails);
                        _hasUnsavedChanges = true;
                      });
                    },
                  ),
                ),
                if (_isEditMode)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      setState(() {
                        // Remove controller and update model
                        _emailControllers.removeAt(index);
                        List<String> updatedEmails =
                            List<String>.from(_localContact.emails ?? []);
                        if (index < updatedEmails.length) {
                          updatedEmails.removeAt(index);
                          _localContact =
                              _localContact.copyWith(emails: updatedEmails);
                          _hasUnsavedChanges = true;
                        }
                      });
                    },
                  ),
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
            onPressed: _isEditMode
                ? () {
                    setState(() {
                      _emailControllers.add(TextEditingController());
                      // Don't modify localContact.emails yet - wait for user input first
                    });
                  }
                : null,
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
        context.read<ContactDetailsBloc>().add(AddContact(contact: contactToSave)); // Use contactToSave
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('New contact saved')));
        }
      } else {
        context.read<ContactDetailsBloc>().add(SaveContact(contact: contactToSave)); // Use contactToSave
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
        context.read<ContactListBloc>().add(const LoadContacts());
        Navigator.of(context).pop();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please correct the errors before saving.')),
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
                  context.read<ContactDetailsBloc>().add(DeleteContact(contactId: contactIdToDelete));
                  context.read<ContactListBloc>().add(const LoadContacts());
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
    context.read<ContactDetailsBloc>().add(SaveContact(contact: updatedContact));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Marked as contacted: ${DateFormat.yMd().format(now)}')));
      context.read<ContactListBloc>().add(const LoadContacts());
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
          Expanded(child: valueWidget), // Use the potentially wrapped valueWidget
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
        padding: EdgeInsets.only(top: 6.0, bottom: 6.0), // Match vertical padding
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
          padding: const EdgeInsets.symmetric(vertical: 4.0), // Spacing between emails
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
