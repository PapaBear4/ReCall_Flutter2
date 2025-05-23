// lib/models/notification.dart
import 'package:objectbox/objectbox.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class Notification {
  @Id(assignable: true)
  int? id;
  String title;
  String body;
  String? payload;
  @Property(type: PropertyType.date)
  DateTime? scheduledTime;

  Notification({
    this.id,
    required this.title,
    required this.body,
    this.payload,
    this.scheduledTime,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => 
      _$NotificationFromJson(json);
  
  Map<String, dynamic> toJson() => _$NotificationToJson(this);

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Notification &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          body == other.body &&
          payload == other.payload &&
          scheduledTime == other.scheduledTime;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      body.hashCode ^
      payload.hashCode ^
      scheduledTime.hashCode;

  @override
  String toString() {
    return 'Notification{id: $id, title: $title, body: $body, payload: $payload, scheduledTime: $scheduledTime}';
  }
}
