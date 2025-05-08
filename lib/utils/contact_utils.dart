import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:recall/utils/logger.dart';
import 'package:recall/models/contact.dart' as app_contact;
import 'package:flutter_contacts/flutter_contacts.dart' as fc;

/// Contact-related utility functions
class ContactUtils {
  /// Clean a phone number by removing all non-digit characters
  static String sanitizePhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
  }

  /// Launch a URL with error handling
  static Future<void> launchUniversalLink(BuildContext context, Uri url) async {
    try {
      final bool canLaunch = await canLaunchUrl(url);
      
      // Check if widget is still in the tree
      if (!context.mounted) return;

      if (canLaunch) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch $url')),
          );
        }
        logger.w('Could not launch $url');
      }
    } catch (e) {
      if (!context.mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching link: $e')),
      );
      logger.e('Error launching link: $e');
    }
  }

  /// Create a phone call URI
  static Uri createPhoneUri(String phoneNumber) {
    final String cleanPhoneNumber = sanitizePhoneNumber(phoneNumber);
    return Uri.parse('tel:$cleanPhoneNumber');
  }

  /// Create an SMS URI
  static Uri createSmsUri(String phoneNumber) {
    final String cleanPhoneNumber = sanitizePhoneNumber(phoneNumber);
    return Uri.parse('sms:$cleanPhoneNumber');
  }

  /// Create an email URI
  static Uri createEmailUri(String email) {
    return Uri.parse('mailto:$email');
  }

  /// Maps a FlutterContacts Contact to the app's Contact model.
  static app_contact.Contact mapContactDeviceToApp(fc.Contact fcContact, String defaultFrequency) {
    // Map phone numbers
    final String? phoneNumber = fcContact.phones.isNotEmpty
        ? fcContact.phones.first.number.trim()
        : null;

    // Map emails
    final List<String> emails = fcContact.emails
        .map((email) => email.address.trim())
        .toList();

    // Map birthday and anniversary
    DateTime? birthday;
    DateTime? anniversary;
    for (final event in fcContact.events) {
      try {
        final date = DateTime(event.year ?? 1900, event.month, event.day);
        if (event.label == fc.EventLabel.birthday) {
          birthday = date;
        } else if (event.label == fc.EventLabel.anniversary) {
          anniversary = date;
        }
      } catch (e) {
        logger.w("Could not parse date for event (${event.label}): $e");
      }
    }

    // Map notes
    final String? notes = fcContact.notes.isNotEmpty
        ? fcContact.notes.first.note
        : null;

    // Create and return the app's Contact model
    return app_contact.Contact(
      firstName: fcContact.name.first,
      lastName: fcContact.name.last,
      nickname: fcContact.name.nickname,
      phoneNumber: phoneNumber,
      emails: emails,
      birthday: birthday,
      anniversary: anniversary,
      frequency: defaultFrequency,
      notes: notes,
      isActive: true,
    );
  }
}
