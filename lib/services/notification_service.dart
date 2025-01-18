// lib/services/notification_service.dart
import 'package:flutter/foundation.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/models/contact_frequency.dart';
import 'package:recall/services/notification_helper.dart';
import 'package:recall/utils/last_contacted_helper.dart';
import 'package:recall/repositories/contact_repository.dart';

class NotificationService extends ChangeNotifier {
  final ContactRepository contactRepository;
  final NotificationHelper notificationHelper;

  NotificationService(this.contactRepository,this.notificationHelper);

Future<List<Contact>> getContacts() async {
    // Use the repository to fetch contacts
    return await contactRepository.getAll();
  }

  Future<void> addContact({
    required String firstName,
    required String lastName,
    required ContactFrequency frequency,
    DateTime? birthday,
    DateTime? lastContacted,
  }) async {
    final newContact = Contact(
      firstName: firstName,
      lastName: lastName,
      frequency: frequency.value,
      birthday: birthday,
      lastContacted: lastContacted,
    );
    // Use the repository to add a contact
    final addedContact = await contactRepository.add(newContact);
    notifyListeners();
    // Schedule notification if overdue
    _scheduleNotificationIfNeeded(addedContact);
  }

  Future<void> updateContact(Contact updatedContact) async {
    // Use the repository to update a contact
    final newContact = await contactRepository.update(updatedContact);
    notifyListeners();
    // Cancel any old notification and schedule a new one
    notificationHelper.cancelNotification(updatedContact.id!);
    _scheduleNotificationIfNeeded(newContact);
  }

Future<void> markContactAsContacted(Contact contact) async {
    final updatedContact = contact.copyWith(lastContacted: DateTime.now());
    // Update the contact in the repository
    final newContact = await contactRepository.update(updatedContact);
    notifyListeners();
    // Cancel existing notification
    notificationHelper.cancelNotification(contact.id!);
    // Reschedule notification for new due date
    _scheduleNotificationIfNeeded(newContact);
  }

  Future<void> deleteContact(int contactId) async {
    // Use the repository to delete a contact
    await contactRepository.delete(contactId);
    notifyListeners();
    // Cancel notification
    notificationHelper.cancelNotification(contactId);
  }

  DateTime _calculateNextDueDate(Contact contact) {
    if (contact.lastContacted == null) {
      return DateTime.now(); // Or some other default behavior
    }

    final frequency = ContactFrequency.fromString(contact.frequency);
    final lastContacted = contact.lastContacted!;

    switch (frequency) {
      case ContactFrequency.daily:
        return lastContacted.add(const Duration(days: 1));
      case ContactFrequency.weekly:
        return lastContacted.add(const Duration(days: 7));
      case ContactFrequency.biweekly:
        return lastContacted.add(const Duration(days: 14));
      case ContactFrequency.monthly:
        return lastContacted.add(const Duration(days: 30));
      case ContactFrequency.quarterly:
        return lastContacted.add(const Duration(days: 90));
      case ContactFrequency.yearly:
        return lastContacted.add(const Duration(days: 365));
      case ContactFrequency.rarely:
        return lastContacted.add(const Duration(days: 750));
      case ContactFrequency.never:
      default:
        return DateTime.now().add(const Duration(days: 365 * 10)); // A long time in the future
    }
  }

  void _scheduleNotificationIfNeeded(Contact contact) {
    if (isOverdue(contact.frequency, contact.lastContacted)) {
      final nextDueDate = _calculateNextDueDate(contact);
      notificationHelper.scheduleDailyNotification(
        id: contact.id!,
        title: "Contact ${contact.firstName} ${contact.lastName}",
        body:
            "${contact.firstName} ${contact.lastName} is due to be contacted. Frequency: ${contact.frequency}",
        dueDate: nextDueDate,
      );
    }
  }

Future<void> scheduleNotificationsForDueContacts() async {
    // Use the repository to get all contacts
    final allContacts = await contactRepository.getAll(); 
    final dueContacts = allContacts
        .where((contact) =>
            isOverdue(contact.frequency, contact.lastContacted) ||
            contact.lastContacted == null)
        .toList();

    for (final contact in dueContacts) {
      _scheduleNotificationIfNeeded(contact);
    }
  }}