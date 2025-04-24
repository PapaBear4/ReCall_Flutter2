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
      xHandle: null,
      linkedInUrl: null,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final contactId = ModalRoute.of(context)!.settings.arguments as int?;
      if (contactId != null && contactId != 0) {
        context.read<ContactDetailsBloc>().add(LoadContact(contactId: contactId));
      } else {
        String fetchedDefaultFrequency = ContactFrequency.never.value;
        try {
          if (!mounted) return;
          final settingsRepo = context.read<UserSettingsRepository>();
          final settingsList = await settingsRepo.getAll();
          if (settingsList.isNotEmpty) {
            fetchedDefaultFrequency = settingsList.first.defaultFrequency;
          }
        } catch (e) {
          logger.e("Error fetching default frequency: $e");
        }

        if (!mounted) return;

        context.read<ContactDetailsBloc>().add(PrepareNewContact(defaultFrequency: fetchedDefaultFrequency));
      }
    });
  }

  void _updateControllersFromLocalContact() {
    _firstNameController.text = _localContact.firstName;
    _lastNameController.text = _localContact.lastName;
    _nicknameController.text = _localContact.nickname ?? '';
    _phoneNumberController.text = _localContact.phoneNumber ?? '';
    _notesController.text = _localContact.notes ?? '';
    _updateEmailControllers();
  }

  void _updateEmailControllers() {
    for (var controller in _emailControllers) {
      controller.dispose();
    }
    _emailControllers.clear();
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
    for (var controller in _emailControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarTitle = BlocBuilder<ContactDetailsBloc, ContactDetailsState>(
      builder: (context, state) {
        String nameToShow = '';
        if (state is Loaded) {
          final contact = state.contact;
          nameToShow = (contact.nickname != null && contact.nickname!.isNotEmpty)
              ? contact.nickname!
              : '${contact.firstName} ${contact.lastName}';
        } else if (state is Cleared) {
          nameToShow = 'Add Contact';
        } else {
          if (nameToShow.isEmpty) {
            nameToShow = _isEditMode ? 'Add/Edit Contact' : 'Contact Details';
          }
        }

        if (nameToShow.isEmpty) {
          nameToShow = _isEditMode ? 'Add/Edit Contact' : 'Contact Details';
        }

        return Text(_isEditMode ? 'Edit: $nameToShow' : nameToShow);
      },
    );

    final bool preventPop = _isEditMode && _hasUnsavedChanges;

    return PopScope(
      canPop: !preventPop,
      child: Scaffold(
        appBar: AppBar(
          title: appBarTitle,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _handleBackNavigation()),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete Contact',
              onPressed: (_localContact.id != null && _localContact.id != 0)
                  ? () => _onDeleteButtonPressed(context)
                  : null,
            ),
            BlocBuilder<ContactDetailsBloc, ContactDetailsState>(
              builder: (context, state) {
                final bool blocAllowsInteraction = state is Loaded;
                final bool canEnterEdit = blocAllowsInteraction && !_isEditMode;
                final bool canSaveChanges = _isEditMode && _hasUnsavedChanges;

                return IconButton(
                  icon: Icon(_isEditMode ? Icons.save : Icons.edit),
                  tooltip: _isEditMode ? 'Save Changes' : 'Edit Contact',
                  onPressed: _isEditMode
                      ? (canSaveChanges ? () => _onSaveButtonPressed(context) : null)
                      : (canEnterEdit
                          ? () {
                              setState(() {
                                _isEditMode = true;
                                _hasUnsavedChanges = false;
                              });
                              logger.d("Edit button pressed. Entering edit mode.");
                            }
                          : null),
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<ContactDetailsBloc, ContactDetailsState>(
          listener: (context, state) {
            if (state is Loaded) {
              final bool isNewContactForm = state.contact.id == 0;

              if (!_isEditMode || state.contact.id != _localContact.id) {
                setState(() {
                  _localContact = state.contact;
                  _updateControllersFromLocalContact();
                  _hasUnsavedChanges = false;
                  _isEditMode = isNewContactForm;
                  _initialized = true;
                });
                logger.d("Listener updated local state from BLoC. isEditMode: $_isEditMode");
              } else {
                setState(() {
                  _hasUnsavedChanges = false;
                  _isEditMode = false;
                  _initialized = true;
                });
                logger.d("Listener: In edit mode, BLoC re-emitted same contact. Exiting edit mode.");
              }
            } else if (state is Error) {
              if (mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Error: ${state.message}")));
              }
              logger.e(state.message);
              setState(() {
                _initialized = true;
              });
            } else if (state is Cleared) {
              logger.d("Listener: Cleared received (likely post-delete).");
              setState(() {
                _initialized = true;
              });
            } else if (state is Loading || state is Initial) {
              setState(() {});
            }
          },
          builder: (context, state) {
            if (state is Loaded) {
              return _buildLoadedBody();
            } else if (state is Initial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is Loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is Cleared) {
              if (_isEditMode) {
                return _buildLoadedBody();
              } else {
                return const Center(child: Text('Contact cleared or not loaded.'));
              }
            } else if (state is Error) {
              return _buildErrorBody(state.message);
            } else {
              return const Center(child: Text('Unknown state'));
            }
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

  Widget _buildErrorBody(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Error: $errorMessage", style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 20),
          if (_initialized)
            Expanded(child: SingleChildScrollView(child: _buildLoadedBody()))
          else
            const Text("Could not load contact details."),
        ],
      ),
    );
  }

  Widget _buildLoadedBody() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (!_isEditMode)
              _buildViewModeSection()
            else
              _buildEditModeSection()
          ],
        ),
      ),
    );
  }

  Widget _buildViewModeSection() {
    String formattedPhoneNumber = 'Not set';
    String unmaskedPhoneNumber = '';
    if (_localContact.phoneNumber != null && _localContact.phoneNumber!.isNotEmpty) {
      unmaskedPhoneNumber = _localContact.phoneNumber!;
      try {
        formattedPhoneNumber = phoneMaskFormatter.maskText(unmaskedPhoneNumber);
      } catch (e) {
        formattedPhoneNumber = unmaskedPhoneNumber;
        logger.e("Error masking phone for display: $e");
      }
    }
    final String nameDisplay =
        (_localContact.nickname != null && _localContact.nickname!.isNotEmpty)
            ? _localContact.nickname!
            : '${_localContact.firstName} ${_localContact.lastName}';
    final String fullNameDisplay =
        '${_localContact.firstName} ${_localContact.lastName}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SECTION 1: Basic Info + Phone + Email
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            nameDisplay,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        if (_localContact.nickname != null && _localContact.nickname!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              '($fullNameDisplay)',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.grey[600]),
            ),
          )
        else
          const SizedBox(height: 24.0),

        // Phone (moved up)
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
        
        // Email (moved up)
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.email_outlined, size: 20.0, color: Colors.grey[700]),
              const SizedBox(width: 12.0),
              const SizedBox(
                  width: 110,
                  child: Text('Emails:',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: _buildEmailDisplayList(_localContact.emails))
            ])),

        const Divider(height: 24.0),

        // SECTION 2: Dates + Notes
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
        
        // Notes
        _buildDisplayRow(
            Icons.notes_outlined, 'Notes:', _localContact.notes ?? 'Not set'),

        const Divider(height: 24.0),

        // SECTION 3: Contact Frequency Details
        _buildDisplayRow(Icons.access_time, 'Last Contacted:',
            formatLastContacted(_localContact.lastContacted)),
        _buildDisplayRow(Icons.repeat, 'Frequency:', _localContact.frequency),
        _buildDisplayRow(
            Icons.next_plan_outlined,
            'Next Due:',
            calculateNextDueDateDisplay(
                _localContact.lastContacted, _localContact.frequency)),

        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildEditModeSection() {
    Widget buildEditSectionHeader(String title) {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
        child: Text(title, style: Theme.of(context).textTheme.titleMedium),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SECTION 1: Basic Info + Phone + Email
        buildEditSectionHeader('Contact Information'),
        _buildEditBasicInfo(),
        
        // Email moved up under basic info
        buildEditSectionHeader('Emails'),
        _buildEmailListEditor(),

        // SECTION 2: Dates + Notes
        buildEditSectionHeader('Important Dates'),
        _buildEditDates(),
        
        buildEditSectionHeader('Notes'),
        _buildEditNotes(),
        
        // SECTION 3: Contact Frequency
        buildEditSectionHeader('Contact Schedule'),
        _buildEditSchedule(),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildEditBasicInfo() {
    return Column(
      children: [
        TextFormField(
          controller: _firstNameController,
          enabled: _isEditMode,
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
          controller: _nicknameController,
          enabled: _isEditMode,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
              labelText: 'Nickname (Optional)', border: OutlineInputBorder()),
          onChanged: (value) => setState(() {
            _localContact =
                _localContact.copyWith(nickname: value.isNotEmpty ? value : null);
            _hasUnsavedChanges = true;
          }),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _phoneNumberController,
          enabled: _isEditMode,
          keyboardType: TextInputType.phone,
          inputFormatters: [phoneMaskFormatter],
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

  Widget _buildEditDates() {
    return Column(
      children: [
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

  Widget _buildEditSchedule() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
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
        // Last Contacted display (read-only)
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Last Contacted', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(
                formatLastContacted(_localContact.lastContacted),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
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
                    onDatePicked(picked);
                  }
                },
          child: Text(currentValue == null
              ? 'Select Date'
              : DateFormat.yMd().format(currentValue)),
        ),
      ],
    );
  }

  Widget _buildEmailListEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Email'),
            onPressed: _isEditMode
                ? () {
                    setState(() {
                      _emailControllers.add(TextEditingController());
                    });
                  }
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDisplayRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.0, color: Colors.grey[700]),
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
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                  foregroundColor: Colors.red),
              child: const Text('Discard'),
            ),
          ],
        ),
      );

      if (!mounted) return;

      if (discard == true) {
        Navigator.of(context).pop();
      }
    } else {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _onSaveButtonPressed(BuildContext context) {
    Contact contactToSave = _localContact;

    List<String> updatedEmails = [];
    if (_localContact.emails != null) {
      updatedEmails = List<String>.from(_localContact.emails!);
    }

    if (_isEditMode) {
      while (updatedEmails.length < _emailControllers.length) {
        updatedEmails.add('');
      }
      if (updatedEmails.length > _emailControllers.length) {
        updatedEmails = updatedEmails.sublist(0, _emailControllers.length);
      }

      for (int i = 0; i < _emailControllers.length; i++) {
        updatedEmails[i] = _emailControllers[i].text;
      }

      updatedEmails.removeWhere((email) => email.trim().isEmpty);

      contactToSave = contactToSave.copyWith(emails: updatedEmails);
    }

    if (_formKey.currentState!.validate()) {
      bool isExistingContact =
          contactToSave.id != null && contactToSave.id != 0;

      if (!isExistingContact) {
        context.read<ContactDetailsBloc>().add(AddContact(contact: contactToSave));
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('New contact saved')));
        }
      } else {
        context.read<ContactDetailsBloc>().add(SaveContact(contact: contactToSave));
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Changes saved')));
        }
      }

      if (mounted) {
        setState(() {
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
    if (_localContact.id == null || _localContact.id == 0) {
      return;
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
    if (_localContact.id == null || _localContact.id == 0) {
      return;
    }
    final now = DateTime.now();
    final updatedContact = _localContact.copyWith(lastContacted: now);

    setState(() {
      _localContact = updatedContact;
    });

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
      if (!mounted) return;

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

  String _sanitizePhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
  }

  void _showPhoneActions(String unmaskedPhoneNumber) {
    if (unmaskedPhoneNumber.isEmpty) return;

    String cleanPhoneNumber = _sanitizePhoneNumber(unmaskedPhoneNumber);

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
                Navigator.pop(context);
                _launchUniversalLink(telUri);
              },
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Send Message'),
              onTap: () {
                Navigator.pop(context);
                _launchUniversalLink(smsUri);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _launchEmail(String emailAddress) {
    if (emailAddress.isEmpty) return;
    final Uri emailUri = Uri.parse('mailto:$emailAddress');
    _launchUniversalLink(emailUri);
  }

  Widget _buildActionableDisplayRow({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
    List<Widget> actions = const [],
  }) {
    Widget valueWidget = Text(value);

    if (onTap != null && value != 'Not set') {
      valueWidget = InkWell(
        onTap: onTap,
        child: Text(
          value,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.0, color: Colors.grey[700]),
          const SizedBox(width: 12.0),
          SizedBox(
              width: 110,
              child: Text('$label ',
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: valueWidget),
          if (actions.isNotEmpty) ...[
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildEmailDisplayList(List<String>? emails) {
    if (emails == null || emails.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
        child: Text('Not set'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: emails.map((email) {
        if (email.trim().isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: InkWell(
            onTap: () => _launchEmail(email),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    email,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.email_outlined),
                  tooltip: 'Send Email',
                  iconSize: 20,
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
}
