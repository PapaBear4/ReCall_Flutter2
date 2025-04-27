import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/utils/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'common_components.dart';

/// Displays contact's basic information in view mode
class BasicInfoViewSection extends StatelessWidget {
  final Contact contact;
  final MaskTextInputFormatter phoneMaskFormatter;
  final Function(String) showPhoneActions;
  final Function(Uri) launchUniversalLink;
  final String Function(String) sanitizePhoneNumber;

  const BasicInfoViewSection({
    super.key, 
    required this.contact,
    required this.phoneMaskFormatter,
    required this.showPhoneActions,
    required this.launchUniversalLink,
    required this.sanitizePhoneNumber
  });

  @override
  Widget build(BuildContext context) {
    // Format phone number for display
    String formattedPhoneNumber = 'Not set';
    String unmaskedPhoneNumber = '';
    
    if (contact.phoneNumber != null && contact.phoneNumber!.isNotEmpty) {
      unmaskedPhoneNumber = contact.phoneNumber!;
      try {
        formattedPhoneNumber = phoneMaskFormatter.maskText(unmaskedPhoneNumber);
      } catch (e) {
        formattedPhoneNumber = unmaskedPhoneNumber; // Fallback if formatting fails
        logger.e("Error masking phone for display: $e");
      }
    }
    
    // Determine display name based on nickname availability
    final String nameDisplay =
      (contact.nickname != null && contact.nickname!.isNotEmpty)
          ? contact.nickname!
          : '${contact.firstName} ${contact.lastName}';
    final String fullNameDisplay =
      '${contact.firstName} ${contact.lastName}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display name (nickname or full name)
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            nameDisplay,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        
        // Show full name in parenthesis if nickname is shown above
        if (contact.nickname != null && contact.nickname!.isNotEmpty)
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

        // Phone with actions
        ActionableDetailRow(
          icon: Icons.phone_outlined,
          label: 'Phone:',
          value: formattedPhoneNumber,
          onTap: unmaskedPhoneNumber.isNotEmpty
              ? () => showPhoneActions(unmaskedPhoneNumber)
              : null,
          actions: unmaskedPhoneNumber.isNotEmpty
              ? [
                  // SMS action button
                  IconButton(
                    icon: const Icon(Icons.message),
                    tooltip: 'Send Message',
                    onPressed: () => launchUniversalLink(
                        Uri.parse('sms:${sanitizePhoneNumber(unmaskedPhoneNumber)}')),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                  // Call action button
                  IconButton(
                    icon: const Icon(Icons.call),
                    tooltip: 'Call',
                    onPressed: () => launchUniversalLink(
                        Uri.parse('tel:${sanitizePhoneNumber(unmaskedPhoneNumber)}')),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                ]
              : [],
        ),
      ],
    );
  }
}

/// Editable form fields for contact's basic information
class BasicInfoEditSection extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController nicknameController;
  final TextEditingController phoneController;
  final MaskTextInputFormatter phoneMaskFormatter;
  final Function(String) onFirstNameChanged;
  final Function(String) onLastNameChanged;
  final Function(String) onNicknameChanged;
  final Function(String) onPhoneChanged;

  const BasicInfoEditSection({
    super.key, 
    required this.firstNameController, 
    required this.lastNameController, 
    required this.nicknameController, 
    required this.phoneController, 
    required this.phoneMaskFormatter, 
    required this.onFirstNameChanged, 
    required this.onLastNameChanged, 
    required this.onNicknameChanged, 
    required this.onPhoneChanged
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // First Name field (required)
        TextFormField(
          controller: firstNameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
              labelText: 'First Name', border: OutlineInputBorder()),
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Please enter a first name' : null,
          onChanged: onFirstNameChanged,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16.0),
        
        // Last Name field (required)
        TextFormField(
          controller: lastNameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
              labelText: 'Last Name', border: OutlineInputBorder()),
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Please enter a last name' : null,
          onChanged: onLastNameChanged,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16.0),
        
        // Nickname field (optional)
        TextFormField(
          controller: nicknameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
              labelText: 'Nickname (Optional)', border: OutlineInputBorder()),
          onChanged: onNicknameChanged,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16.0),
        
        // Phone number field with formatting
        TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          inputFormatters: [phoneMaskFormatter], // Apply phone number formatting
          decoration: const InputDecoration(
              labelText: 'Phone Number',
              hintText: '(123) 456-7890',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone)),
          onChanged: onPhoneChanged,
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }
}
