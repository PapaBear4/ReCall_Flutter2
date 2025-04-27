import 'dart:async';
import 'package:recall/models/contact.dart';
import 'package:recall/utils/debug_utils.dart';
import 'package:recall/utils/logger.dart';
import 'package:recall/sources/contact_ob_source.dart';
import 'package:recall/sources/data_source.dart';
import 'package:recall/repositories/notification_repository.dart';
import 'package:recall/services/service_locator.dart'; // To access the notification repository
import 'package:recall/services/notification_helper.dart'; // Import the notification_helper.dart
import 'data_repository.dart';

/// Repository for accessing and managing contact data
///
/// This class provides a clean API for the rest of the application to interact
/// with contact data, delegating the actual storage operations to the underlying
/// data source.
class ContactRepository implements Repository<Contact> {
  final DataSource<Contact> _source;

  /// Creates a new contact repository with the specified data source
  ///
  /// Uses dependency injection to get the data source
  ContactRepository(this._source);

  // MARK: - Basic CRUD Operations

  /// Retrieves all contacts
  @override
  Future<List<Contact>> getAll() async {
    try {
      return await _source.getAll();
    } catch (e) {
      logger.e("Error getting all contacts: $e");
      rethrow; // Propagate error to caller for handling
    }
  }

  /// Gets a contact by ID
  @override
  Future<Contact?> getById(int id) async {
    try {
      return await _source.getById(id);
    } catch (e) {
      logger.e("Error getting contact by id: $e");
      rethrow;
    }
  }

  /// Adds a new contact to the data source
  @override
  Future<Contact> add(Contact item) async {
    try {
      return await _source.add(item);
    } catch (e) {
      logger.e("Error adding contact: $e");
      rethrow;
    }
  }

  /// Adds multiple contacts at once
  @override
  Future<List<Contact>> addMany(List<Contact> items) async {
    try {
      return await _source.addMany(items);
    } catch (e) {
      logger.e("Error adding many contacts: $e");
      rethrow;
    }
  }

  /// Updates an existing contact
  @override
  Future<Contact> update(Contact item) async {
    try {
      return await _source.update(item);
    } catch (e) {
      logger.e("Error updating contact: $e");
      rethrow;
    }
  }

  /// Updates multiple contacts at once
  @override
  Future<List<Contact>> updateMany(List<Contact> items) async {
    try {
      return await _source.updateMany(items);
    } catch (e) {
      logger.e("Error updating many contacts: $e");
      rethrow;
    }
  }

  /// Deletes a contact by ID and its associated notifications
  @override
  Future<void> delete(int id) async {
    try {
      // Get the contact before deleting it (to have its info for logging)
      final contact = await _source.getById(id);

      // Delete the contact from the database
      await _source.delete(id);

      // Now clean up associated notifications
      await _deleteAssociatedNotification(id);

      logger.i(
          "Deleted contact ${contact?.firstName} ${contact?.lastName} (ID: $id) and its notifications");
    } catch (e) {
      logger.e("Error deleting contact: $e");
      rethrow;
    }
  }

  /// Deletes multiple contacts by their IDs and their associated notifications
  @override
  Future<void> deleteMany(List<int> ids) async {
    try {
      // Delete contacts from the database
      await _source.deleteMany(ids);

      // Clean up associated notifications for each contact
      for (final id in ids) {
        await _deleteAssociatedNotification(id);
      }

      logger.i(
          "Deleted ${ids.length} contacts and their associated notifications");
    } catch (e) {
      logger.e("Error deleting multiple contacts: $e");
      rethrow;
    }
  }

  /// Deletes all contacts and their associated notifications
  @override
  Future<void> deleteAll() async {
    try {
      // Delete all contacts from the database
      await _source.deleteAll();

      // Get notification repository to delete notifications
      final notificationRepo = getIt<NotificationRepository>();

      // Delete all notifications (simplest approach if we're deleting all contacts)
      await notificationRepo.deleteAll();

      logger.i("Deleted all contacts and their associated notifications");
    } catch (e) {
      logger.e("Error deleting all contacts: $e");
      rethrow;
    }
  }

  /// Helper method to delete notifications associated with a specific contact
  Future<void> _deleteAssociatedNotification(int contactId) async {
    try {
      // Get notification repository from service locator
      final notificationRepo = getIt<NotificationRepository>();

      // Query notifications related to this contact
      final notifications = await notificationRepo.getByContactId(contactId);

      // Cancel each notification from the device system
      for (final notification in notifications) {
        // Cancel the device notification
        await _cancelDeviceNotification(notification.id!);
      }

      // Delete from database
      await notificationRepo.delete(contactId);
    } catch (e) {
      logger.e(
          "Error deleting associated notifications for contact ID $contactId: $e");
      // We don't rethrow here to prevent a failure here from blocking the contact deletion
    }
  }

  /// Cancels a notification from the device notification system
  Future<void> _cancelDeviceNotification(int notificationId) async {
    try {
      // Use the NotificationHelper to cancel the notification
      final notificationHelper = NotificationHelper();
      await notificationHelper.cancelNotification(notificationId);

      logger.i("Cancelled device notification ID $notificationId");
    } catch (e) {
      logger.e("Error cancelling device notification: $e");
    }
  }

  /// Gets the count of contacts
  @override
  Future<int> count() async {
    try {
      return await _source.count();
    } catch (e) {
      logger.e("Error counting contacts: $e");
      rethrow;
    }
  }

  // MARK: - Stream Access Methods

  // Stream for all contacts
  @override
  Stream<List<Contact>> getAllStream() {
    return _source.getAllStream();
  }

  /// Returns a count stream based on query name
  @override
  Stream<int> getCountStream(String queryName) {
    return _source.getCountStream(queryName);
  }

  /// Returns a stream with the count of overdue contacts
  Stream<int> getOverdueContactCount() {
    return _source.getCountStream(ContactQueryNames.overdue);
  }

  // MARK: - Status Update Methods

  /// Updates a contact's active status (archive/unarchive)
  Future<Contact> updateContactStatus(int id, bool isActive) async {
    try {
      final contact = await _source.getById(id);
      if (contact == null) {
        throw Exception('Contact not found with ID: $id');
      }

      final updatedContact = contact.copyWith(isActive: isActive);
      return await _source.update(updatedContact);
    } catch (e) {
      logger.e("Error updating contact status: $e");
      rethrow;
    }
  }

  // MARK: - Active Contact Management

  /// The maximum number of active contacts allowed
  static const int maxActiveContacts = 18;

  /// Gets the current count of active contacts
  Future<int> getActiveContactCount() async {
    if (_source is ContactObjectBoxSource) {
      return await (_source).getActiveContactCount();
    }

    // Fallback for other data sources
    final allContacts = await getAll();
    return allContacts.where((contact) => contact.isActive).length;
  }

  /// Checks if the active contacts limit has been reached
  Future<bool> isActiveContactLimitReached() async {
    final count = await getActiveContactCount();
    return count >= maxActiveContacts;
  }

  /// Returns the number of additional active contacts that can be added
  /// before reaching the limit
  Future<int> getRemainingActiveContactSlots() async {
    final count = await getActiveContactCount();
    return maxActiveContacts - count;
  }

  /// Returns a stream with the count of active contacts
  Stream<int> getActiveContactCountStream() {
    return getCountStream(ContactQueryNames.active);
  }

  // MARK: - Sample Data

  /// Adds sample contacts to the database for testing/demo purposes
  ///
  /// This is a convenience method that delegates to the DebugUtils class
  Future<List<Contact>> addSampleAppContacts({int count = 10}) async {
    try {
      // Call the debug utility function to generate and add sample contacts
      await DebugUtils.addSampleAppContacts(this, count: count);

      // Return all contacts (including the newly added ones)
      return await getAll();
    } catch (e) {
      logger.e("Error adding sample contacts: $e");
      throw Exception("Failed to add sample contacts: $e");
    }
  }

  // MARK: - Resource Management

  /// Releases resources used by this repository
  void dispose() {
    _source.dispose();
  }
}
