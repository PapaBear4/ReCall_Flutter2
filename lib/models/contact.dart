// lib/models/contact.dart
import 'package:objectbox/objectbox.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'contact_enums.dart';

part 'contact.g.dart';

/// Contact model represents an individual contact in the application.
/// 
/// This class stores personal information about contacts including basic details,
/// important dates, and notes. It's used for storing and 
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
  /// 
  /// This field is optional and will default to an empty string if not provided.
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
  
  /// Indicates whether the contact is active.
  /// 
  /// Defaults to true. Can be used to hide contacts without deleting them.
  final bool isActive;

  /// Creates a new contact with the specified properties.
  /// 
  /// Only [firstName] is required. The [frequency] defaults
  /// to the value specified in [ContactFrequency.defaultValue].
  /// The [lastName] defaults to an empty string.
  Contact({
    this.id,
    required this.firstName,
    this.lastName = '',
    this.nickname,
    this.frequency = ContactFrequency.defaultValue, // Default value
    this.birthday,
    this.lastContacted,
    this.nextContact,
    this.anniversary,
    this.phoneNumber,
    this.emails,
    this.notes,
    this.isActive = true,
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
    bool? isActive,
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
      notes: notes ?? this.notes, // Uses null-coalescing operator
      isActive: isActive ?? this.isActive,
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
        isActive,
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
