// lib/models/contact.dart
import 'package:objectbox/objectbox.dart';
import 'package:json_annotation/json_annotation.dart';
import 'contact_frequency.dart';
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
  final DateTime? anniversary;
  
  final String? phoneNumber; // Single phone number (optional)
  final List<String>? emails; // List of emails (optional)
  final String? notes; // Notes field (optional)
  
  // Social Media Fields (based on your imports)
  final String? youtubeUrl;
  final String? instagramHandle;
  final String? facebookUrl;
  final String? snapchatHandle;
  final String? xHandle;
  final String? linkedInUrl;

  Contact({
    this.id,
    required this.firstName,
    required this.lastName,
    this.nickname,
    this.frequency = ContactFrequency.defaultValue,
    this.birthday,
    this.lastContacted,
    this.anniversary,
    this.phoneNumber,
    this.emails,
    this.notes,
    this.youtubeUrl,
    this.instagramHandle,
    this.facebookUrl,
    this.snapchatHandle,
    this.xHandle,
    this.linkedInUrl,
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
    DateTime? anniversary,
    String? phoneNumber,
    List<String>? emails,
    String? notes,
    String? youtubeUrl,
    String? instagramHandle,
    String? facebookUrl,
    String? snapchatHandle,
    String? xHandle,
    String? linkedInUrl,
    // Add parameters for clearing nullable fields
    bool clearNickname = false,
    bool clearBirthday = false,
    bool clearLastContacted = false,
    bool clearAnniversary = false,
    bool clearPhoneNumber = false,
    bool clearEmails = false,
    bool clearNotes = false,
    bool clearYoutubeUrl = false,
    bool clearInstagramHandle = false,
    bool clearFacebookUrl = false,
    bool clearSnapchatHandle = false,
    bool clearXHandle = false,
    bool clearLinkedInUrl = false,
  }) {
    return Contact(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nickname: clearNickname ? null : (nickname ?? this.nickname),
      frequency: frequency ?? this.frequency,
      birthday: clearBirthday ? null : (birthday ?? this.birthday),
      lastContacted: clearLastContacted ? null : (lastContacted ?? this.lastContacted),
      anniversary: clearAnniversary ? null : (anniversary ?? this.anniversary),
      phoneNumber: clearPhoneNumber ? null : (phoneNumber ?? this.phoneNumber),
      emails: clearEmails ? null : (emails ?? this.emails),
      notes: clearNotes ? null : (notes ?? this.notes),
      youtubeUrl: clearYoutubeUrl ? null : (youtubeUrl ?? this.youtubeUrl),
      instagramHandle: clearInstagramHandle ? null : (instagramHandle ?? this.instagramHandle),
      facebookUrl: clearFacebookUrl ? null : (facebookUrl ?? this.facebookUrl),
      snapchatHandle: clearSnapchatHandle ? null : (snapchatHandle ?? this.snapchatHandle),
      xHandle: clearXHandle ? null : (xHandle ?? this.xHandle),
      linkedInUrl: clearLinkedInUrl ? null : (linkedInUrl ?? this.linkedInUrl),
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
      other.anniversary == anniversary &&
      other.phoneNumber == phoneNumber &&
      listEquals(other.emails, emails) &&
      other.notes == notes &&
      other.youtubeUrl == youtubeUrl &&
      other.instagramHandle == instagramHandle &&
      other.facebookUrl == facebookUrl &&
      other.snapchatHandle == snapchatHandle &&
      other.xHandle == xHandle &&
      other.linkedInUrl == linkedInUrl;
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
      anniversary,
      phoneNumber,
      Object.hashAll(emails ?? []),
      notes,
      youtubeUrl,
      instagramHandle,
      facebookUrl,
      snapchatHandle,
      xHandle,
      linkedInUrl,
    );
  }
  
  @override
  String toString() {
    return 'Contact(id: $id, firstName: $firstName, lastName: $lastName, '
           'nickname: $nickname, frequency: $frequency, ...)';
  }
}
