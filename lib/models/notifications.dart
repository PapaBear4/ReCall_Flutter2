import 'package:objectbox/objectbox.dart';

@Entity()
class NotificationSettings {
  @Id()
  int id = 0; // Auto-incrementing primary key

  bool remindersEnabled = true;
  bool alertsEnabled = true;
  // Add more properties for other notification settings
}

class LocalNotification {
  final int id;
  final String title;
  final String body;
  final String? payload; // Optional data to pass with the notification

  LocalNotification({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
  });
}