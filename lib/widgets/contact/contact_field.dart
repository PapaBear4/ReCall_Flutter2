import 'package:flutter/material.dart';

/// A reusable component for displaying contact fields
/// Handles both display mode and edit mode with consistent styling
class ContactField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isEditMode;
  final Widget? editor;
  final Color? textColor;
  final VoidCallback? onTap;
  final List<Widget> actions;

  const ContactField({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    this.isEditMode = false,
    this.editor,
    this.textColor,
    this.onTap,
    this.actions = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isEditMode && editor != null) {
      return editor!;
    }

    // For view mode
    Widget valueWidget = Text(
      value,
      style: textColor != null ? TextStyle(color: textColor) : null,
    );

    // Make value tappable if onTap is provided and value exists
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
          Icon(icon, size: 20.0, color: textColor ?? Colors.grey[700]),
          const SizedBox(width: 12.0),
          SizedBox(
            width: 110,
            child: Text('$label ',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: valueWidget),
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

/// A component for grouping related contact fields with a header
class ContactSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ContactSection({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        ...children,
      ],
    );
  }
}
