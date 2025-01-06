import 'package:objectbox/objectbox.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact.freezed.dart';
part 'contact.g.dart';

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

@Entity()
@unfreezed
class Contact with _$Contact {
  const Contact._();

  const factory Contact({
    int id,
    required final String firstName,
    required final String lastName,
    final DateTime? birthday,
    required final ContactFrequency frequency,
    final DateTime? lastContacted,
    @Id() int contactId,
  }) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
}
