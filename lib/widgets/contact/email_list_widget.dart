import 'package:flutter/material.dart';

/// Widget for displaying and editing a list of emails
class EmailListWidget extends StatelessWidget {
  final List<String>? emails;
  final bool isEditMode;
  final List<TextEditingController> controllers;
  final Function(List<String>) onEmailsChanged;
  final Function(String) onEmailTap;

  const EmailListWidget({
    Key? key,
    required this.emails,
    required this.isEditMode,
    required this.controllers,
    required this.onEmailsChanged,
    required this.onEmailTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isEditMode) {
      return _buildEmailEditor(context);
    } else {
      return _buildEmailDisplay(context);
    }
  }

  Widget _buildEmailEditor(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Existing email fields
        ...controllers.asMap().entries.map((entry) {
          int index = entry.key;
          TextEditingController controller = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    enabled: isEditMode,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: 'Email ${index + 1}',
                        border: const OutlineInputBorder()),
                    validator: (value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          !value.contains('@')) {
                        return 'Invalid email format';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (emails != null && index < emails!.length) {
                        final List<String> updatedEmails = List<String>.from(emails!);
                        updatedEmails[index] = value;
                        onEmailsChanged(updatedEmails);
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                  tooltip: 'Remove Email',
                  onPressed: () {
                    if (emails != null && index >= 0 && index < emails!.length) {
                      final List<String> updatedEmails = List<String>.from(emails!);
                      updatedEmails.removeAt(index);
                      onEmailsChanged(updatedEmails);
                    }
                  },
                )
              ],
            ),
          );
        }),
        
        // Add Email Button
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Email'),
            onPressed: () {
              final List<String> currentEmails = emails ?? [];
              final List<String> newEmails = [...currentEmails, ''];
              onEmailsChanged(newEmails);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmailDisplay(BuildContext context) {
    if (emails == null || emails!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
        child: Text('Not set'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: emails!.map((email) {
        if (email.trim().isEmpty) {
          return const SizedBox.shrink(); // Don't show empty entries
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: InkWell(
            onTap: () => onEmailTap(email),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    email,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.email_outlined),
                  tooltip: 'Send Email',
                  iconSize: 20,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  onPressed: () => onEmailTap(email),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
