import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Standard row for displaying a labeled field with icon
class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  
  const DetailRow({
    super.key, 
    required this.icon, 
    required this.label, 
    required this.value
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.0, color: Colors.grey[700]),
          const SizedBox(width: 12.0),
          SizedBox(
            width: 110,
            child: Text(
              '$label ',
              style: const TextStyle(fontWeight: FontWeight.bold)
            )
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

/// Row with tappable value and optional action buttons
class ActionableDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final List<Widget> actions;

  const ActionableDetailRow({
    super.key, 
    required this.icon, 
    required this.label, 
    required this.value, 
    this.onTap, 
    this.actions = const []
  });

  @override
  Widget build(BuildContext context) {
    // Make value tappable if onTap provided and value exists
    Widget valueWidget = Text(value);
    if (onTap != null && value != 'Not set') {
      valueWidget = InkWell(
        onTap: onTap,
        child: Text(
          value,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.0, color: Colors.grey[700]),
          const SizedBox(width: 12.0),
          SizedBox(
            width: 110,
            child: Text(
              '$label ',
              style: const TextStyle(fontWeight: FontWeight.bold)
            )
          ),
          Expanded(child: valueWidget),
          // Optional action buttons
          if (actions.isNotEmpty) ...[
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
          ]
        ],
      ),
    );
  }
}

/// Date picker button with current value display
class DatePickerButton extends StatelessWidget {
  final String label;
  final DateTime? currentValue;
  final Function(DateTime) onDatePicked;
  final bool enabled;

  const DatePickerButton({
    super.key, 
    required this.label, 
    required this.currentValue, 
    required this.onDatePicked, 
    this.enabled = true
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Label
        Expanded(
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold)
          )
        ),
        // Button with date or placeholder
        ElevatedButton(
          onPressed: !enabled
            ? null
            : () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: currentValue ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (!context.mounted) return;
                if (picked != null && picked != currentValue) {
                  onDatePicked(picked);
                }
              },
          child: Text(
            currentValue == null
              ? 'Select Date'
              : DateFormat.yMd().format(currentValue!)
          ),
        ),
      ],
    );
  }
}

/// Section header with consistent styling
class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
