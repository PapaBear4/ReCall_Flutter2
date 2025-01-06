//TODO: replace with freezed
import 'package:equatable/equatable.dart';

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

//TODO: replaced with freeze
class Contact extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final DateTime? birthday;
  final ContactFrequency frequency;
  final DateTime? lastContacted;

  const Contact({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.birthday,
    required this.frequency,
    this.lastContacted,
  });

  Contact copyWith({
    int? id,
    String? firstName,
    String? lastName,
    DateTime? birthday,
    ContactFrequency? frequency,
    DateTime? lastContacted,
  }) {
    return Contact(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthday: birthday ?? this.birthday,
      frequency: frequency ?? this.frequency,
      lastContacted: lastContacted ?? this.lastContacted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        birthday,
        frequency,
        lastContacted,
      ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'birthday': birthday?.toIso8601String(),
      'frequency': frequency.name,
      'lastContacted': lastContacted?.toIso8601String(),
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] as int,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      birthday: map['birthday'] != null
          ? DateTime.parse(map['birthday'] as String)
          : null,
      frequency: map['frequency'] as ContactFrequency,
      lastContacted: map['lastContacted'] != null
          ? DateTime.parse(map['lastContacted'] as String)
          : null,
    );
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
  return Contact(
    id: json['id'] as int,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    birthday: json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
    frequency: ContactFrequency.values.byName(json['frequency']), // Parse enum
    lastContacted: json['lastContacted'] != null ? DateTime.parse(json['lastContacted']) : null,
  );
}

}
