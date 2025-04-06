// lib/utils/debug_utils.dart
 import 'dart:math'; // Import for Random
 import 'package:flutter/foundation.dart'; // For kDebugMode
 import 'package:flutter_contacts/flutter_contacts.dart' as fc;
 import 'package:recall/utils/logger.dart'; // Your logger

 class DebugUtils {
   /// Adds a specified number of sample contacts to the device's address book.
   /// Only runs in debug mode and requires contact write permission.
   /// Returns a status message string.
   static Future<String> addSampleDeviceContacts({int count = 10}) async { // Added count parameter
     if (!kDebugMode) {
       logger.w("Attempted to call debug function in non-debug mode.");
       return "Error: Cannot run in release mode.";
     }
     if (count <= 0) {
        return "Info: Please enter a positive number of contacts to create.";
     }

     int successCount = 0;
     int failCount = 0;
     String statusMessage;
     final random = Random();

     try {
       // Request write permission
       if (!await fc.FlutterContacts.requestPermission(readonly: false)) {
         logger.w("Write Contacts permission denied for debug function.");
         return "Permission Denied: Cannot write contacts.";
       }

       logger.d("Write contacts permission granted. Attempting to insert $count debug contacts...");

       // --- Generate and Insert Random Contacts ---
       for (int i = 0; i < count; i++) {
         // Generate random data
         int randomSuffix = random.nextInt(9000) + 1000; // 4-digit number
         String firstName = "DebugF${randomSuffix}";
         String lastName = "DebugL${randomSuffix}";
         String phone1 = '${random.nextInt(900)+100}-${random.nextInt(900)+100}-${random.nextInt(9000)+1000}';
         String? phone2;
         String? email1;
         String? email2;

         // Occasionally add a second phone or email
         if (random.nextDouble() < 0.3) { // 30% chance of second phone
            phone2 = '${random.nextInt(900)+100}-${random.nextInt(900)+100}-${random.nextInt(9000)+1000}';
         }
         if (random.nextDouble() < 0.5) { // 50% chance of primary email
             email1 = "${firstName.toLowerCase()}.${lastName.toLowerCase()}@debugmail.com";
             if (random.nextDouble() < 0.2) { // 20% chance of secondary email IF primary exists
                email2 = "alt_${randomSuffix}@otherdebug.net";
             }
         }

         // Create contact object
         final contact = fc.Contact(
           name: fc.Name(first: firstName, last: lastName),
           phones: [
             fc.Phone(phone1, label: fc.PhoneLabel.mobile),
             if (phone2 != null) fc.Phone(phone2, label: fc.PhoneLabel.home), // Conditionally add second phone
           ],
           emails: [
             if (email1 != null) fc.Email(email1, label: fc.EmailLabel.home), // Conditionally add emails
             if (email2 != null) fc.Email(email2, label: fc.EmailLabel.work),
           ]
         );

         // Insert contact
         try {
           await fc.FlutterContacts.insertContact(contact);
           successCount++;
         } catch (e) {
           failCount++;
           logger.e("Failed to insert debug contact $firstName $lastName: $e");
         }
       } // End loop

       statusMessage = "Debug contacts: $successCount added, $failCount failed.";
       logger.i(statusMessage);

     } catch (e) {
       logger.e("Error during debug contact creation process: $e");
       statusMessage = "Error adding debug contacts: $e";
     }
     return statusMessage;
   }
 }