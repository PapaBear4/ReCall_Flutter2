import 'package:objectbox/objectbox.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact.freezed.dart';
part 'contact.g.dart';

enum ContactFrequency {
  @Property(type: PropertyType.int)
  daily,
  @Property(type: PropertyType.int)
  weekly,
  @Property(type: PropertyType.int)
  biWeekly,
  @Property(type: PropertyType.int)
  monthly,
  @Property(type: PropertyType.int)
  quarterly,
  @Property(type: PropertyType.int)
  yearly,
  @Property(type: PropertyType.int)
  rarely,
  @Property(type: PropertyType.int)
  never,
}

@freezed
class Contact with _$Contact {
  const Contact._();

  @Entity(realClass: Contact)
  factory Contact({
    @Id(assignable: true) required int? id,
    required String firstName,
    required String lastName,
    required ContactFrequency frequency,
    DateTime? birthday,
    DateTime? lastContacted,
  }) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
}
