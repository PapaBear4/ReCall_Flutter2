// lib/screens/contact_import_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Bloc
import 'package:flutter_contacts/flutter_contacts.dart' as fc; // Use prefix
import 'package:recall/models/enums.dart';
import 'package:recall/repositories/contact_repository.dart'; // Import Contact Repo
import 'package:recall/repositories/usersettings_repository.dart'; // Import Settings Repo
import 'package:recall/services/contact_importer.dart';
import 'package:recall/utils/logger.dart';
import 'package:recall/models/contact.dart'
    as app_contact; // Alias for your app's Contact model
import 'package:go_router/go_router.dart';
import 'package:recall/utils/contact_utils.dart'; // Added for calculateNextContactDate

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
  // Store chosen phone/emails automatically
  fc.Phone? selectedPhone;
  List<fc.Email> selectedEmails = [];

  ContactSelectionInfo(this.contact, {this.isSelected = false});
}

// Sort options - aligned with Contact model properties
enum SortOption {
  firstNameAsc, // Sort by first name ascending
  firstNameDesc, // Sort by first name descending
  lastNameAsc, // Sort by last name ascending
  lastNameDesc // Sort by last name descending
}

class _ContactImportSelectionScreenState
    extends State<ContactImportSelectionScreen> with WidgetsBindingObserver {
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

  SortOption _currentSortOption = SortOption.lastNameAsc; // Changed default sort

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchContacts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      logger.i("App resumed, refreshing contacts list.");
      _fetchContacts();
    }
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _applyFiltersAndSortInternal(); // Changed call
    });
  }

  // Helper method to get the preferred phone number
  fc.Phone? _getPreferredPhone(fc.Contact contact) {
    if (contact.phones.isEmpty) return null;

    fc.Phone? mobilePhone;
    fc.Phone? homePhone;
    fc.Phone? workPhone;
    fc.Phone? otherPhone;

    for (final phone in contact.phones) {
      switch (phone.label) {
        case fc.PhoneLabel.mobile:
          mobilePhone ??= phone;
          break;
        case fc.PhoneLabel.home:
          homePhone ??= phone;
          break;
        case fc.PhoneLabel.work:
          workPhone ??= phone;
          break;
        case fc.PhoneLabel.other:
          otherPhone ??= phone;
          break;
        default: // For any other labels or custom ones
          otherPhone ??= phone; // Treat as 'other' or a fallback
          break;
      }
    }
    return mobilePhone ?? homePhone ?? workPhone ?? otherPhone ?? contact.phones.first;
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
        _sortSelectableContacts(); // Initial sort of master list

        // Apply filters and current sort option to the freshly loaded contacts
        _applyFiltersAndSortInternal(); // Changed call, populates and sorts _filteredContacts

        logger.i(
            "Successfully loaded ${_selectableContacts.length} contacts for selection.");
      } else {
        _errorMessage =
            result.errorMessage ?? "An unknown error occurred during import.";
        logger.e("Error loading contacts for import: $_errorMessage");
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
            onPressed: () => context.pop(),
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
        if (newValue) {
          // Auto-select preferred phone and all emails
          item.selectedPhone = _getPreferredPhone(item.contact);
          item.selectedEmails = item.contact.emails.toList();
        } else {
          // Clear selections when deselecting all
          item.selectedPhone = null;
          item.selectedEmails.clear();
        }
      }
      _applyFiltersAndSortInternal(); // Changed call
    });
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
          : ContactFrequency.biweekly.value;

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
        final DateTime now = DateTime.now();
        final app_contact.Contact tempContactForNextDateCalculation = app_contact.Contact(
          lastContactDate: now,
          frequency: defaultFrequency,
          // Other fields are not strictly necessary for calculateNextContactDate
          // but providing them if easily available won't hurt.
          firstName: fcContact.name.first, // Example, can be omitted if not needed by calc
          lastName: fcContact.name.last,  // Example, can be omitted if not needed by calc
        );

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
          lastContactDate: now, // Set lastContactDate to today
          nextContactDate: calculateNextContactDate(tempContactForNextDateCalculation), // Calculate nextContactDate
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
                                ],
                                onChanged: (SortOption? value) {
                                  if (value != null) {
                                    _changeSortOption(value);
                                  }
                                },
                              ),
                            ),

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
                            ? Center(
                                child: Text(_searchQuery.isNotEmpty
                                    ? 'No contacts match your search.'
                                    : 'No contacts to display.'))
                            : ListView.builder(
                                itemCount: _filteredContacts.length,
                                itemBuilder: (context, index) {
                                  final selectionInfo = _filteredContacts[index];

                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    child: ListTile(
                                      leading: Checkbox(
                                        value: selectionInfo.isSelected,
                                        onChanged: (bool? newValue) {
                                          if (newValue == null) return;
                                          setState(() {
                                            selectionInfo.isSelected = newValue;
                                            if (newValue) {
                                              selectionInfo.selectedPhone = _getPreferredPhone(selectionInfo.contact);
                                              selectionInfo.selectedEmails = selectionInfo.contact.emails.toList();
                                            } else {
                                              selectionInfo.selectedPhone = null;
                                              selectionInfo.selectedEmails.clear();
                                            }
                                            _updateSelectAllState();
                                          });
                                        },
                                      ),
                                      title: Text(
                                        selectionInfo.contact.displayName,
                                        style: TextStyle(fontSize: (Theme.of(context).textTheme.titleMedium?.fontSize ?? 16) * 1.4), // Increased font size
                                      ),
                                      subtitle: (selectionInfo.isSelected && (selectionInfo.selectedPhone != null || selectionInfo.selectedEmails.isNotEmpty)) ? 
                                        Text(
                                          "Ready to import", 
                                          style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                                        )
                                        : null,
                                      onTap: null, // Removed onTap from ListTile
                                      trailing: TextButton( // Added trailing Edit button
                                        child: const Text("Edit >"),
                                        onPressed: () async {
                                          try {
                                            // Open contact in native editor
                                            await fc.FlutterContacts.openExternalEdit(selectionInfo.contact.id);
                                            // Note: Refresh will happen on app resume via didChangeAppLifecycleState
                                          } catch (e) {
                                            logger.e("Error opening external contact editor: $e");
                                            if (mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Could not open contact: $e')),
                                              );
                                            }
                                          }
                                        },
                                      ),
                                    ),
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
  // Renamed from _applyFiltersAndSort and removed setState
  void _applyFiltersAndSortInternal() { 
    _filteredContacts = _selectableContacts.where((item) {
      // Apply search query
      if (_searchQuery.isNotEmpty) {
        return item.contact.displayName
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
      }
      return true;
    }).toList();

    // Apply sort
    _sortFilteredContacts(); // Sorts _filteredContacts in place
  }

  // Apply sorting to filtered contacts based on current sort option
  void _sortFilteredContacts() {
    switch (_currentSortOption) {
      case SortOption.firstNameAsc:
        _filteredContacts.sort((a, b) {
          final aFirstName = a.contact.name.first.toLowerCase();
          final bFirstName = b.contact.name.first.toLowerCase();
          int comparison = aFirstName.compareTo(bFirstName);
          if (comparison == 0) {
            final aLastName = a.contact.name.last.toLowerCase();
            final bLastName = b.contact.name.last.toLowerCase();
            comparison = aLastName.compareTo(bLastName);
            if (comparison == 0) {
              comparison = a.contact.displayName.toLowerCase().compareTo(b.contact.displayName.toLowerCase());
            }
          }
          return comparison;
        });
        break;
      case SortOption.firstNameDesc:
        _filteredContacts.sort((a, b) {
          final aFirstName = a.contact.name.first.toLowerCase();
          final bFirstName = b.contact.name.first.toLowerCase();
          int comparison = bFirstName.compareTo(aFirstName); // Swapped for descending
          if (comparison == 0) {
            final aLastName = a.contact.name.last.toLowerCase();
            final bLastName = b.contact.name.last.toLowerCase();
            comparison = bLastName.compareTo(aLastName); // Swapped for descending
            if (comparison == 0) {
              comparison = b.contact.displayName.toLowerCase().compareTo(a.contact.displayName.toLowerCase());
            }
          }
          return comparison;
        });
        break;
      case SortOption.lastNameAsc:
        _filteredContacts.sort((a, b) {
          final aLastName = a.contact.name.last.toLowerCase();
          final bLastName = b.contact.name.last.toLowerCase();
          int comparison = aLastName.compareTo(bLastName);
          if (comparison == 0) {
            final aFirstName = a.contact.name.first.toLowerCase();
            final bFirstName = b.contact.name.first.toLowerCase();
            comparison = aFirstName.compareTo(bFirstName);
            if (comparison == 0) {
              comparison = a.contact.displayName.toLowerCase().compareTo(b.contact.displayName.toLowerCase());
            }
          }
          return comparison;
        });
        break;
      case SortOption.lastNameDesc:
        _filteredContacts.sort((a, b) {
          final aLastName = a.contact.name.last.toLowerCase();
          final bLastName = b.contact.name.last.toLowerCase();
          int comparison = bLastName.compareTo(aLastName); // Swapped for descending
          if (comparison == 0) {
            final aFirstName = a.contact.name.first.toLowerCase();
            final bFirstName = b.contact.name.first.toLowerCase();
            comparison = bFirstName.compareTo(aFirstName); // Swapped for descending
            if (comparison == 0) {
              comparison = b.contact.displayName.toLowerCase().compareTo(a.contact.displayName.toLowerCase());
            }
          }
          return comparison;
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
}
