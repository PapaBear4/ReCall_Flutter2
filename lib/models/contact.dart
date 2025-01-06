import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact.freezed.dart';
part 'contact.g.dart'; // Add this for JSON serialization

enum ContactFrequency {
  daily,
  weekly,
  biWeekly,
  monthly,
  quarterly,
  yearly,
  rarely,
  never,
}

@freezed
class Contact with _$Contact {
  const factory Contact({
    required int id,
    required String firstName,
    required String lastName,
    DateTime? birthday,
    required ContactFrequency frequency,
    DateTime? lastContacted,
  }) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) => _$ContactFromJson(json);
}