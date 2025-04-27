import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recall/models/contact.dart';
import 'common_components.dart';

/// Displays birthday, anniversary, and notes in view mode
class DatesViewSection extends StatelessWidget {
  final Contact contact;

  const DatesViewSection({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Birthday
        DetailRow(
          icon: Icons.cake_outlined,
          label: 'Birthday:',
          value: contact.birthday == null
              ? 'Not set'
              : DateFormat.yMd().format(contact.birthday!),
        ),
        
        // Anniversary
        DetailRow(
          icon: Icons.celebration_outlined,
          label: 'Anniversary:',
          value: contact.anniversary == null
              ? 'Not set'
              : DateFormat.yMd().format(contact.anniversary!),
        ),
        
        // Notes
        DetailRow(
          icon: Icons.notes_outlined,
          label: 'Notes:',
          value: contact.notes ?? 'Not set',
        ),
      ],
    );
  }
}

/// Editable date pickers and notes field
class DatesEditSection extends StatelessWidget {
  final Contact contact;
  final TextEditingController notesController;
  final Function(String) onNotesChanged;
  final Function(DateTime) onBirthdaySelected;
  final Function(DateTime) onAnniversarySelected;
  final bool isEditMode;

  const DatesEditSection({
    super.key,
    required this.contact,
    required this.notesController,
    required this.onNotesChanged,
    required this.onBirthdaySelected,
    required this.onAnniversarySelected,
    required this.isEditMode
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Birthday date picker
        DatePickerButton(
          label: 'Birthday',
          currentValue: contact.birthday,
          onDatePicked: onBirthdaySelected,
          enabled: isEditMode,
        ),
        const SizedBox(height: 8.0),
        
        // Anniversary date picker
        DatePickerButton(
          label: 'Anniversary',
          currentValue: contact.anniversary,
          onDatePicked: onAnniversarySelected,
          enabled: isEditMode,
        ),
        const SizedBox(height: 16.0),
        
        // Multi-line notes field
        TextFormField(
          controller: notesController,
          enabled: isEditMode,
          decoration: const InputDecoration(
              labelText: 'Notes',
              border: OutlineInputBorder(),
              alignLabelWithHint: true),
          maxLines: 4,
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.multiline,
          onChanged: onNotesChanged,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}
