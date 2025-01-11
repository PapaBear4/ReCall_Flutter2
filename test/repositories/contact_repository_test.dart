// test/repositories/contact_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/models/contact.dart';
import 'package:objectbox/objectbox.dart';
import 'package:mockito/mockito.dart';

class MockStore extends Mock implements Store {
  MockContactBox? _mockBox; // Use MockContactBox here

  @override
  Box<T> box<T>() {
    if (T == Contact) {
      _mockBox ??= MockContactBox();
      return _mockBox! as Box<T>;
    }
    throw UnsupportedError('Unsupported box type: $T');
  }
}
class MockContactBox extends Mock implements Box<Contact> {
  final _contacts = <int, Contact>{};
  int _nextId = 1;

  @override
  bool isEmpty() => _contacts.isEmpty; 

  @override
  int put(Contact entity, {PutMode mode = PutMode.put}) {
    entity = entity.copyWith(id: entity.id ?? _nextId++);
    _contacts[entity.id!] = entity;
    return entity.id!;
  }

  @override
  List<int> putMany(List<Contact> entities, {PutMode mode = PutMode.put}) {
    final ids = <int>[];
    for (var entity in entities) {
      ids.add(put(entity, mode: mode));
    }
    return ids;
  }

  @override
  Contact? get(int id) {
    return _contacts[id];
  }

  @override
  List<Contact> getAll() {
    return _contacts.values.toList();
  }

  @override
  bool remove(int id) {
    _contacts.remove(id);
    return true; // Return a value to match the Box interface
  }
}

void main() {
  late ContactRepository repository;
  late MockStore mockStore;

  setUp(() {
    mockStore = MockStore();
    repository = ContactRepository(mockStore);
  });

  group('ContactRepository', () {
    test('Can add and retrieve a contact', () async {
      final newContact = Contact(
        firstName: 'John',
        lastName: 'Doe',
        frequency: 'rarely',
      );
      repository = ContactRepository(MockStore());

      final addedContact = await repository.add(newContact);
      expect(addedContact, isNotNull);
      expect(addedContact.id, greaterThan(0));

      final retrievedContact = await repository.getById(addedContact.id!);
      expect(retrievedContact, equals(addedContact));
    });

    test('Can get all contacts', () async {
      final contact1 = Contact(
        firstName: 'John',
        lastName: 'Doe',
        frequency: 'rarely',
      );
      repository = ContactRepository(MockStore());
      final contact2 = Contact(
        firstName: 'Jane',
        lastName: 'Doe',
        frequency: 'biweekly',
      );

      await repository.add(contact1);
      await repository.add(contact2);

      final contacts = await repository.getAll();

      expect(contacts, isNotEmpty);
      expect(contacts.length, 2);
      expect(contacts, contains(contact1.copyWith(id: contacts[0].id)));
      expect(contacts, contains(contact2.copyWith(id: contacts[1].id)));
    });

    test('Can get a contact by ID', () async {
      final contact = Contact(
        firstName: 'John',
        lastName: 'Doe',
        frequency: 'rarely',
      );
      repository = ContactRepository(MockStore());
      final addedContact = await repository.add(contact);

      final retrievedContact = await repository.getById(addedContact.id!);
      expect(retrievedContact, equals(addedContact));
    });

    test('Returns null for invalid ID', () async {
      repository = ContactRepository(MockStore());
      final retrievedContact =
          await repository.getById(999); // Assume 999 is an invalid ID
      expect(retrievedContact, isNull);
    });

    test('Can update a contact', () async {
      final contact = Contact(
        firstName: 'John',
        lastName: 'Doe',
        frequency: 'rarely',
      );
      repository = ContactRepository(MockStore());
      final addedContact = await repository.add(contact);

      final updatedContact = addedContact.copyWith(firstName: 'Jane');
      await repository.update(updatedContact);

      final retrievedContact = await repository.getById(addedContact.id!);
      expect(retrievedContact, isNotNull);
      expect(retrievedContact!.firstName, 'Jane');
    });

    test('Can delete a contact', () async {
      final contact = Contact(
        firstName: 'John',
        lastName: 'Doe',
        frequency: 'rarely',
      );
      repository = ContactRepository(MockStore());
      final addedContact = await repository.add(contact);

      await repository.delete(addedContact.id!);
      final retrievedContact = await repository.getById(addedContact.id!);
      expect(retrievedContact, isNull);
    });
  });
}
