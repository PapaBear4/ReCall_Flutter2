// lib/services/contact_importer.dart
import 'package:flutter_contacts/flutter_contacts.dart'
    as fc; // Use prefix 'fc'
import 'package:permission_handler/permission_handler.dart';
import 'package:recall/utils/logger.dart'; // Your logger

//-------------------- RESULT TYPES --------------------
// Define a result type for clarity
enum ContactImportResultStatus {
  success,
  permissionDenied,
  errorFetching,
  unknownError
}

class ContactImportResult {
  final ContactImportResultStatus status;
  final List<fc.Contact> contacts; // Use the type from flutter_contacts
  final String? errorMessage;

  ContactImportResult({
    required this.status,
    this.contacts = const [], // Default to empty list
    this.errorMessage,
  });
}

//-------------------- CONTACT IMPORTER SERVICE --------------------
class ContactImporter {
  /// Fetches and filters contacts from the device.
  /// Handles permission requests.
  Future<ContactImportResult> fetchAndFilterDeviceContacts() async {
    logger.i("Starting contact import process...");

    //-------------------- PERMISSION HANDLING --------------------
    PermissionStatus status = await Permission.contacts.status;
    logger.i("Initial contacts permission status: $status");

    if (status.isDenied) {
      status = await Permission.contacts.request();
      logger.i("Contacts permission status after request: $status");
    }

    if (status.isPermanentlyDenied) {
      logger.w("Contacts permission permanently denied.");
      // Consider showing a dialog guiding user to settings
      // For now, return failure
      return ContactImportResult(
          status: ContactImportResultStatus.permissionDenied,
          errorMessage:
              'Contacts permission permanently denied. Please enable in settings.');
    }

    if (!status.isGranted) {
      logger.w("Contacts permission was not granted.");
      return ContactImportResult(
          status: ContactImportResultStatus.permissionDenied,
          errorMessage: 'Contacts permission denied.');
    }

    //-------------------- CONTACT FETCHING --------------------
    logger.i("Contacts permission granted. Fetching contacts...");
    List<fc.Contact> deviceContacts = [];
    try {
      // Fetch contacts with properties needed for filtering and later mapping
      // (phones, emails, name components)
      // Note: fetching thumbnails might be slow, skip if not needed initially
      deviceContacts = await fc.FlutterContacts.getContacts(
        withProperties: true, // Fetches phones, emails, addresses etc.
        withPhoto: false, // Exclude photo for faster fetching initially
        // Consider adding withThumbnail: false if performance is an issue
      );
      logger.i("Fetched ${deviceContacts.length} contacts from device.");
    } catch (e) {
      logger.e("Error fetching contacts: $e");
      return ContactImportResult(
          status: ContactImportResultStatus.errorFetching,
          errorMessage: "Error fetching contacts: $e");
    }

    //-------------------- CONTACT FILTERING --------------------
    // Filter out contacts that have a company name but empty first/last names
    final originalCount = deviceContacts.length;
    List<fc.Contact> filteredContacts = deviceContacts.where((contact) {
      // Check if organization details exist and company name is not empty
      final bool hasCompany = contact.organizations.isNotEmpty &&
          (contact.organizations.first.company.isNotEmpty);
      // Check if first and last names are both empty or null
      final bool nameIsEmpty =
          (contact.name.first.isEmpty) && (contact.name.last.isEmpty);

      // Keep the contact if it DOES NOT match the filter criteria
      // (i.e., keep if it doesn't have a company OR if the name is NOT empty)
      final bool shouldRemove = hasCompany && nameIsEmpty;

      if (shouldRemove) {
        logger.d(
            "Filtering out business contact: ${contact.displayName} (Company: ${contact.organizations.first.company})");
      }
      return !shouldRemove; // Keep if not marked for removal
    }).toList();

    final filteredCount = filteredContacts.length;
    if (originalCount != filteredCount) {
      logger.i(
          "Filtered out ${originalCount - filteredCount} business-only contacts.");
    } else {
      logger.i("No business-only contacts needed filtering.");
    }

    //-------------------- RETURN RESULT --------------------
    logger.i(
        "Contact fetching and filtering complete. Returning ${filteredContacts.length} contacts.");
    return ContactImportResult(
      status: ContactImportResultStatus.success,
      contacts: filteredContacts, // Return the filtered list
    );
  }
}
