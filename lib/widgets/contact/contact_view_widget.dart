import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/utils/last_contacted_utils.dart';
import 'package:recall/utils/logger.dart';
import 'package:recall/widgets/contact/contact_field.dart';
import 'package:recall/widgets/contact/email_list_widget.dart';

class ContactViewWidget extends StatelessWidget {
  final Contact contact;
  final MaskTextInputFormatter phoneMaskFormatter;
  final Function(String) onPhoneActionTap;
  final Function(String) onEmailTap;
  
  const ContactViewWidget({
    Key? key,
    required this.contact,
    required this.phoneMaskFormatter,
    required this.onPhoneActionTap,
    required this.onEmailTap,
  }) : super(key: key);

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
        formattedPhoneNumber = unmaskedPhoneNumber;
        logger.e("Error masking phone for display: $e");
      }
    }

    // Determine name display based on nickname
    final String nameDisplay = (contact.nickname != null && contact.nickname!.isNotEmpty)
        ? contact.nickname!
        : '${contact.firstName} ${contact.lastName}';
    final String fullNameDisplay = '${contact.firstName} ${contact.lastName}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name display
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            nameDisplay,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        
        // Show full name if nickname was displayed
        if (contact.nickname != null && contact.nickname!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              '($fullNameDisplay)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
          )
        else
          const SizedBox(height: 24.0),

        // Status indicator
        ContactField(
          icon: contact.isActive ? Icons.check_circle : Icons.cancel,
          label: 'Status:',
          value: contact.isActive ? 'Active' : 'Inactive',
          textColor: contact.isActive ? Colors.green : Colors.red,
        ),

        // Basic info section
        ContactField(
          icon: Icons.cake_outlined,
          label: 'Birthday:',
          value: contact.birthday == null ? 'Not set' : DateFormat.yMd().format(contact.birthday!),
        ),
        
        ContactField(
          icon: Icons.celebration_outlined,
          label: 'Anniversary:',
          value: contact.anniversary == null ? 'Not set' : DateFormat.yMd().format(contact.anniversary!),
        ),
        
        ContactField(
          icon: Icons.access_time,
          label: 'Last Contacted:',
          value: formatLastContacted(contact.lastContacted),
        ),
        
        ContactField(
          icon: Icons.repeat,
          label: 'Frequency:',
          value: contact.frequency,
        ),
        
        ContactField(
          icon: Icons.next_plan_outlined,
          label: 'Next Due:',
          value: calculateNextDueDateDisplay(contact.lastContacted, contact.frequency),
        ),

        const Divider(height: 24.0),

        // Phone with actions
        ContactField(
          icon: Icons.phone_outlined,
          label: 'Phone:',
          value: formattedPhoneNumber,
          onTap: unmaskedPhoneNumber.isNotEmpty ? () => onPhoneActionTap(unmaskedPhoneNumber) : null,
          actions: unmaskedPhoneNumber.isNotEmpty
              ? [
                  IconButton(
                    icon: const Icon(Icons.message),
                    tooltip: 'Send Message',
                    onPressed: () => onPhoneActionTap(unmaskedPhoneNumber),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                  IconButton(
                    icon: const Icon(Icons.call),
                    tooltip: 'Call',
                    onPressed: () => onPhoneActionTap(unmaskedPhoneNumber),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                ]
              : [],
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
                child: Text('Emails:', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: EmailListWidget(
                  emails: contact.emails,
                  isEditMode: false,
                  controllers: const [], // Not used in view mode
                  onEmailsChanged: (_) {}, // Not used in view mode
                  onEmailTap: onEmailTap,
                ),
              ),
            ],
          ),
        ),

        // Notes
        ContactField(
          icon: Icons.notes_outlined,
          label: 'Notes:',
          value: contact.notes ?? 'Not set',
        ),

        const Divider(height: 24.0),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
