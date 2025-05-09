// lib/models/contact.dart
import 'package:objectbox/objectbox.dart';
import 'package:json_annotation/json_annotation.dart';
import 'enums.dart';
import 'package:flutter/foundation.dart';

part 'contact.g.dart';

@JsonSerializable()
@Entity()
class Contact {
  @Id(assignable: true)
  int? id;
  
  final String firstName;
  final String lastName;
  final String? nickname;
  final String frequency; // Store the String representation
  
  @Property(type: PropertyType.date)
  final DateTime? birthday;
  
  @Property(type: PropertyType.date)
  final DateTime? lastContacted;

  @Property(type: PropertyType.date)
  final DateTime? nextContact; // New field
  
  @Property(type: PropertyType.date)
  final DateTime? anniversary;
  
  final String? phoneNumber; // Single phone number (optional)
  final List<String>? emails; // List of emails (optional)
  final String? notes; // Notes field (optional)
  final bool isActive; // Track if contact is active or archived
  
  // Social Media Fields have been removed

  Contact({
    this.id,
    required this.firstName,
    required this.lastName,
    this.nickname,
    this.frequency = ContactFrequency.defaultValue,
    this.birthday,
    this.lastContacted,
    this.nextContact, // Add to constructor
    this.anniversary,
    this.phoneNumber,
    this.emails,
    this.notes,
    this.isActive = true, // Default to active
  });
  
  // Manual implementation of copyWith
  Contact copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? nickname,
    String? frequency,
    DateTime? birthday,
    DateTime? lastContacted,
    DateTime? nextContact, // Add to copyWith
    DateTime? anniversary,
    String? phoneNumber,
    List<String>? emails,
    String? notes,
    bool? isActive,
    // Add parameters for clearing nullable fields
    bool clearNickname = false,
    bool clearBirthday = false,
    bool clearLastContacted = false,
    bool clearAnniversary = false,
    bool clearPhoneNumber = false,
    bool clearEmails = false,
    bool clearNotes = false,
  }) {
    return Contact(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nickname: clearNickname ? null : (nickname ?? this.nickname),
      frequency: frequency ?? this.frequency,
      birthday: clearBirthday ? null : (birthday ?? this.birthday),
      lastContacted: clearLastContacted ? null : (lastContacted ?? this.lastContacted),
      nextContact: nextContact ?? this.nextContact, // Add to copyWith logic
      anniversary: clearAnniversary ? null : (anniversary ?? this.anniversary),
      phoneNumber: clearPhoneNumber ? null : (phoneNumber ?? this.phoneNumber),
      emails: clearEmails ? null : (emails ?? this.emails),
      notes: clearNotes ? null : (notes ?? this.notes),
      isActive: isActive ?? this.isActive,
    );
  }
  
  // For JSON serialization
  factory Contact.fromJson(Map<String, dynamic> json) => _$ContactFromJson(json);
  Map<String, dynamic> toJson() => _$ContactToJson(this);
  
  // Equality and hash
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Contact &&
      other.id == id &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.nickname == nickname &&
      other.frequency == frequency &&
      other.birthday == birthday &&
      other.lastContacted == lastContacted &&
      other.nextContact == nextContact && // Add to equality check
      other.anniversary == anniversary &&
      other.phoneNumber == phoneNumber &&
      listEquals(other.emails, emails) &&
      other.notes == notes &&
      other.isActive == isActive;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      firstName,
      lastName,
      nickname,
      frequency,
      birthday,
      lastContacted,
      nextContact, // Add to hash
      anniversary,
      phoneNumber,
      Object.hashAll(emails ?? []),
      notes,
      isActive,
    );
  }
  
  @override
  String toString() {
    return 'Contact(id: $id, firstName: $firstName, lastName: $lastName, '
           'nickname: $nickname, frequency: $frequency, isActive: $isActive, nextContact: $nextContact, ...)';
  }
}
