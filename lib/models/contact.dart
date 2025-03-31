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
    @Default(ContactFrequency.defaultValue)
    String frequency, // Store the String representation
    @Property(type: PropertyType.date) DateTime? birthday,
    @Property(type: PropertyType.date) DateTime? lastContacted,
    @Property(type: PropertyType.date) DateTime? anniversary,
  }) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
}
