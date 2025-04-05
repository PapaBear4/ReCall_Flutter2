// lib/models/contact.dart
import 'package:objectbox/objectbox.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'contact_frequency.dart';
import 'package:flutter/foundation.dart';

part 'contact.freezed.dart';
part 'contact.g.dart';

@freezed
abstract class Contact with _$Contact {
  const Contact._();

  @Entity(realClass: Contact)
  factory Contact({
    @Id(assignable: true) int? id,
    required String firstName,
    required String lastName,
    String? nickname,
    @Default(ContactFrequency.defaultValue)
    String frequency, // Store the String representation
    @Property(type: PropertyType.date) DateTime? birthday,
    @Property(type: PropertyType.date) DateTime? lastContacted,
    @Property(type: PropertyType.date) DateTime? anniversary,
    String? phoneNumber, // Single phone number (optional)
    List<String>? emails, // List of emails (optional)
    String? notes, // Notes field (optional)
    // Specific Social Media Fields (optional Strings)
    String? youtubeUrl,
    String? instagramHandle,
    String? facebookUrl,
    String? snapchatHandle,
    String? xHandle,
    String? linkedInUrl,

  }) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
}
