import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:recall/utils/logger.dart';

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
}
