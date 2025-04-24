import 'package:flutter/material.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/models/contact_enums.dart';
import 'package:recall/utils/last_contacted_utils.dart';
import 'common_components.dart';

/// Displays contact schedule information in view mode
class ScheduleViewSection extends StatelessWidget {
  final Contact contact;

  const ScheduleViewSection({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Last contacted date
        DetailRow(
          icon: Icons.access_time,
          label: 'Last Contacted:',
          value: formatLastContacted(contact.lastContacted),
        ),
        
        // Contact frequency setting
        DetailRow(
          icon: Icons.repeat,
          label: 'Frequency:',
          value: contact.frequency,
        ),
        
        // Calculated next due date
        DetailRow(
          icon: Icons.next_plan_outlined,
          label: 'Next Due:',
          value: calculateNextDueDateDisplay(contact.lastContacted, contact.frequency),
        ),
      ],
    );
  }
}

/// Editable contact schedule settings
class ScheduleEditSection extends StatelessWidget {
  final Contact contact;
  final Function(String) onFrequencyChanged;
  final bool isEditMode;

  const ScheduleEditSection({
    super.key,
    required this.contact,
    required this.onFrequencyChanged,
    required this.isEditMode
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Frequency dropdown selector
        DropdownButtonFormField<String>(
          value: ContactFrequency.values.any((f) => f.value == contact.frequency)
              ? contact.frequency
              : ContactFrequency.defaultValue,
          onChanged: isEditMode 
              ? (String? newValue) {
                  if (newValue != null) {
                    onFrequencyChanged(newValue);
                  }
                }
              : null,
          items: ContactFrequency.values
              .map((frequency) => DropdownMenuItem<String>(
                  value: frequency.value, child: Text(frequency.name)))
              .toList(),
          decoration: const InputDecoration(
              labelText: 'Frequency', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 16.0),
        
        // Read-only last contacted display
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Last Contacted', 
                style: TextStyle(fontSize: 12, color: Colors.grey)
              ),
              const SizedBox(height: 4),
              Text(
                formatLastContacted(contact.lastContacted),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
