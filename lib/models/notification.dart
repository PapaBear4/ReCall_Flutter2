// lib/models/notification.dart
import 'package:objectbox/objectbox.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

/// Represents a notification that will be displayed to the user.
///
/// This class stores information about notifications including their content,
/// optional data payload, and when they should be displayed. It's used
/// for storing notifications in the ObjectBox database and for scheduling
/// them through the platform's notification system.
@JsonSerializable()
@Entity()
class Notification extends Equatable {
  /// Unique identifier for the notification.
  ///
  /// Can be assigned manually which is useful for imports/migrations.
  @Id(assignable: true)
  int? id;
  
  /// The headline text that appears in the notification.
  final String title;
  
  /// The detailed message text shown in the notification body.
  final String body;
  
  /// Optional data that can be attached to the notification.
  ///
  /// This could be used to store information needed when the user
  /// interacts with the notification, such as a contact ID.
  final String? payload;
  
  /// When this notification should be shown to the user.
  ///
  /// If null, the notification is considered for immediate delivery.
  @Property(type: PropertyType.date)
  final DateTime? scheduledTime;

  /// Creates a new notification with the specified properties.
  ///
  /// Only [title] and [body] are required parameters.
  Notification({
    this.id,
    required this.title,
    required this.body,
    this.payload,
    this.scheduledTime,
  });

  /// Creates a new instance of Notification with optional updated properties.
  ///
  /// This method allows for immutable updates to Notification objects.
  /// Any parameters not provided will retain their original values.
  Notification copyWith({
    int? id,
    String? title,
    String? body,
    String? payload,
    DateTime? scheduledTime,
  }) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      payload: payload ?? this.payload,
      scheduledTime: scheduledTime ?? this.scheduledTime,
    );
  }

  /// Properties used for equality comparison through Equatable.
  ///
  /// Two Notification objects with the same property values will be considered equal.
  @override
  List<Object?> get props => [
    id,
    title,
    body,
    payload,
    scheduledTime,
  ];

  /// Creates a Notification instance from a JSON map.
  ///
  /// This factory is used for deserializing notifications from JSON data.
  factory Notification.fromJson(Map<String, dynamic> json) => 
      _$NotificationFromJson(json);
  
  /// Converts this Notification instance to a JSON map.
  ///
  /// Used for serializing notifications for storage or API communications.
  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
