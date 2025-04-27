import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Import for kDebugMode

typedef VoidCallback = void Function();

class ContactListSpeedDial extends StatefulWidget {
  final VoidCallback onAddNewContact;
  final VoidCallback onImportContacts;
  final VoidCallback onAddSampleContacts; // New callback

  const ContactListSpeedDial({
    super.key,
    required this.onAddNewContact,
    required this.onImportContacts,
    required this.onAddSampleContacts, // Add to constructor
  });

  @override
  State<ContactListSpeedDial> createState() => _ContactListSpeedDialState();
}

class _ContactListSpeedDialState extends State<ContactListSpeedDial>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _buttonAnimationScale;
  late Animation<double> _childButtonAnimation1; // Import
  late Animation<double> _childButtonAnimation2; // Add New
  late Animation<double> _childButtonAnimation3; // Add Sample (New)
  bool _isSpeedDialOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350), // Slightly longer duration
    );

    _buttonAnimationScale = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Adjust animation intervals for 3 buttons
    _childButtonAnimation1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut), // Adjusted interval
      ),
    );

    _childButtonAnimation2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut), // Adjusted interval
      ),
    );

    _childButtonAnimation3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut), // New animation interval
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSpeedDial() {
    setState(() {
      _isSpeedDialOpen = !_isSpeedDialOpen;
      if (_isSpeedDialOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _handleAddNewContact() {
    if (_isSpeedDialOpen) _toggleSpeedDial(); // Close dial
    widget.onAddNewContact(); // Call callback
  }

  void _handleImportContacts() {
    if (_isSpeedDialOpen) _toggleSpeedDial(); // Close dial
    widget.onImportContacts(); // Call callback
  }

  // New handler for adding sample contacts
  void _handleAddSampleContacts() {
    if (_isSpeedDialOpen) _toggleSpeedDial(); // Close dial
    widget.onAddSampleContacts(); // Call new callback
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Import contacts button (first child)
        ScaleTransition(
          scale: _childButtonAnimation1,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: FloatingActionButton(
              heroTag: "importBtn",
              backgroundColor: Colors.amber[700],
              mini: true,
              onPressed: _handleImportContacts,
              tooltip: 'Import Contacts',
              child: const Icon(Icons.file_download),
            ),
          ),
        ),

        // Add contact button (second child)
        ScaleTransition(
          scale: _childButtonAnimation2,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: FloatingActionButton(
              heroTag: "addBtn",
              backgroundColor: Colors.green,
              mini: true,
              onPressed: _handleAddNewContact,
              tooltip: 'Add New Contact',
              child: const Icon(Icons.person_add),
            ),
          ),
        ),

        // Add sample contacts button (third child - New, Debug Only)
        if (kDebugMode) // Only build in debug mode
          ScaleTransition(
            scale: _childButtonAnimation3,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: FloatingActionButton(
                heroTag: "addSampleBtn",
                backgroundColor: Colors.blue, // Choose a color
                mini: true,
                onPressed: _handleAddSampleContacts, // Use new handler
                tooltip: 'Add Sample Contacts',
                child: const Icon(Icons.science_outlined), // Choose an icon
              ),
            ),
          ),

        // Main button
        ScaleTransition(
          scale: _buttonAnimationScale,
          child: FloatingActionButton(
            heroTag: "mainBtn",
            backgroundColor:
                Theme.of(context).primaryColor.withAlpha((255 * 0.6).round()),
            onPressed: _toggleSpeedDial,
            tooltip: 'Add Contact Options',
            child: AnimatedRotation(
              duration: const Duration(milliseconds: 300),
              turns: _isSpeedDialOpen ? 0.125 : 0, // 45 degrees when open
              child: const Icon(Icons.add, size: 30),
            ),
          ),
        ),
      ],
    );
  }
}
