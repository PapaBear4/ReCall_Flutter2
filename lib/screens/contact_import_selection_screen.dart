// lib/screens/contact_import_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Bloc
import 'package:flutter_contacts/flutter_contacts.dart' as fc; // Use prefix
import 'package:recall/models/contact_frequency.dart';
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

class _ContactImportSelectionScreenState
    extends State<ContactImportSelectionScreen> {
  final ContactImporter _importer = ContactImporter();
  bool _isLoading = true;
  bool _isSaving = false; // Specific loading for import process
  String? _errorMessage;
  List<ContactSelectionInfo> _selectableContacts =
      []; // Holds contacts and their selection state
  bool _isSelectAll = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _selectableContacts = []; // Clear previous list
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
        // Reset phone/email choices when deselecting all
        if (!newValue) {
          item.selectedPhone = null;
          item.selectedEmails.clear();
        }
        // TODO: Auto-select default phone/email if selecting all? (Optional enhancement)
      }
    });
  }

  // --- Placeholder for Phase 3.3: Phone/Email Selection ---
  // This function will be called when a contact row is tapped or expanded
  void _handlePhoneEmailSelection(ContactSelectionInfo selectionInfo) {
    // TODO: Implement UI (e.g., showDialog) to select one phone and multiple emails
    // from selectionInfo.contact.phones and selectionInfo.contact.emails.
    // Update selectionInfo.selectedPhone and selectionInfo.selectedEmails based on user choice.
    // This needs careful implementation using Radio buttons for phone, Checkboxes for email.
    logger.i(
        "TODO: Implement phone/email selection UI for ${selectionInfo.contact.displayName}");

    // Example (Conceptual - requires a dialog widget):
    /*
     showDialog(context: context, builder: (context) => PhoneEmailSelectionDialog(
         contact: selectionInfo.contact,
         initialPhone: selectionInfo.selectedPhone,
         initialEmails: selectionInfo.selectedEmails,
         onSave: (chosenPhone, chosenEmails) {
             setState(() {
                 selectionInfo.selectedPhone = chosenPhone;
                 selectionInfo.selectedEmails = chosenEmails;
             });
         }
     ));
     */

    // For now, let's just print available phones/emails
    logger.i("Available Phones for ${selectionInfo.contact.displayName}:");
    for (var phone in selectionInfo.contact.phones) {
      logger.i("- ${phone.label}: ${phone.number}");
    }
    logger.i("Available Emails for ${selectionInfo.contact.displayName}:");
    for (var email in selectionInfo.contact.emails) {
      logger.i("- ${email.label}: ${email.address}");
    }
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

        // --- 4.1 Duplicate Checking (Placeholder Logic) ---
        // TODO: Refine duplicate check using item.selectedPhone?.number and item.selectedEmails
        final String? firstDevicePhone =
            fcContact.phones.firstOrNull?.number.trim();
        final String? firstDeviceEmail =
            fcContact.emails.firstOrNull?.address.trim();

        if (firstDevicePhone != null && firstDevicePhone.isNotEmpty) {
          if (existingContacts.any((c) => c.phoneNumber == firstDevicePhone)) {
            isDuplicate = true;
          }
        }
        // Check email only if not already found duplicate by phone
        if (!isDuplicate &&
            firstDeviceEmail != null &&
            firstDeviceEmail.isNotEmpty) {
          if (existingContacts
              .any((c) => c.emails?.contains(firstDeviceEmail) ?? false)) {
            isDuplicate = true;
          }
        }

        if (isDuplicate) {
          logger.i(
              "Skipping duplicate: ${fcContact.displayName} (Phone: $firstDevicePhone, Email: $firstDeviceEmail)");
          skippedContactsLog.add(fcContact.displayName);
          continue; // Skip to the next contact
        }

        // --- 4.2 Data Mapping ---
        // TODO: Refine phone/email mapping using item.selectedPhone and item.selectedEmails from Phase 3.3 UI
        final String? mappedPhone = fcContact
            .phones.firstOrNull?.number; // Placeholder: uses first phone
        final List<String> mappedEmails = fcContact.emails
            .map((e) => e.address)
            .toList(); // Placeholder: uses all emails

        // Ensure we have at least one identifier (phone or email) to save
        if ((mappedPhone == null || mappedPhone.isEmpty) &&
            mappedEmails.isEmpty) {
          logger.w(
              "Skipping ${fcContact.displayName}: No phone number or email address found after mapping.");
          skippedContactsLog.add("${fcContact.displayName} (No phone/email)");
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

        // Map Social Media Handles / Links
        // TODO: These mappings might need adjustments based on exact labels used by flutter_contacts
        String? xHandle;
        String? linkedInUrl;

        // Look in SocialMedia first (case-insensitive check for label)
        for (final social in fcContact.socialMedias) {
          final labelLower = social.label
              .toString()
              .toLowerCase(); // e.g., "socialmedialabel.twitter"
          if (labelLower.contains('twitter')) {
            xHandle = social.userName;
          } else if (labelLower.contains('linkedin')) {
            // SocialMedia typically stores username, Website stores URL
            // Maybe store username if URL isn't found in websites?
            // linkedInUrl = social.userName; // Less likely to be the URL
          }
        }
        // Look in Websites for LinkedIn URL
        for (final website in fcContact.websites) {
          final labelLower = website.label
              .toString()
              .toLowerCase(); // e.g., "websitelabel.linkedin"
          final urlLower = website.url.toLowerCase();
          if (labelLower.contains('linkedin') ||
              urlLower.contains('linkedin.com')) {
            linkedInUrl = website.url;
            break; // Found one, stop looking in websites
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
          xHandle: xHandle,
          linkedInUrl: linkedInUrl,
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
          .add(const ContactListEvent.loadContacts());

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
                  : ListView.builder(
                      itemCount: _selectableContacts.length,
                      itemBuilder: (context, index) {
                        final item = _selectableContacts[index];
                        // Basic display - needs refinement for phone/email choice
                        return CheckboxListTile(
                          title: Text(item.contact.displayName),
                          // Subtitle can show primary phone/email if available
                          subtitle: Text(item.contact.phones.isNotEmpty
                              ? item.contact.phones.first.number
                              : item.contact.emails.isNotEmpty
                                  ? item.contact.emails.first.address
                                  : 'No phone/email'),
                          value: item.isSelected,
                          onChanged: (bool? newValue) {
                            if (newValue == null) return;
                            setState(() {
                              item.isSelected = newValue;
                              // If newly selected, trigger phone/email choice logic (placeholder)
                              if (newValue) {
                                // Check if selection is needed
                                bool needsPhoneSelection =
                                    item.contact.phones.length > 1;
                                bool needsEmailSelection = item.contact.emails
                                    .isNotEmpty; // Always allow email multi-select if emails exist
                                if (needsPhoneSelection ||
                                    needsEmailSelection) {
                                  _handlePhoneEmailSelection(item);
                                } else {
                                  // Auto-select if only one or zero phone/email
                                  item.selectedPhone =
                                      item.contact.phones.isEmpty
                                          ? null
                                          : item.contact.phones.first;
                                  item.selectedEmails = item.contact.emails
                                      .toList(); // Select all emails if not choosing
                                }
                              } else {
                                // Clear selections if unchecked
                                item.selectedPhone = null;
                                item.selectedEmails.clear();
                              }

                              // Update Select All checkbox state
                              if (_selectableContacts
                                  .every((i) => i.isSelected)) {
                                _isSelectAll = true;
                              } else {
                                _isSelectAll = false;
                              }
                              // TODO: Implement tristate for _isSelectAll if desired
                            });
                          },
                          // Add a button/indicator if multiple phone/email need selection
                          secondary: (_isSaving ||
                                  (item.contact.phones.length <= 1 &&
                                      item.contact.emails.length <= 1))
                              ? null
                              : IconButton(
                                  icon: const Icon(
                                      Icons.edit_note), // Or Icons.more_vert
                                  tooltip: 'Select phone/email',
                                  onPressed: () =>
                                      _handlePhoneEmailSelection(item),
                                ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (showLoadingOverlay ||
                _selectableContacts.where((i) => i.isSelected).isEmpty)
            ? null // Disable if loading or nothing selected
            : _triggerImport,
        icon: const Icon(Icons.download),
        label: Text(_isSaving
            ? 'Importing...'
            : 'Import Selected (${_selectableContacts.where((i) => i.isSelected).length})'),
      ),
    );
  }
}
