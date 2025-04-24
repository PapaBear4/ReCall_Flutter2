// lib/models/contact.dart
import 'package:objectbox/objectbox.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'contact_enums.dart';

part 'contact.g.dart';

/// Contact model represents an individual contact in the application.
/// 
/// This class stores personal information about contacts including basic details,
/// important dates, and social media profiles. It's used for storing and 
/// retrieving contact information from the ObjectBox database.
@JsonSerializable()
@Entity()
class Contact extends Equatable {
  /// Unique identifier for the contact.
  /// 
  /// Can be assigned manually which is useful for imports/migrations.
  @Id(assignable: true)
  int? id;
  
  /// First name of the contact.
  final String firstName;
  
  /// Last name of the contact.
  final String lastName;
  
  /// Optional nickname for the contact.
  final String? nickname;
  
  /// How frequently the user wants to be reminded to contact this person.
  /// 
  /// Values are defined in [ContactFrequency] class.
  final String frequency;
  
  /// The last time this contact was communicated with.
  @Property(type: PropertyType.date)
  final DateTime? lastContacted;
  
  /// The date when the user should next contact this person.
  /// 
  /// This field is used to schedule reminders based on contact frequency.
  @Property(type: PropertyType.date)
  final DateTime? nextContact;
  
  /// The contact's birthday, if known.
  @Property(type: PropertyType.date)
  final DateTime? birthday;
  
  /// The contact's anniversary date, if applicable.
  @Property(type: PropertyType.date)
  final DateTime? anniversary;
  
  /// The contact's phone number.
  final String? phoneNumber;
  
  /// List of email addresses for this contact.
  final List<String>? emails;
  
  /// Additional notes about the contact.
  final String? notes;
  
  /// URL to the contact's YouTube channel.
  final String? youtubeUrl;
  
  /// Instagram handle of the contact.
  final String? instagramHandle;
  
  /// URL to the contact's Facebook profile.
  final String? facebookUrl;
  
  /// Snapchat username of the contact.
  final String? snapchatHandle;
  
  /// Twitter/X handle of the contact.
  final String? xHandle;
  
  /// URL to the contact's LinkedIn profile.
  final String? linkedInUrl;

  /// Creates a new contact with the specified properties.
  /// 
  /// Only [firstName] and [lastName] are required. The [frequency] defaults
  /// to the value specified in [ContactFrequency.defaultValue].
  Contact({
    this.id,
    required this.firstName,
    required this.lastName,
    this.nickname,
    this.frequency = ContactFrequency.defaultValue, // Default value
    this.birthday,
    this.lastContacted,
    this.nextContact,
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

  /// Creates a new instance of Contact with optional updated properties.
  /// 
  /// This method allows for immutable updates to Contact objects.
  /// Any parameters not provided will retain their original values.
  Contact copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? nickname,
    String? frequency,
    DateTime? birthday,
    DateTime? lastContacted,
    DateTime? nextContact,
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
  }) {
    return Contact(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nickname: nickname ?? this.nickname,
      frequency: frequency ?? this.frequency,
      birthday: birthday ?? this.birthday,
      lastContacted: lastContacted ?? this.lastContacted,
      nextContact: nextContact ?? this.nextContact,
      anniversary: anniversary ?? this.anniversary,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emails: emails ?? this.emails,
      notes: notes ?? this.notes,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      instagramHandle: instagramHandle ?? this.instagramHandle,
      facebookUrl: facebookUrl ?? this.facebookUrl,
      snapchatHandle: snapchatHandle ?? this.snapchatHandle,
      xHandle: xHandle ?? this.xHandle,
      linkedInUrl: linkedInUrl ?? this.linkedInUrl,
    );
  }

  /// Properties used for equality comparison through Equatable.
  /// 
  /// Two Contact objects with the same property values will be considered equal.
  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        nickname,
        frequency,
        birthday,
        lastContacted,
        nextContact,
        anniversary,
        phoneNumber,
        emails,
        notes,
        youtubeUrl,
        instagramHandle,
        facebookUrl,
        snapchatHandle,
        xHandle,
        linkedInUrl,
      ];

  /// Creates a Contact instance from a JSON map.
  /// 
  /// This factory is used for deserializing contacts from JSON data.
  factory Contact.fromJson(Map<String, dynamic> json) => 
      _$ContactFromJson(json);
  
  /// Converts this Contact instance to a JSON map.
  /// 
  /// Used for serializing contacts for storage or API communications.
  Map<String, dynamic> toJson() => _$ContactToJson(this);
}
