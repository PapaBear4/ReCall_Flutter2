import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/models/enums.dart';
import 'package:recall/widgets/contact/contact_field.dart';
import 'package:recall/widgets/contact/email_list_widget.dart';
import 'package:go_router/go_router.dart'; // Added import
import 'package:recall/config/app_router.dart'; // Added import

class ContactEditWidget extends StatelessWidget {
  final Contact contact;
  final MaskTextInputFormatter phoneMaskFormatter;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController nicknameController;
  final TextEditingController phoneNumberController;
  final TextEditingController notesController;
  final List<TextEditingController> emailControllers;
  final Function(Contact) onContactChanged;
  final Function(List<String>) onEmailsChanged;
  final int activeContactCount;
  final int maxActiveContacts;

  const ContactEditWidget({
    Key? key,
    required this.contact,
    required this.phoneMaskFormatter,
    required this.firstNameController,
    required this.lastNameController,
    required this.nicknameController,
    required this.phoneNumberController,
    required this.notesController,
    required this.emailControllers,
    required this.onContactChanged,
    required this.onEmailsChanged,
    required this.activeContactCount,
    required this.maxActiveContacts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBasicInfoSection(context),
        _buildDatesSection(context),
        _buildContactMethodsSection(context),
        _buildNotesSection(context),
        _buildScheduleSection(context),
        _buildStatusSection(context),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildBasicInfoSection(BuildContext context) {
    return ContactSection(
      title: 'Basic Info',
      children: [
        TextFormField(
          controller: firstNameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
              labelText: 'First Name', border: OutlineInputBorder()),
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Please enter a first name' : null,
          onChanged: (value) => onContactChanged(contact.copyWith(firstName: value)),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: lastNameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
              labelText: 'Last Name', border: OutlineInputBorder()),
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Please enter a last name' : null,
          onChanged: (value) => onContactChanged(contact.copyWith(lastName: value)),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: nicknameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
              labelText: 'Nickname (Optional)', border: OutlineInputBorder()),
          onChanged: (value) => onContactChanged(
              contact.copyWith(nickname: value.isNotEmpty ? value : null)),
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }

  Widget _buildDatesSection(BuildContext context) {
    return ContactSection(
      title: 'Important Dates',
      children: [
        _buildDatePickerButton(
            context,
            'Birthday',
            contact.birthday,
            (picked) => onContactChanged(contact.copyWith(birthday: picked))),
        const SizedBox(height: 16.0),
        _buildDatePickerButton(
            context,
            'Anniversary',
            contact.anniversary,
            (picked) => onContactChanged(contact.copyWith(anniversary: picked))),
      ],
    );
  }

  Widget _buildContactMethodsSection(BuildContext context) {
    return ContactSection(
      title: 'Contact Methods',
      children: [
        TextFormField(
          controller: phoneNumberController,
          keyboardType: TextInputType.phone,
          inputFormatters: [phoneMaskFormatter],
          decoration: const InputDecoration(
              labelText: 'Phone Number',
              hintText: '(123) 456-7890',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone)),
          onChanged: (value) => onContactChanged(
              contact.copyWith(phoneNumber: phoneMaskFormatter.getUnmaskedText())),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16.0),
        EmailListWidget(
          emails: contact.emails,
          isEditMode: true,
          controllers: emailControllers,
          onEmailsChanged: onEmailsChanged,
          onEmailTap: (_) {}, // Not used in edit mode
        ),
      ],
    );
  }

  Widget _buildStatusSection(BuildContext context) {
    return ContactSection(
      title: 'Contact Status',
      children: [
        Row(
          children: [
            const Text('Contact Status:', style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text(
              contact.isActive ? 'Active' : 'Inactive',
              style: TextStyle(
                color: contact.isActive ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Switch(
              value: contact.isActive,
              activeColor: Colors.green,
              activeTrackColor: Colors.lightGreen,
              inactiveThumbColor: Colors.red,
              inactiveTrackColor: Colors.redAccent.withOpacity(0.5),
              onChanged: (bool newValue) {
                if (newValue == true && !contact.isActive && activeContactCount >= maxActiveContacts) {
                  // Trying to activate a contact when limit is reached
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: const Text('Active Contact Limit Reached'),
                        content: const Text('You may only have 18 Active contacts. Would you like to go to the All Contacts screen to deactivate some?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Deactivate Contacts'),
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                              // Navigate all the way back to the AllContacts screen.
                              // This pops until the root, then pushes the contact list.
                              while(GoRouter.of(context).canPop()) {
                                GoRouter.of(context).pop();
                              }
                              context.pushNamed(AppRouter.contactListRouteName);
                            },
                          ),
                        ],
                      );
                    },
                  );
                  // Do not call onContactChanged, keep the switch in its current (false) state.
                } else {
                  // Allow change if deactivating, or if activating and limit is not reached
                  onContactChanged(contact.copyWith(isActive: newValue));
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScheduleSection(BuildContext context) {
    return ContactSection(
      title: 'Contact Schedule',
      children: [
        DropdownButtonFormField<String>(
          value: ContactFrequency.values.any((f) => f.value == contact.frequency)
              ? contact.frequency
              : ContactFrequency.defaultValue,
          onChanged: (String? newValue) {
            if (newValue != null) {
              onContactChanged(contact.copyWith(frequency: newValue));
            }
          },
          items: ContactFrequency.values
              .map((frequency) => DropdownMenuItem<String>(
                  value: frequency.value, child: Text(frequency.name)))
              .toList(),
          decoration: const InputDecoration(
              labelText: 'Frequency', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    return ContactSection(
      title: 'Notes',
      children: [
        TextFormField(
          controller: notesController,
          decoration: const InputDecoration(
            labelText: 'Notes',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          maxLines: 4,
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.multiline,
          onChanged: (value) => onContactChanged(
              contact.copyWith(notes: value.isNotEmpty ? value : null)),
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  Widget _buildDatePickerButton(
      BuildContext context, String label, DateTime? currentValue, Function(DateTime) onDatePicked) {
    return Row(
      children: [
        Expanded(
            child: Text('$label:',
                style: const TextStyle(fontWeight: FontWeight.bold))),
        ElevatedButton(
          onPressed: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: currentValue ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (picked != null && picked != currentValue) {
              onDatePicked(picked);
            }
          },
          child: Text(currentValue == null
              ? 'Select Date'
              : DateFormat.yMd().format(currentValue)),
        ),
      ],
    );
  }
}
