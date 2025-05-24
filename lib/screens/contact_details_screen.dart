// lib/screens/contact_details_screen.dart
import 'package:flutter/foundation.dart'; // Import kDebugMode
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:recall/blocs/contact_details/contact_details_bloc.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/utils/logger.dart';
import 'package:recall/models/enums.dart';
import 'package:recall/repositories/usersettings_repository.dart';
import 'package:recall/services/notification_helper.dart';
import 'package:recall/utils/contact_utils.dart';
import 'package:recall/widgets/contact/contact_view_widget.dart';
import 'package:recall/widgets/contact/contact_edit_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:recall/config/app_router.dart';

class ContactDetailsScreen extends StatefulWidget {
  final int contactId;

  const ContactDetailsScreen({
    super.key,
    required this.contactId,
  });

  @override
  State<ContactDetailsScreen> createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  // MARK: - Properties
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _nicknameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _notesController;
  final List<TextEditingController> _emailControllers = [];

  late Contact _localContact;
  bool _hasUnsavedChanges = false;
  bool _isEditMode = false;
  final NotificationHelper notificationHelper = NotificationHelper();

  final phoneMaskFormatter = MaskTextInputFormatter(
      mask: '(###) ###-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  // MARK: - Lifecycle Methods
  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeContact();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _loadContactOrDefault();
    });
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  // MARK: - Initialization & Controller Management
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
      frequency: ContactFrequency.biweekly.value,
      birthday: null,
      anniversary: null,
      lastContactDate: DateTime.now(),
      phoneNumber: null,
      emails: [],
      notes: null,
      isActive: true,
    );
  }

  Future<void> _loadContactOrDefault() async {
    // Use widget.contactId directly, passed by GoRouter
    if (widget.contactId != 0) {
      context
          .read<ContactDetailsBloc>()
          .add(LoadContactEvent(contactId: widget.contactId));
    } else {
      String fetchedDefaultFrequency = ContactFrequency.biweekly.value;
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
        _hasUnsavedChanges = true;
        _localContact = _localContact.copyWith(
          frequency: fetchedDefaultFrequency,
          emails: [],
        );
        _updateControllersFromLocalContact();
        _updateEmailControllers();
      });
      context
          .read<ContactDetailsBloc>()
          .add(UpdateContactLocallyEvent(contact: _localContact));
    }
  }

  void _updateControllersFromLocalContact() {
    _firstNameController.text = _localContact.firstName;
    _lastNameController.text = _localContact.lastName;
    _nicknameController.text = _localContact.nickname ?? '';
    _phoneNumberController.text = _localContact.phoneNumber != null
        ? phoneMaskFormatter.maskText(_localContact.phoneNumber!)
        : '';
    _notesController.text = _localContact.notes ?? '';
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

  // MARK: - Build Methods
  @override
  Widget build(BuildContext context) {
    final appBarTitle = BlocBuilder<ContactDetailsBloc, ContactDetailsState>(
      builder: (context, state) {
        String nameToShow = '';
        if (state is LoadedContactDetailsState) {
          nameToShow = (state.contact.nickname != null &&
                  state.contact.nickname!.isNotEmpty)
              ? state.contact.nickname!
              : '${state.contact.firstName} ${state.contact.lastName}';
        } else if (state is ClearedContactDetailsState) {
          nameToShow = 'Add Contact';
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
          actions: _buildAppBarActions(),
        ),
        body: _buildBody(),
        floatingActionButton: _buildFloatingActionButtons(),
      ),
    );
  }

  // MARK: - AppBar Actions Builder
  List<Widget> _buildAppBarActions() {
    return [
      IconButton(
        icon: const Icon(Icons.delete),
        tooltip: 'Delete Contact',
        onPressed: (_localContact.id != null && _localContact.id != 0)
            ? () => _onDeleteButtonPressed(context)
            : null,
      ),
      BlocBuilder<ContactDetailsBloc, ContactDetailsState>(
        builder: (context, state) {
          final bool isLoaded = state is LoadedContactDetailsState;
          final bool isNewContactMode =
              (state is ClearedContactDetailsState && _isEditMode) ||
                  (_localContact.id == 0 && _isEditMode);
          final bool canEditOrSave = isLoaded || isNewContactMode;
          final bool isDisabledByState = state is LoadingContactDetailsState ||
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
                ? (canSaveChanges ? () => _onSaveButtonPressed(context) : null)
                : (canEnterEdit
                    ? () {
                        if (state is LoadedContactDetailsState) {
                          setState(() {
                            _isEditMode = true;
                            _localContact = state.contact;
                            _updateControllersFromLocalContact();
                            _updateEmailControllers();
                          });
                        }
                      }
                    : null),
          );
        },
      ),
    ];
  }

  // MARK: - Body Builder & State Handling
  Widget _buildBody() {
    return BlocConsumer<ContactDetailsBloc, ContactDetailsState>(
      listener: (context, state) {
        if (state is LoadedContactDetailsState) {
          if (!_isEditMode || (state.contact.id != _localContact.id)) {
            setState(() {
              _localContact = state.contact;
              _updateControllersFromLocalContact();
              _updateEmailControllers();
              _hasUnsavedChanges = false;
            });
          }
        } else if (state is ErrorContactDetailsState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Error: ${state.message}")));
          logger.e(state.message);
        } else if (state is ClearedContactDetailsState) {
          if (_isEditMode) {
            setState(() {
              _initializeContact();
              _updateControllersFromLocalContact();
              _updateEmailControllers();
              _hasUnsavedChanges = true;
            });
          }
        }
      },
      builder: (context, contactDetailsState) {
        // Add BlocBuilder for ContactListBloc to get activeContactCount
        return BlocBuilder<ContactListBloc, ContactListState>(
          builder: (context, contactListState) {
            int activeContactCount = 0;
            if (contactListState is LoadedContactListState) {
              activeContactCount = contactListState.originalContacts
                  .where((c) => c.isActive)
                  .length;
            }

            if (contactDetailsState is LoadedContactDetailsState) {
              return _buildLoadedBody(activeContactCount);
            } else if (contactDetailsState is InitialContactDetailsState ||
                contactDetailsState is LoadingContactDetailsState) {
              return const Center(child: CircularProgressIndicator());
            } else if (contactDetailsState is ClearedContactDetailsState) {
              return _isEditMode
                  ? _buildLoadedBody(activeContactCount)
                  : const Center(child: Text('Enter new contact details'));
            } else if (contactDetailsState is ErrorContactDetailsState) {
              return _buildErrorBody(
                  contactDetailsState.message, activeContactCount);
            } else {
              if (_isEditMode &&
                  (_localContact.id == 0 || _localContact.id == null)) {
                return _buildLoadedBody(activeContactCount);
              }
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }

  // MARK: - Floating Action Buttons Builder
  Widget? _buildFloatingActionButtons() {
    if (_isEditMode || (_localContact.id == null || _localContact.id == 0)) {
      return null; // Don't show FABs in edit mode or for a new unsaved contact
    }

    List<Widget> fabs = [
      FloatingActionButton.extended(
        heroTag: 'markContactedFab',
        onPressed: _onContactedButtonPressed,
        label: const Text('Mark Contacted'),
        icon: const Icon(Icons.check_circle_outline),
      ),
    ];

    if (kDebugMode) {
      fabs.add(const SizedBox(height: 10));
      fabs.add(
        FloatingActionButton.extended(
          heroTag: 'testNotificationFab',
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
          label: const Text('Test Notification'),
          icon: const Icon(Icons.notifications_active_outlined),
          backgroundColor: Colors.blueGrey,
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: fabs,
    );
  }

  // MARK: - Error Body Builder
  Widget _buildErrorBody(String errorMessage, int activeContactCount) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Error: $errorMessage",
              style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 20),
          if (_isEditMode)
            Expanded(
                child: SingleChildScrollView(
                    child: _buildLoadedBody(activeContactCount)))
          else
            const Text("Could not load contact details."),
        ],
      ),
    );
  }

  // MARK: - Main Content Body Builder (Loaded/Editing)
  Widget _buildLoadedBody(int activeContactCount) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _isEditMode
            ? _buildEditModeSection(activeContactCount)
            : _buildViewModeSection(),
      ),
    );
  }

  // MARK: - View Mode Section Builder
  Widget _buildViewModeSection() {
    return ContactViewWidget(
      contact: _localContact,
      phoneMaskFormatter: phoneMaskFormatter,
      onPhoneActionTap: (unmaskedPhoneNumber) =>
          _showPhoneActions(unmaskedPhoneNumber),
      onEmailTap: (email) => _launchEmail(email),
    );
  }

  // MARK: - Edit Mode Section Builder
  Widget _buildEditModeSection(int activeContactCount) {
    return ContactEditWidget(
      contact: _localContact,
      phoneMaskFormatter: phoneMaskFormatter,
      firstNameController: _firstNameController,
      lastNameController: _lastNameController,
      nicknameController: _nicknameController,
      phoneNumberController: _phoneNumberController,
      notesController: _notesController,
      emailControllers: _emailControllers,
      onContactChanged: _handleContactChange,
      onEmailsChanged: _handleEmailsChange,
      activeContactCount: activeContactCount,
      maxActiveContacts: 18, // Use literal 18
    );
  }

  // MARK: - Change Handlers for Edit Mode
  void _handleContactChange(Contact updatedContact) {
    if (!mounted) return;
    setState(() {
      _localContact = updatedContact;
      _hasUnsavedChanges = true;
    });
  }

  void _handleEmailsChange(List<String> updatedEmails) {
    if (!mounted) return;
    setState(() {
      _localContact = _localContact.copyWith(emails: updatedEmails);
      _hasUnsavedChanges = true;
      _syncEmailControllers(updatedEmails);
    });
  }

  void _syncEmailControllers(List<String> emails) {
    while (_emailControllers.length < emails.length) {
      _emailControllers
          .add(TextEditingController(text: emails[_emailControllers.length]));
    }
    while (_emailControllers.length > emails.length) {
      _emailControllers.removeLast().dispose();
    }
    for (int i = 0; i < emails.length; i++) {
      if (_emailControllers[i].text != emails[i]) {
        _emailControllers[i].text = emails[i];
        _emailControllers[i].selection = TextSelection.fromPosition(
            TextPosition(offset: _emailControllers[i].text.length));
      }
    }
  }

  // MARK: - Action Handlers (Navigation, Save, Delete, Contacted)
  Future<void> _handleBackNavigation() async {
    if (mounted) {
      /*context.read<ContactListBloc>().add(
            const LoadContactListEvent(
              filters: {
                ContactListFilterType.homescreen,
              }, // Pre-load active contacts
              sortField: ContactListSortField.lastContactDate,
              ascending: true, // most overdue first
            ),
          );*/
      context.pop();
    }
  }

  void _onSaveButtonPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!
          .save(); // Ensure all onSaved callbacks are triggered

      // Update _localContact with values from controllers one last time
      _localContact = _localContact.copyWith(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        nickname: _nicknameController.text,
        phoneNumber: phoneMaskFormatter.getUnmaskedText(),
        notes: _notesController.text,
        // emails are handled by _handleEmailsChange via onSaved in EmailListEditWidget
      );

      context
          .read<ContactDetailsBloc>()
          .add(SaveContactEvent(contact: _localContact));
      setState(() {
        _isEditMode = false;
        _hasUnsavedChanges = false;
      });
    }
  }

  void _onDeleteButtonPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Contact'),
          content: const Text('Are you sure you want to delete this contact?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
                context
                    .read<ContactDetailsBloc>()
                    .add(DeleteContactEvent(contactId: widget.contactId));
                if (mounted) {
                  //TODO: need something here to either pop to home or contact list and do it in a
                  // way that correctly applies the filter
                  context.pop(); // Pop back to the previous screen
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _onContactedButtonPressed() {
    final now = DateTime.now();
    // Ensure the local contact being used for calculateNextContactDate has the updated lastContactDate
    final contactWithUpdatedLastContactDate =
        _localContact.copyWith(lastContactDate: now);
    final Contact updatedContact = contactWithUpdatedLastContactDate.copyWith(
      nextContactDate:
          calculateNextContactDate(contactWithUpdatedLastContactDate),
    );
    context
        .read<ContactDetailsBloc>()
        .add(SaveContactEvent(contact: updatedContact));
    setState(() {
      _localContact =
          updatedContact; // Update local state to reflect change immediately
      _hasUnsavedChanges = false; // Assuming marking as contacted is a save
    });
  }

  // MARK: - Utility & Action Launchers
  Future<void> _launchUniversalLink(Uri url) async {
    await ContactUtils.launchUniversalLink(context, url);
  }

  void _showPhoneActions(String unmaskedPhoneNumber) {
    if (unmaskedPhoneNumber.isEmpty) return;

    final Uri telUri = ContactUtils.createPhoneUri(unmaskedPhoneNumber);
    final Uri smsUri = ContactUtils.createSmsUri(unmaskedPhoneNumber);

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
    final Uri emailUri = ContactUtils.createEmailUri(emailAddress);
    _launchUniversalLink(emailUri);
  }
} // End of _ContactDetailsScreenState
