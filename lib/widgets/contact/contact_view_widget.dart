import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/utils/contact_utils.dart';
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

    final String nameDisplay;
    String? subNameDisplay;

    if (contact.nickname != null && contact.nickname!.isNotEmpty) {
      nameDisplay = '${contact.nickname} ${contact.lastName}';
      subNameDisplay = '(${contact.firstName})';
    } else {
      nameDisplay = '${contact.firstName} ${contact.lastName}';
    }

    List<Widget> dateChips = [];
    if (contact.birthday != null) {
      dateChips.add(Chip(
        avatar: const Icon(Icons.cake_outlined, size: 18),
        label: Text('B: ${DateFormat.yMd().format(contact.birthday!)}'),
      ));
    }
    if (contact.anniversary != null) {
      if (dateChips.isNotEmpty) {
        dateChips.add(const SizedBox(width: 8));
      }
      dateChips.add(Chip(
        avatar: const Icon(Icons.celebration_outlined, size: 18),
        label: Text('A: ${DateFormat.yMd().format(contact.anniversary!)}'),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name display
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            nameDisplay,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),

        if (subNameDisplay != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
              subNameDisplay,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.grey[600]),
            ),
          )
        else
          const SizedBox(height: 4.0), // Minimal spacing if no sub-name

        // Date Chips
        if (dateChips.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: dateChips,
            ),
          ),

        const Divider(height: 24.0),

        // Phone with actions
        ContactField(
          icon: Icons.phone_outlined,
          label: 'Phone:',
          value: formattedPhoneNumber,
          onTap: unmaskedPhoneNumber.isNotEmpty
              ? () => onPhoneActionTap(unmaskedPhoneNumber)
              : null,
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
                child: Text('Emails:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
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

        // Frequency based fields
        ContactField(
          icon: Icons.repeat,
          label: 'Frequency:',
          value: contact.frequency,
        ),

        ContactField(
          icon: Icons.access_time,
          label: 'Last Contacted:',
          value: formatLastContacted(contact.lastContactDate),
        ),

        ContactField(
          icon: Icons.next_plan_outlined,
          label: 'Next Due:',
          value: calculateNextContactDateDisplay(
              contact.lastContactDate, contact.frequency),
        ),

        const SizedBox(height: 16.0),

        // Inactive Contact Banner
        if (!contact.isActive)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.15),
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: Colors.red.withOpacity(0.3))
            ),
            child: Text(
              'This contact is marked as INACTIVE.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red.shade700.withOpacity(0.9),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        const SizedBox(height: 70), // Space for FABs
      ],
    );
  }
}
