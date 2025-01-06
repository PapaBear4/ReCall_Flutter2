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
    @Id(assignable: true) int? id,
    required String firstName,
    required String lastName,
    required ContactFrequency frequency,
    @Property(type: PropertyType.date) DateTime? birthday,
    @Property(type: PropertyType.date) DateTime? lastContacted,
  }) = _Contact;

  // ObjectBox Constructor (No @Id and default values)
  factory Contact.objectbox({
    required String firstName,
    required String lastName,
    required ContactFrequency frequency,
    DateTime? birthday,
    DateTime? lastContacted,
  }) {
    final contact = Contact(
      id: 0,
      firstName: firstName,
      lastName: lastName,
      frequency: frequency,
      birthday: birthday,
      lastContacted: lastContacted,
    );
    contact.dbFrequency = frequency.index; // Set dbFrequency using the setter
    return contact;
  }

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);

  @Transient()
  ContactFrequency get frequency {
    _ensureStableEnumValues();
    return ContactFrequency.values[dbFrequency!];
  }

  @Property(type: PropertyType.int)
  int? get dbFrequency {
    _ensureStableEnumValues();
    return _dbFrequency;
  }

  int? _dbFrequency;

  set dbFrequency(int? value) {
    _ensureStableEnumValues();
    _dbFrequency = value;
  }

  void _ensureStableEnumValues() {
    assert(ContactFrequency.daily.index == 0);
    assert(ContactFrequency.weekly.index == 1);
    assert(ContactFrequency.biWeekly.index == 2);
    assert(ContactFrequency.monthly.index == 3);
    assert(ContactFrequency.quarterly.index == 4);
    assert(ContactFrequency.yearly.index == 5);
    assert(ContactFrequency.rarely.index == 6);
    assert(ContactFrequency.never.index == 7);
  }
}