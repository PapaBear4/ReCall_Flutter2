import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Displays list of email addresses with tap-to-mail functionality
class EmailDisplayList extends StatelessWidget {
  final List<String>? emails;
  final Function(String) launchEmail;

  const EmailDisplayList({
    super.key, 
    required this.emails, 
    required this.launchEmail
  });

  @override
  Widget build(BuildContext context) {
    // Show placeholder if no emails are available
    if (emails == null || emails!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
        child: Text('Not set'),
      );
    }

    // Display all emails with action buttons
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: emails!.map((email) {
        // Skip empty entries
        if (email.trim().isEmpty) {
          return const SizedBox.shrink();
        }

        // Create interactive email row
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: InkWell(
            onTap: () => launchEmail(email),
            child: Row(
              children: [
                // Email address with link styling
                Expanded(
                  child: Text(
                    email,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                // Email action button
                IconButton(
                  icon: const Icon(Icons.email_outlined),
                  tooltip: 'Send Email',
                  iconSize: 20,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  onPressed: () => launchEmail(email),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Editable list of email fields with add/delete functionality
class EmailListEditor extends StatelessWidget {
  final List<TextEditingController> emailControllers;
  final Function(int, String) onEmailChanged;
  final Function(int) onEmailDeleted;
  final VoidCallback onAddEmailPressed;
  final bool isEditMode;

  const EmailListEditor({
    super.key,
    required this.emailControllers,
    required this.onEmailChanged,
    required this.onEmailDeleted,
    required this.onAddEmailPressed,
    required this.isEditMode
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Generate a form field for each email controller
        ...emailControllers.asMap().entries.map((entry) {
          int index = entry.key;
          TextEditingController controller = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                // Email input field
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    enabled: isEditMode,
                    decoration: InputDecoration(
                      labelText: 'Email ${index + 1}',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => onEmailChanged(index, value),
                  ),
                ),
                // Delete button (only shown in edit mode)
                if (isEditMode)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    visualDensity: VisualDensity.compact,
                    onPressed: () => onEmailDeleted(index),
                  ),
              ],
            ),
          );
        }),
        
        // Add email button
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Email'),
            onPressed: isEditMode ? onAddEmailPressed : null,
          ),
        ),
      ],
    );
  }
}
