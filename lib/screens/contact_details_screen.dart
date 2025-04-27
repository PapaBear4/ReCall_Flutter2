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
import 'package:recall/utils/logger.dart';
import 'package:recall/models/contact_enums.dart';
import 'package:recall/repositories/usersettings_repository.dart';
import 'package:recall/services/notification_helper.dart';
import 'package:url_launcher/url_launcher.dart';

// Import widget components
import 'widgets/contact_details/common_components.dart';
import 'widgets/contact_details/basic_info_section.dart';
import 'widgets/contact_details/email_section.dart';
import 'widgets/contact_details/dates_section.dart';
import 'widgets/contact_details/schedule_section.dart';

/// Main screen for viewing and editing contact details
class ContactDetailsScreen extends StatefulWidget {
  final int? contactId;

  const ContactDetailsScreen({super.key, this.contactId});

  @override
  State<ContactDetailsScreen> createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  // Form controllers and state variables
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _nicknameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _notesController;
  final List<TextEditingController> _emailControllers = [];

  // Contact data and UI state
  late Contact _localContact;
  bool _hasUnsavedChanges = false;
  bool _initialized = false;
  bool _isEditMode = false;
  final NotificationHelper notificationHelper = NotificationHelper();

  // Phone number formatter
  final phoneMaskFormatter = MaskTextInputFormatter(
      mask: '(###) ###-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeContact();
    _loadContactData();
  }

  void _initializeControllers() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _nicknameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _notesController = TextEditingController();
  }

  void _initializeContact() {
    _localContact = Contact(
      id: 0,
      firstName: '',
      lastName: '',
      nickname: null,
      frequency: ContactFrequency.never.value,
      birthday: null,
      lastContacted: null,
      phoneNumber: null,
      emails: [],
      notes: null,
    );
  }

  void _loadContactData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final contactId = ModalRoute.of(context)!.settings.arguments as int?;
      if (contactId != null && contactId != 0) {
        context.read<ContactDetailsBloc>().add(LoadContact(contactId: contactId));
      } else {
        await _loadNewContactWithDefaultFrequency();
      }
    });
  }

  Future<void> _loadNewContactWithDefaultFrequency() async {
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
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nicknameController.dispose();
    _phoneNumberController.dispose();
    _notesController.dispose();
    for (var controller in _emailControllers) {
      controller.dispose();
    }
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

  // Error display UI
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

  // Main content builder
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

  // View mode UI builder
  Widget _buildViewModeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section 1: Basic contact info
        BasicInfoViewSection(
          contact: _localContact,
          phoneMaskFormatter: phoneMaskFormatter,
          showPhoneActions: _showPhoneActions,
          launchUniversalLink: _launchUniversalLink,
          sanitizePhoneNumber: _sanitizePhoneNumber,
        ),
        
        // Email section
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              Icon(Icons.email_outlined, size: 20.0, color: Colors.grey[700]),
              const SizedBox(width: 12.0),
              const SizedBox(
                width: 110,
                child: Text('Emails:', style: TextStyle(fontWeight: FontWeight.bold))
              ),
              Expanded(
                child: EmailDisplayList(
                  emails: _localContact.emails,
                  launchEmail: _launchEmail
                )
              )
            ]
          )
        ),

        const Divider(height: 24.0),
        
        // Section 2: Dates and notes
        DatesViewSection(contact: _localContact),

        const Divider(height: 24.0),
        
        // Section 3: Contact frequency information
        ScheduleViewSection(contact: _localContact),

        const SizedBox(height: 16.0),
      ],
    );
  }

  // Edit mode UI builder
  Widget _buildEditModeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section 1: Basic contact info and email
        const SectionHeader(title: 'Contact Information'),
        BasicInfoEditSection(
          firstNameController: _firstNameController,
          lastNameController: _lastNameController,
          nicknameController: _nicknameController,
          phoneController: _phoneNumberController,
          phoneMaskFormatter: phoneMaskFormatter,
          onFirstNameChanged: (value) => setState(() {
            _localContact = _localContact.copyWith(firstName: value);
            _hasUnsavedChanges = true;
          }),
          onLastNameChanged: (value) => setState(() {
            _localContact = _localContact.copyWith(lastName: value);
            _hasUnsavedChanges = true;
          }),
          onNicknameChanged: (value) => setState(() {
            _localContact = _localContact.copyWith(nickname: value.isNotEmpty ? value : null);
            _hasUnsavedChanges = true;
          }),
          onPhoneChanged: (value) => setState(() {
            _localContact = _localContact.copyWith(phoneNumber: phoneMaskFormatter.getUnmaskedText());
            _hasUnsavedChanges = true;
          }),
        ),
        
        // Email editor
        const SectionHeader(title: 'Emails'),
        EmailListEditor(
          emailControllers: _emailControllers,
          isEditMode: _isEditMode,
          onEmailChanged: (index, value) {
            setState(() {
              List<String> updatedEmails = List<String>.from(_localContact.emails ?? []);
              if (index < updatedEmails.length) {
                updatedEmails[index] = value;
              } else {
                updatedEmails.add(value);
              }
              _localContact = _localContact.copyWith(emails: updatedEmails);
              _hasUnsavedChanges = true;
            });
          },
          onEmailDeleted: (index) {
            setState(() {
              _emailControllers.removeAt(index);
              List<String> updatedEmails = List<String>.from(_localContact.emails ?? []);
              if (index < updatedEmails.length) {
                updatedEmails.removeAt(index);
                _localContact = _localContact.copyWith(emails: updatedEmails);
                _hasUnsavedChanges = true;
              }
            });
          },
          onAddEmailPressed: () {
            setState(() {
              _emailControllers.add(TextEditingController());
            });
          },
        ),

        // Section 2: Important dates and notes
        const SectionHeader(title: 'Important Dates'),
        DatesEditSection(
          contact: _localContact,
          notesController: _notesController,
          isEditMode: _isEditMode,
          onBirthdaySelected: (picked) => setState(() {
            _localContact = _localContact.copyWith(birthday: picked);
            _hasUnsavedChanges = true;
          }),
          onAnniversarySelected: (picked) => setState(() {
            _localContact = _localContact.copyWith(anniversary: picked);
            _hasUnsavedChanges = true;
          }),
          onNotesChanged: (value) => setState(() {
            _localContact = _localContact.copyWith(notes: value.isNotEmpty ? value : null);
            _hasUnsavedChanges = true;
          }),
        ),
        
        // Section 3: Contact schedule settings
        const SectionHeader(title: 'Contact Schedule'),
        ScheduleEditSection(
          contact: _localContact,
          isEditMode: _isEditMode,
          onFrequencyChanged: (newValue) => setState(() {
            _localContact = _localContact.copyWith(frequency: newValue);
            _hasUnsavedChanges = true;
          }),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  // Navigation and action handlers
  Future<void> _handleBackNavigation() async {
    if (_isEditMode && _hasUnsavedChanges) {
      final bool? discard = await _showDiscardChangesDialog();
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
  
  Future<bool?> _showDiscardChangesDialog() {
    return showDialog<bool>(
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
  }

  void _onSaveButtonPressed(BuildContext context) {
    Contact contactToSave = _prepareContactForSave();

    if (_formKey.currentState!.validate()) {
      _saveContactToDatabase(contactToSave);
    } else {
      _showValidationErrorMessage();
    }
  }
  
  Contact _prepareContactForSave() {
    Contact contactToSave = _localContact;
    
    // Process emails
    if (_isEditMode) {
      List<String> updatedEmails = _processEmailsFromControllers();
      contactToSave = contactToSave.copyWith(emails: updatedEmails);
    }
    
    return contactToSave;
  }
  
  List<String> _processEmailsFromControllers() {
    List<String> updatedEmails = _localContact.emails != null 
        ? List<String>.from(_localContact.emails!) 
        : [];
        
    // Sync with controllers
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
    return updatedEmails;
  }
  
  void _saveContactToDatabase(Contact contactToSave) {
    bool isNewContact = contactToSave.id == null || contactToSave.id == 0;
    
    if (isNewContact) {
      context.read<ContactDetailsBloc>().add(AddContact(contact: contactToSave));
      _showSaveConfirmation('New contact saved');
    } else {
      context.read<ContactDetailsBloc>().add(SaveContact(contact: contactToSave));
      _showSaveConfirmation('Changes saved');
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
  }
  
  void _showSaveConfirmation(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message))
      );
    }
  }
  
  void _showValidationErrorMessage() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please correct the errors before saving.'))
      );
    }
  }

  void _onDeleteButtonPressed(BuildContext context) {
    if (_localContact.id == null || _localContact.id == 0) return;
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => _buildDeleteConfirmationDialog(dialogContext),
    );
  }
  
  Widget _buildDeleteConfirmationDialog(BuildContext dialogContext) {
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
            _deleteContact(contactIdToDelete);
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
  
  void _deleteContact(int contactId) {
    if (mounted) {
      context.read<ContactDetailsBloc>().add(DeleteContact(contactId: contactId));
      context.read<ContactListBloc>().add(const LoadContacts());
      Navigator.of(context).pop();
    }
  }

  void _onContactedButtonPressed() {
    if (_localContact.id == null || _localContact.id == 0) return;
    
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

  // Helper methods for phone/email functionality
  Future<void> _launchUniversalLink(Uri url) async {
    try {
      final bool canLaunch = await canLaunchUrl(url);
      if (!mounted) return;

      if (canLaunch) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        _showLinkErrorMessage('Could not launch $url');
      }
    } catch (e) {
      if (!mounted) return;
      _showLinkErrorMessage('Error launching link: $e');
      logger.e('Error launching link: $e');
    }
  }
  
  void _showLinkErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
      builder: (context) => _buildPhoneActionsSheet(context, telUri, smsUri),
    );
  }
  
  Widget _buildPhoneActionsSheet(BuildContext context, Uri telUri, Uri smsUri) {
    return SafeArea(
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
    );
  }

  void _launchEmail(String emailAddress) {
    if (emailAddress.isEmpty) return;
    final Uri emailUri = Uri.parse('mailto:$emailAddress');
    _launchUniversalLink(emailUri);
  }
}
