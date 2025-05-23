import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/models/enums.dart';
import 'package:recall/sources/contact_ob_source.dart';
import 'package:recall/objectbox.g.dart'; // For Contact_ and Order

// Import the generated mocks
import 'contact_ob_source_test.mocks.dart';

// Annotations for mockito code generation
@GenerateMocks([Box, Query]) // QueryBuilder should NOT be listed here
void main() {
  late MockBox<Contact> mockBox;
  late _MyMockQueryBuilder<Contact> mockQueryBuilder; 
  late MockQuery<Contact> mockQuery;
  late ContactObjectBoxSource dataSource;

  final contact1 = Contact(id: 1, firstName: 'John', lastName: 'Doe', frequency: ContactFrequency.daily.value);
  final contact2 = Contact(id: 2, firstName: 'Jane', lastName: 'Doe', frequency: ContactFrequency.weekly.value);
  final contactToAdd = Contact(firstName: 'New', lastName: 'Person');
  
  setUp(() {
    mockBox = MockBox<Contact>();
    mockQueryBuilder = _MyMockQueryBuilder<Contact>(); 
    mockQuery = MockQuery<Contact>();
    dataSource = ContactObjectBoxSource(mockBox);

    // Default behavior for query to find highest ID
    when(mockBox.query(any)).thenReturn(mockQueryBuilder); 
    when(mockQueryBuilder.order(Contact_.id, flags: Order.descending)).thenReturn(mockQueryBuilder);
    when(mockQueryBuilder.build()).thenReturn(mockQuery);
  });

  group('ContactObjectBoxSource Tests', () {
    test('add - should add a contact and return it with new ID', () async {
      when(mockQuery.findFirst()).thenReturn(null); // No existing contacts
      when(mockBox.put(any)).thenAnswer((realInvocation) {
        final contact = realInvocation.positionalArguments[0] as Contact;
        return contact.id!; 
      });
      
      final result = await dataSource.add(contactToAdd);

      expect(result.id, 1);
      expect(result.firstName, contactToAdd.firstName);
      verify(mockBox.put(argThat(isA<Contact>().having((c) => c.id, 'id', 1)))).called(1);
    });

    test('add - should assign next available ID if contacts exist', () async {
      when(mockQuery.findFirst()).thenReturn(contact1); // Highest ID is 1
      when(mockBox.put(any)).thenAnswer((realInvocation) {
         final contact = realInvocation.positionalArguments[0] as Contact;
        return contact.id!;
      });

      final result = await dataSource.add(contactToAdd);

      expect(result.id, 2); // contact1.id (1) + 1
      verify(mockBox.put(argThat(isA<Contact>().having((c) => c.id, 'id', 2)))).called(1);
    });

    test('addMany - should add multiple contacts and return them with new IDs', () async {
      final items = [
        Contact(firstName: 'Alice', lastName: 'A'),
        Contact(firstName: 'Bob', lastName: 'B'),
      ];
      when(mockQuery.findFirst()).thenReturn(null); // No existing contacts
      when(mockBox.putMany(any)).thenAnswer((realInvocation) {
        final List<Contact> contacts = realInvocation.positionalArguments[0];
        return contacts.map((c) => c.id!).toList(); 
      });

      final results = await dataSource.addMany(items);

      expect(results.length, 2);
      expect(results[0].id, 1);
      expect(results[1].id, 2);
      verify(mockBox.putMany(argThat(isList.having((list) => list.length, 'length', 2)
        .having((list) => (list[0] as Contact).id, 'item 0 id', 1)
        .having((list) => (list[1] as Contact).id, 'item 1 id', 2)
      ))).called(1);
    });
    
    test('addMany - with existing contacts, should assign correct next IDs', () async {
      final items = [
        Contact(firstName: 'Alice', lastName: 'A'),
        Contact(firstName: 'Bob', lastName: 'B'),
      ];
      when(mockQuery.findFirst()).thenReturn(contact2); // Highest ID is 2
      when(mockBox.putMany(any)).thenAnswer((realInvocation) {
        final List<Contact> contacts = realInvocation.positionalArguments[0];
        return contacts.map((c) => c.id!).toList();
      });

      final results = await dataSource.addMany(items);

      expect(results.length, 2);
      expect(results[0].id, 3); // contact2.id (2) + 1
      expect(results[1].id, 4); // contact2.id (2) + 2
      verify(mockBox.putMany(argThat(isList.having((list) => list.length, 'length', 2)
        .having((list) => (list[0] as Contact).id, 'item 0 id', 3)
        .having((list) => (list[1] as Contact).id, 'item 1 id', 4)
      ))).called(1);
    });

    test('getAll - should return all contacts from box', () async {
      when(mockBox.getAll()).thenAnswer((_) => [contact1, contact2]);
      final results = await dataSource.getAll();
      expect(results.length, 2);
      expect(results, containsAll([contact1, contact2]));
      verify(mockBox.getAll()).called(1);
    });

    test('getById - should return contact with matching ID from box', () async {
      when(mockBox.get(contact1.id!)).thenAnswer((_) => contact1);
      final result = await dataSource.getById(contact1.id!);
      expect(result, contact1);
      verify(mockBox.get(contact1.id!)).called(1);
    });
    
    test('getById - should return null if contact not found', () async {
      when(mockBox.get(99)).thenAnswer((_) => null);
      final result = await dataSource.getById(99);
      expect(result, isNull);
      verify(mockBox.get(99)).called(1);
    });

    test('update - should put item to box and return it', () async {
      final updatedContact = contact1.copyWith(firstName: 'Johnny');
      when(mockBox.put(updatedContact)).thenAnswer((_) => updatedContact.id!); 

      final result = await dataSource.add(updatedContact);

      expect(result.id, updatedContact.id);
      expect(result.firstName, 'Johnny');
      verify(mockBox.put(updatedContact)).called(1);
    });

    test('delete - should remove item from box by ID', () async {
      when(mockBox.remove(contact1.id!)).thenAnswer((_) => true); // Simulate successful removal
      await dataSource.delete(contact1.id!);
      verify(mockBox.remove(contact1.id!)).called(1);
    });

    test('deleteMany - should remove items from box by IDs', () async {
      final idsToRemove = [contact1.id!, contact2.id!];
      when(mockBox.removeMany(idsToRemove)).thenAnswer((_) => idsToRemove.length); // Simulate count of removed items
      await dataSource.deleteMany(idsToRemove);
      verify(mockBox.removeMany(idsToRemove)).called(1);
    });

    test('count - should return count from box', () async {
      when(mockBox.count()).thenAnswer((_) => 5);
      final result = await dataSource.count();
      expect(result, 5);
      verify(mockBox.count()).called(1);
    });

    test('deleteAll - should call removeAll on box', () async {
      when(mockBox.removeAll()).thenAnswer((_) => 10); // Simulate 10 items removed
      await dataSource.deleteAll();
      verify(mockBox.removeAll()).called(1);
    });
  });
}

// Define a manual mock class for QueryBuilder
class _MyMockQueryBuilder<T> extends Mock implements QueryBuilder<T> {}
