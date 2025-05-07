// lib/screens/contact_import_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Bloc
import 'package:flutter_contacts/flutter_contacts.dart' as fc; // Use prefix
import 'package:recall/models/enums.dart';
import 'package:recall/repositories/contact_repository.dart'; // Import Contact Repo
import 'package:recall/repositories/usersettings_repository.dart'; // Import Settings Repo
import 'package:recall/blocs/contact_list/contact_list_bloc.dart'; // Import List Bloc
import 'package:recall/services/contact_importer.dart';
import 'package:recall/utils/logger.dart';
import 'package:recall/models/contact.dart'
    as app_contact; // Alias for your app's Contact model

class ContactImportSelectionScreen extends StatefulWidget {
  const ContactImportSelectionScreen({super.key});

  @override
  State<ContactImportSelectionScreen> createState() =>
      _ContactImportSelectionScreenState();
}

// Helper class to manage selection state for each contact
class ContactSelectionInfo {
  final fc.Contact contact;
  bool isSelected;
  // Store chosen phone/emails temporarily (Phase 3.3 - initial setup)
  fc.Phone? selectedPhone;
  List<fc.Email> selectedEmails = [];

  ContactSelectionInfo(this.contact, {this.isSelected = false});
}

class PhoneEmailSelectionDialog extends StatefulWidget {
  final fc.Contact contact;
  final fc.Phone? initialPhone;
  final List<fc.Email> initialEmails;
  // Callback function to return selected items
  final Function(fc.Phone? selectedPhone, List<fc.Email> selectedEmails) onSave;

  const PhoneEmailSelectionDialog({
    super.key,
    required this.contact,
    required this.initialPhone,
    required this.initialEmails,
    required this.onSave,
  });

  @override
  State<PhoneEmailSelectionDialog> createState() =>
      _PhoneEmailSelectionDialogState();
}

class _PhoneEmailSelectionDialogState extends State<PhoneEmailSelectionDialog> {
  fc.Phone? _selectedPhone;
  late Set<fc.Email> _selectedEmails; // Use a Set for easier add/remove

  @override
  void initState() {
    super.initState();
    _selectedPhone = widget.initialPhone;
    _selectedEmails = Set<fc.Email>.from(widget.initialEmails);

    // Pre-select the first phone if none was initially selected and phones exist
    if (_selectedPhone == null && widget.contact.phones.isNotEmpty) {
      _selectedPhone = widget.contact.phones.first;
    }
    // Pre-select all emails if none were initially selected and emails exist
    if (_selectedEmails.isEmpty && widget.contact.emails.isNotEmpty) {
      _selectedEmails = Set<fc.Email>.from(widget.contact.emails);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen height to constrain dialog height
    final screenHeight = MediaQuery.of(context).size.height;

    return AlertDialog(
      title: Text('Select for ${widget.contact.displayName}'),
      // Constrain the content size
      content: Container(
        // Wrap content in a Container
        width: double.maxFinite, // Use maximum width available in dialog
        // Set a maximum height, e.g., 60% of screen height
        // Adjust this fraction as needed
        constraints: BoxConstraints(maxHeight: screenHeight * 0.6),
        child: SingleChildScrollView(
          // Content is scrollable
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Phone Selection ---
              if (widget.contact.phones.isNotEmpty) ...[
                const Text('Select One Phone Number:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                // Note: ListView.builder inside a Column needs shrinkWrap and physics
                // It should be okay here since the outer Container provides constraints
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.contact.phones.length,
                    itemBuilder: (context, index) {
                      final phone = widget.contact.phones[index];
                      return RadioListTile<fc.Phone>(
                        title: Text(phone.number),
                        subtitle: Text(phone.label.name),
                        value: phone,
                        groupValue: _selectedPhone,
                        onChanged: (fc.Phone? value) {
                          setState(() {
                            _selectedPhone = value;
                          });
                        },
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      );
                    }),
                const Divider(),
              ] else ...[
                const Text("No phone numbers found for this contact."),
                const Divider(),
              ],

              // --- Email Selection ---
              if (widget.contact.emails.isNotEmpty) ...[
                const Text('Select Email Addresses:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.contact.emails.length,
                    itemBuilder: (context, index) {
                      final email = widget.contact.emails[index];
                      return CheckboxListTile(
                        title: Text(email.address),
                        subtitle: Text(email.label.name),
                        value: _selectedEmails.contains(email),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedEmails.add(email);
                            } else {
                              _selectedEmails.remove(email);
                            }
                          });
                        },
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      );
                    }),
              ] else ...[
                const Text("No email addresses found for this contact."),
              ]
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.onSave(_selectedPhone, _selectedEmails.toList());
            Navigator.of(context).pop();
          },
          child: const Text('Save Selection'),
        ),
      ],
    );
  }
}

// Sort options - aligned with Contact model properties
enum SortOption {
  firstNameAsc, // Sort by first name ascending
  firstNameDesc, // Sort by first name descending
  lastNameAsc, // Sort by last name ascending
  lastNameDesc, // Sort by last name descending
  withPhone, // Contacts with phone numbers first
  withEmail // Contacts with emails first
}

class _ContactImportSelectionScreenState
    extends State<ContactImportSelectionScreen> {
  final ContactImporter _importer = ContactImporter();
  bool _isLoading = true;
  bool _isSaving = false; // Specific loading for import process
  String? _errorMessage;
  List<ContactSelectionInfo> _selectableContacts =
      []; // Holds contacts and their selection state
  List<ContactSelectionInfo> _filteredContacts =
      []; // Holds filtered contacts based on search and filters
  bool _isSelectAll = false;
  // Search and filter properties
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  SortOption _currentSortOption = SortOption.firstNameAsc;

  // Filter options
  bool _showOnlyWithPhone = false;
  bool _showOnlyWithEmail = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _applyFiltersAndSort();
    });
  }

  Future<void> _fetchContacts() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _selectableContacts = []; // Clear previous list
      _filteredContacts = []; // Clear filtered list
    });

    final result = await _importer.fetchAndFilterDeviceContacts();

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (result.status == ContactImportResultStatus.success) {
        // Wrap fetched contacts in ContactSelectionInfo
        _selectableContacts =
            result.contacts.map((c) => ContactSelectionInfo(c)).toList();
        _sortSelectableContacts(); // Initial sort

        // Initialize filtered contacts with all contacts
        _filteredContacts = [..._selectableContacts];
        _applyFiltersAndSort(); // Apply any active filters and sort options

        logger.i(
            "Successfully loaded ${_selectableContacts.length} contacts for selection.");
      } else {
        _errorMessage =
            result.errorMessage ?? "An unknown error occurred during import.";
        logger.e("Error loading contacts for import: $_errorMessage");
        // Optionally show a dialog or snackbar here
        _showErrorDialog(_errorMessage!);
      }
    });
  }

  // Sort contacts alphabetically for display
  void _sortSelectableContacts() {
    _selectableContacts.sort((a, b) {
      // Prioritize display name for sorting
      int comp = a.contact.displayName.compareTo(b.contact.displayName);
      return comp;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _toggleSelectAll(bool? newValue) {
    if (newValue == null) return;
    setState(() {
      _isSelectAll = newValue;
      for (var item in _selectableContacts) {
        item.isSelected = newValue;
        // Auto-select/clear phone/email when using Select All
        if (newValue) {
          // Auto-select first phone if available, otherwise null
          item.selectedPhone =
              item.contact.phones.isNotEmpty ? item.contact.phones.first : null;
          // Auto-select all emails if available
          item.selectedEmails = item.contact.emails.toList();
        } else {
          // Clear selections when deselecting all
          item.selectedPhone = null;
          item.selectedEmails.clear();
        }
      }
    });
  }

  // This function will be called when a contact row is tapped or expanded
  Future<void> _handlePhoneEmailSelection(
      ContactSelectionInfo selectionInfo) async {
    // Show the dialog
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return PhoneEmailSelectionDialog(
          contact: selectionInfo.contact,
          initialPhone: selectionInfo.selectedPhone,
          initialEmails: selectionInfo.selectedEmails,
          onSave: (chosenPhone, chosenEmails) {
            // Update the state of the specific item in the main list
            // This needs to be done *outside* the dialog's build context,
            // hence we do it here after the dialog closes and calls onSave.
            // Use setState from the main screen's state.
            if (mounted) {
              // Ensure the main screen is still mounted
              setState(() {
                selectionInfo.selectedPhone = chosenPhone;
                selectionInfo.selectedEmails = chosenEmails;
                // Ensure the item remains selected after editing details
                selectionInfo.isSelected = true;
                // Update _isSelectAll status
                _updateSelectAllState();
              });
            }
          },
        );
      },
    );
    // Optional: Refresh state if needed after dialog closes, though onSave handles it
    // setState(() {});
  }

  // Helper to update the Select All checkbox state based on item selections
  void _updateSelectAllState() {
    final allSelected = _selectableContacts.isNotEmpty &&
        _selectableContacts.every((i) => i.isSelected);
    if (_isSelectAll != allSelected) {
      setState(() {
        _isSelectAll = allSelected;
      });
    }
    // Note: We are not implementing tristate here for simplicity
  }

  // --- PHASE 4: Import Action ---
  Future<void> _triggerImport() async {
    if (!mounted) return;
    setState(() => _isSaving = true); // Show saving indicator

    final List<ContactSelectionInfo> contactsToImport =
        _selectableContacts.where((item) => item.isSelected).toList();

    if (contactsToImport.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No contacts selected.')),
      );
      setState(() => _isSaving = false);
      return;
    }

    try {
      // Get repositories and settings
      final contactRepo = context.read<ContactRepository>();
      final settingsRepo = context.read<UserSettingsRepository>();
      final List<app_contact.Contact> existingContacts =
          await contactRepo.getAll();
      final settings = await settingsRepo.getAll();
      final String defaultFrequency = settings.isNotEmpty
          ? settings.first.defaultFrequency
          : ContactFrequency.never.value;

      List<app_contact.Contact> contactsToAdd = [];
      List<String> skippedContactsLog = [];

      logger.i(
          "Starting import validation and mapping for ${contactsToImport.length} selected contacts.");

      for (final item in contactsToImport) {
        final fcContact = item.contact;
        bool isDuplicate = false;

        // --- 4.1 Duplicate Checking (Refined Logic) ---
        // Use the selected phone and emails from ContactSelectionInfo
        final String? selectedPhoneNumber = item.selectedPhone?.number.trim();
        final List<String> selectedEmailAddresses =
            item.selectedEmails.map((e) => e.address.trim()).toList();

        // Check selected phone first
        if (selectedPhoneNumber != null && selectedPhoneNumber.isNotEmpty) {
          if (existingContacts
              .any((c) => c.phoneNumber == selectedPhoneNumber)) {
            isDuplicate = true;
          }
        }
        // Check selected emails only if not already found duplicate by phone
        if (!isDuplicate && selectedEmailAddresses.isNotEmpty) {
          if (existingContacts.any((c) {
            // Check if any of the selected emails exist in the contact's email list
            return selectedEmailAddresses.any(
                (selectedEmail) => c.emails?.contains(selectedEmail) ?? false);
          })) {
            isDuplicate = true;
          }
        }
        if (isDuplicate) {
          logger.i(
              "Skipping duplicate: ${fcContact.displayName} (Selected Phone: $selectedPhoneNumber, Selected Emails: ${selectedEmailAddresses.join(', ')})");
          skippedContactsLog.add(fcContact.displayName);
          continue;
        }

        // --- 4.2 Data Mapping (Refined Logic) ---
        // Use selected phone/emails from ContactSelectionInfo
        final String? mappedPhone = item.selectedPhone?.number;
        final List<String> mappedEmails =
            item.selectedEmails.map((e) => e.address).toList();

        // Ensure we have at least one identifier (the selected one) to save
        if ((mappedPhone == null || mappedPhone.isEmpty) &&
            mappedEmails.isEmpty) {
          logger.w(
              "Skipping ${fcContact.displayName}: No phone number or email address was selected for import.");
          skippedContactsLog
              .add("${fcContact.displayName} (No phone/email selected)");
          continue;
        }

        // Map Birthday/Anniversary
        DateTime? birthday;
        DateTime? anniversary;
        for (final event in fcContact.events) {
          try {
            final date = DateTime(event.year ?? 1900, event.month,
                event.day); // Use default year if missing
            if (event.label == fc.EventLabel.birthday) {
              birthday = date;
            } else if (event.label == fc.EventLabel.anniversary) {
              anniversary = date;
            }
          } catch (e) {
            logger.w(
                "Could not parse date for event (${event.label}) for ${fcContact.displayName}: $e");
          }
        }

        // Create the app's Contact object
        final appContact = app_contact.Contact(
          // id will be assigned by repository
          firstName: fcContact.name.first,
          lastName: fcContact.name.last,
          nickname:
              null, // TODO: Map nickname? Not directly available in fc.Contact.name
          phoneNumber: mappedPhone,
          emails: mappedEmails,
          birthday: birthday,
          anniversary: anniversary,
          frequency: defaultFrequency, // Assign default from settings
          notes: fcContact.notes.isNotEmpty
              ? fcContact.notes.first.note
              : null, // Use first note if exists
          // Map other fields if needed (youtube, instagram, facebook, snapchat)
          // youtubeUrl: fcContact.websites.firstWhereOrNull((w) => w.url.contains('youtube.com'))?.url,
          // instagramHandle: fcContact.socialMedias.firstWhereOrNull((s) => s.label == fc.SocialMediaLabel.instagram)?.userName,
          // facebookUrl: fcContact.websites.firstWhereOrNull((w) => w.url.contains('facebook.com'))?.url,
          // snapchatHandle: fcContact.socialMedias.firstWhereOrNull((s) => s.label == fc.SocialMediaLabel.snapchat)?.userName,
        );

        contactsToAdd.add(appContact);
      } // End loop

      // --- 4.3 Save Contacts ---
      int savedCount = 0;
      if (contactsToAdd.isNotEmpty) {
        final addedContacts = await contactRepo.addMany(contactsToAdd);
        savedCount = addedContacts.length;
        logger
            .i("Successfully saved $savedCount new contacts to the database.");
      } else {
        logger.i(
            "No new contacts to add after filtering duplicates/invalid entries.");
      }

      // --- 4.4 Provide Feedback & Refresh ---
      String message = "$savedCount contact(s) imported successfully.";
      if (skippedContactsLog.isNotEmpty) {
        message +=
            "\n${skippedContactsLog.length} contact(s) skipped (duplicates or missing phone/email): ${skippedContactsLog.join(', ')}";
      }

      if (!mounted) return; // Check before showing snackbar/navigating

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 4), // Longer duration for more info
        ),
      );

      // Refresh the main list
      context
          .read<ContactListBloc>()
          .add(const LoadContactsEvent());

      // Navigate back
      Navigator.of(context).pop();
    } catch (e, stackTrace) {
      logger.e("Error during contact import process: $e",
          stackTrace: stackTrace);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Import failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false); // Hide saving indicator
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading overlay if saving
    final bool showLoadingOverlay = _isLoading || _isSaving;
    final bool anyContactsSelected =
        _selectableContacts.any((item) => item.isSelected);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Contacts to Import'),
        actions: [
          // Select All Checkbox
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                const Text("All"),
                Checkbox(
                  value: _isSelectAll,
                  onChanged: _isLoading ? null : _toggleSelectAll,
                  // tristate: true, // Consider tristate if partial selection indication is needed
                ),
              ],
            ),
          ),
        ],
      ),
      body: showLoadingOverlay
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Error: $_errorMessage')))
              : _selectableContacts.isEmpty
                  ? const Center(child: Text('No contacts found on device.'))
                  : Column(children: [
                      // Search Bar
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search contacts...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 0.0),
                            isDense: true,
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                    },
                                  )
                                : null,
                          ),
                        ),
                      ),

                      // Sort and Filter Controls
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            // Sort Dropdown
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: DropdownButton<SortOption>(
                                value: _currentSortOption,
                                underline: Container(), // Remove underline
                                icon: const Icon(Icons.sort),
                                hint: const Text('Sort by'),
                                items: [
                                  const DropdownMenuItem(
                                    value: SortOption.firstNameAsc,
                                    child: Text('First Name (A-Z)'),
                                  ),
                                  const DropdownMenuItem(
                                    value: SortOption.firstNameDesc,
                                    child: Text('First Name (Z-A)'),
                                  ),
                                  const DropdownMenuItem(
                                    value: SortOption.lastNameAsc,
                                    child: Text('Last Name (A-Z)'),
                                  ),
                                  const DropdownMenuItem(
                                    value: SortOption.lastNameDesc,
                                    child: Text('Last Name (Z-A)'),
                                  ),
                                  const DropdownMenuItem(
                                    value: SortOption.withPhone,
                                    child: Text('Has Phone'),
                                  ),
                                  const DropdownMenuItem(
                                    value: SortOption.withEmail,
                                    child: Text('Has Email'),
                                  ),
                                ],
                                onChanged: (SortOption? value) {
                                  if (value != null) {
                                    _changeSortOption(value);
                                  }
                                },
                              ),
                            ),

                            const SizedBox(width: 8),

                            // Filter Chip for Phone
                            FilterChip(
                              label: const Text('Has Phone'),
                              selected: _showOnlyWithPhone,
                              onSelected: _togglePhoneFilter,
                              avatar: Icon(
                                Icons.phone,
                                size: 18,
                                color: _showOnlyWithPhone ? Colors.white : null,
                              ),
                              showCheckmark: false,
                            ),

                            const SizedBox(width: 8),

                            // Filter Chip for Email
                            FilterChip(
                              label: const Text('Has Email'),
                              selected: _showOnlyWithEmail,
                              onSelected: _toggleEmailFilter,
                              avatar: Icon(
                                Icons.email,
                                size: 18,
                                color: _showOnlyWithEmail ? Colors.white : null,
                              ),
                              showCheckmark: false,
                            ),

                            const SizedBox(width: 8),
                            const SizedBox(width: 8),

                            // Info chip showing result count
                            Chip(
                              label:
                                  Text('${_filteredContacts.length} contacts'),
                              backgroundColor: Colors.grey.shade200,
                            ),
                          ],
                        ),
                      ),

                      // Contact List (Expanded to fill remaining space)
                      Expanded(
                        child: _filteredContacts.isEmpty
                            ? const Center(
                                child: Text(
                                    'No contacts match your search or filters.'),
                              )
                            : ListView.builder(
                                itemCount: _filteredContacts.length,
                                itemBuilder: (context, index) {
                                  final item = _filteredContacts[index];
                                  // Determine if editing is needed
                                  bool needsEditing =
                                      item.contact.phones.length > 1 ||
                                          item.contact.emails.isNotEmpty;

                                  return CheckboxListTile(
                                    title: Text(item.contact.displayName),
                                    // Update subtitle to show selection status
                                    subtitle: Text(item.isSelected
                                        ? 'Phone: ${item.selectedPhone?.number ?? "None"} / Emails: ${item.selectedEmails.length}'
                                        : (item.contact.phones.isNotEmpty
                                            ? item.contact.phones.first.number
                                            : (item.contact.emails.isNotEmpty
                                                ? item.contact.emails.first
                                                    .address
                                                : 'No phone/email'))),
                                    value: item.isSelected,
                                    onChanged: (bool? newValue) {
                                      if (newValue == null) return;
                                      setState(() {
                                        item.isSelected = newValue;
                                        if (newValue) {
                                          // If requires selection OR no phone/email pre-selected, show dialog
                                          if (needsEditing ||
                                              (item.selectedPhone == null &&
                                                  item.selectedEmails
                                                      .isEmpty)) {
                                            _handlePhoneEmailSelection(
                                                item); // Trigger dialog
                                          } else if (item.selectedPhone ==
                                                  null &&
                                              item.contact.phones.isNotEmpty) {
                                            // Auto-select first phone if none selected yet & available
                                            item.selectedPhone =
                                                item.contact.phones.first;
                                          } // (Emails are handled in dialog or select all)
                                        } else {
                                          // Clear selections if unchecked
                                          item.selectedPhone = null;
                                          item.selectedEmails.clear();
                                        }
                                        _updateSelectAllState(); // Update Select All checkbox
                                      });
                                    },
                                    // Show edit button if needed and not saving
                                    secondary: (needsEditing && !_isSaving)
                                        ? IconButton(
                                            icon: const Icon(Icons.edit_note),
                                            tooltip: 'Select phone/email',
                                            onPressed: () =>
                                                _handlePhoneEmailSelection(
                                                    item),
                                          )
                                        : null,
                                  );
                                },
                              ),
                      ),
                    ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (_isLoading || _isSaving || !anyContactsSelected)
            ? null // Disable if loading, saving, or nothing selected
            : _triggerImport,
        label: const Text('Import Selected'),
        icon: _isSaving
            ? Container(
                // Show spinner when saving
                width: 24,
                height: 24,
                padding: const EdgeInsets.all(2.0),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : const Icon(Icons.download_done), // Import icon
        // Disable button visually when needed
        backgroundColor: (_isLoading || _isSaving || !anyContactsSelected)
            ? Colors.grey
            : null,
      ),
    );
  }

  // Apply search, filters, and sort to contacts
  void _applyFiltersAndSort() {
    setState(() {
      _filteredContacts = _selectableContacts.where((item) {
        // Apply search query
        if (_searchQuery.isNotEmpty) {
          return item.contact.displayName
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
        }
        return true;
      }).where((item) {
        // Apply phone filter
        if (_showOnlyWithPhone && item.contact.phones.isEmpty) {
          return false;
        }
        // Apply email filter
        if (_showOnlyWithEmail && item.contact.emails.isEmpty) {
          return false;
        }
        return true;
      }).toList();

      // Apply sort
      _sortFilteredContacts();
    });
  }

  // Apply sorting to filtered contacts based on current sort option
  void _sortFilteredContacts() {
    switch (_currentSortOption) {
      case SortOption.firstNameAsc:
        _filteredContacts.sort((a, b) => a.contact.name.first
            .toLowerCase()
            .compareTo(b.contact.name.first.toLowerCase()));
        break;
      case SortOption.firstNameDesc:
        _filteredContacts.sort((a, b) => b.contact.name.first
            .toLowerCase()
            .compareTo(a.contact.name.first.toLowerCase()));
        break;
      case SortOption.lastNameAsc:
        _filteredContacts.sort((a, b) => a.contact.name.last
            .toLowerCase()
            .compareTo(b.contact.name.last.toLowerCase()));
        break;
      case SortOption.lastNameDesc:
        _filteredContacts.sort((a, b) => b.contact.name.last
            .toLowerCase()
            .compareTo(a.contact.name.last.toLowerCase()));
        break;
      case SortOption.withPhone:
        _filteredContacts.sort((a, b) {
          if (a.contact.phones.isNotEmpty && b.contact.phones.isEmpty) {
            return -1;
          } else if (a.contact.phones.isEmpty && b.contact.phones.isNotEmpty) {
            return 1;
          } else {
            // Secondary sort by first name
            return a.contact.name.first
                .toLowerCase()
                .compareTo(b.contact.name.first.toLowerCase());
          }
        });
        break;
      case SortOption.withEmail:
        _filteredContacts.sort((a, b) {
          if (a.contact.emails.isNotEmpty && b.contact.emails.isEmpty) {
            return -1;
          } else if (a.contact.emails.isEmpty && b.contact.emails.isNotEmpty) {
            return 1;
          } else {
            // Secondary sort by first name
            return a.contact.name.first
                .toLowerCase()
                .compareTo(b.contact.name.first.toLowerCase());
          }
        });
        break;
    }
  }

  // Change the sort option and reapply sorting
  void _changeSortOption(SortOption option) {
    setState(() {
      _currentSortOption = option;
      _sortFilteredContacts();
    });
  }

  // Toggle filter options
  void _togglePhoneFilter(bool value) {
    setState(() {
      _showOnlyWithPhone = value;
      _applyFiltersAndSort();
    });
  }

  void _toggleEmailFilter(bool value) {
    setState(() {
      _showOnlyWithEmail = value;
      _applyFiltersAndSort();
    });
  }
}
