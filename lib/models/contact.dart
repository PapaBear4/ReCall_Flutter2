import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

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

class Contact extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime? birthday;
  final ContactFrequency frequency;
  final DateTime? lastContacted;

  Contact({
    String? id,
    required this.firstName,
    required this.lastName,
    this.birthday,
    required this.frequency,
    this.lastContacted,
  }) : id = id ?? const Uuid().v4();

  Contact copyWith({
    String? id,
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
      'contactFrequency': frequency,
      'lastContacted': lastContacted?.toIso8601String(),
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] as String,
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
}
