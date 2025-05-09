import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/models/enums.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:recall/objectbox.g.dart'; // For Store, Box, Query, Contact_, Order

// Import generated mocks
import 'contact_repository_test.mocks.dart';

// Manual mock for QueryBuilder if not already globally available
class _MyMockQueryBuilder<T> extends Mock implements QueryBuilder<T> {}

@GenerateMocks([Store, Box, Query])
void main() {
  late MockStore mockStore;
  late MockBox<Contact> mockBox;
  late _MyMockQueryBuilder<Contact> mockQueryBuilder;
  late MockQuery<Contact> mockQuery;
  late ContactRepository contactRepository;

  final contact1 = Contact(id: 1, firstName: 'John', lastName: 'Doe', frequency: ContactFrequency.daily.value, lastContacted: DateTime(2023,1,1));
  final contact2 = Contact(id: 2, firstName: 'Jane', lastName: 'Smith', frequency: ContactFrequency.weekly.value, lastContacted: DateTime(2023,1,1));
  final contactToAdd = Contact(firstName: 'New', lastName: 'Person', frequency: ContactFrequency.monthly.value, lastContacted: DateTime(2023,1,1));

  setUp(() {
    mockStore = MockStore();
    mockBox = MockBox<Contact>();
    mockQueryBuilder = _MyMockQueryBuilder<Contact>();
    mockQuery = MockQuery<Contact>();

    // Setup mock interactions for ObjectBox initialization within Repository
    // This assumes kIsWeb is false
    when(mockStore.box<Contact>()).thenReturn(mockBox);

    // Setup for ContactObjectBoxSource's ID generation and put operations
    when(mockBox.query(any)).thenReturn(mockQueryBuilder);
    when(mockQueryBuilder.order(Contact_.id, flags: Order.descending)).thenReturn(mockQueryBuilder);
    when(mockQueryBuilder.build()).thenReturn(mockQuery);

    contactRepository = ContactRepository(mockStore);
  });

  group('ContactRepository Tests', () {
    test('getAll - should fetch from source and update cache', () async {
      when(mockBox.getAll()).thenAnswer((_) => [contact1, contact2]);

      final result = await contactRepository.getAll();

      expect(result.length, 2);
      expect(result, containsAll([contact1, contact2]));
      // Verify cache
      expect(await contactRepository.getById(contact1.id!), contact1);
      verify(mockBox.getAll()).called(1);
    });

    test('getById - cache hit', () async {
      // Pre-populate cache by calling getAll first
      when(mockBox.getAll()).thenAnswer((_) => [contact1]);
      await contactRepository.getAll();
      // Clear mockBox interactions to ensure getById doesn't call it for a cache hit
      clearInteractions(mockBox);

      final result = await contactRepository.getById(contact1.id!);
      expect(result, contact1);
      verifyNever(mockBox.get(any)); // Should not call source if cache hit
    });

    test('getById - cache miss', () async {
      when(mockBox.getAll()).thenAnswer((_) => []); // Ensure cache is empty
      await contactRepository.getAll();
      clearInteractions(mockBox); // Clear getAll interaction

      when(mockBox.get(contact1.id!)).thenAnswer((_) => contact1);

      final result = await contactRepository.getById(contact1.id!);
      expect(result, contact1);
      verify(mockBox.get(contact1.id!)).called(1);
    });

    test('add - should calculate nextContact, add to source, and update cache', () async {
      // Mocking ContactObjectBoxSource's ID generation behavior
      when(mockQuery.findFirst()).thenReturn(null); // No existing contacts, so next ID will be 1
      final expectedAddedContact = contactToAdd.copyWith(
        id: 1,
        // nextContact will be calculated by the repository
        // For monthly from Jan 1, 2023, next is Feb 1, 2023
        nextContact: DateTime(2023, 2, 1) 
      );
      when(mockBox.put(any)).thenAnswer((invocation) {
        final c = invocation.positionalArguments[0] as Contact;
        return c.id!; // ObjectBox put returns the ID
      });
      
      final result = await contactRepository.add(contactToAdd);

      expect(result.id, 1);
      expect(result.firstName, contactToAdd.firstName);
      expect(result.nextContact, DateTime(2023,2,1));
      
      // Verify that the item passed to mockBox.put has the calculated nextContact
      final captured = verify(mockBox.put(captureAny)).captured.single as Contact;
      expect(captured.id, 1);
      expect(captured.nextContact, DateTime(2023,2,1));
      
      // Verify cache
      expect(await contactRepository.getById(result.id!), result);
    });
    
    test('add - inactive contact should have null nextContact', () async {
      final inactiveContact = Contact(firstName: 'Inactive', lastName: 'User', isActive: false, frequency: ContactFrequency.daily.value);
      when(mockQuery.findFirst()).thenReturn(null);
      when(mockBox.put(any)).thenAnswer((inv) => (inv.positionalArguments[0] as Contact).id!);

      final result = await contactRepository.add(inactiveContact);
      
      expect(result.id, 1);
      expect(result.nextContact, isNull);
      final captured = verify(mockBox.put(captureAny)).captured.single as Contact;
      expect(captured.nextContact, isNull);
    });

    test('update - should calculate nextContact, update in source, and update cache', () async {
      // Pre-populate cache
      when(mockBox.getAll()).thenAnswer((_) => [contact1]);
      await contactRepository.getAll();
      clearInteractions(mockBox); // Clear interactions from getAll

      final updatedContactData = contact1.copyWith(
        frequency: ContactFrequency.yearly.value, 
        lastContacted: DateTime(2023, 6, 15) // New lastContacted
      );
      // Expected nextContact: June 15, 2024
      final expectedNextContact = DateTime(2024, 6, 15); 

      when(mockBox.put(any)).thenAnswer((invocation) {
         final c = invocation.positionalArguments[0] as Contact;
        return c.id!;
      });

      final result = await contactRepository.update(updatedContactData);

      expect(result.id, contact1.id);
      expect(result.frequency, ContactFrequency.yearly.value);
      expect(result.nextContact, expectedNextContact);

      final captured = verify(mockBox.put(captureAny)).captured.single as Contact;
      expect(captured.id, contact1.id);
      expect(captured.nextContact, expectedNextContact);
      
      // Verify cache
      final cachedContact = await contactRepository.getById(result.id!);
      expect(cachedContact, result);
      expect(cachedContact?.nextContact, expectedNextContact);
    });
    
    test('update - setting frequency to never should nullify nextContact and lastContacted', () async {
      final contactToMakeNever = contact1.copyWith(lastContacted: DateTime.now(), nextContact: DateTime.now().add(Duration(days: 5)));
      when(mockBox.getAll()).thenAnswer((_) => [contactToMakeNever]);
      await contactRepository.getAll();
      clearInteractions(mockBox);

      final updatedToNever = contactToMakeNever.copyWith(frequency: ContactFrequency.never.value);
      when(mockBox.put(any)).thenAnswer((inv) => (inv.positionalArguments[0] as Contact).id!);
      
      final result = await contactRepository.update(updatedToNever);

      expect(result.frequency, ContactFrequency.never.value);
      expect(result.nextContact, isNull);
      expect(result.lastContacted, isNull); // As per repo logic

      final captured = verify(mockBox.put(captureAny)).captured.single as Contact;
      expect(captured.nextContact, isNull);
      expect(captured.lastContacted, isNull);
    });


    test('delete - should delete from source and remove from cache', () async {
      // Pre-populate cache
      when(mockBox.getAll()).thenAnswer((_) => [contact1]);
      await contactRepository.getAll();
      
      when(mockBox.remove(contact1.id!)).thenAnswer((_) => true);

      await contactRepository.delete(contact1.id!);

      verify(mockBox.remove(contact1.id!)).called(1);
      // Verify cache
      clearInteractions(mockBox); // To ensure getById doesn't call source
      when(mockBox.get(contact1.id!)).thenAnswer((_) => null); // Simulate it's gone from source
      expect(await contactRepository.getById(contact1.id!), isNull);
    });

    test('addMany - should add to source and update cache', () async {
      final itemsToAdd = [
        Contact(firstName: 'Multi1', lastName: 'UserA', frequency: ContactFrequency.daily.value),
        Contact(firstName: 'Multi2', lastName: 'UserB', frequency: ContactFrequency.weekly.value),
      ];
      // Mocking ContactObjectBoxSource's ID generation for addMany
      when(mockQuery.findFirst()).thenReturn(contact2); // Assume contact2 (id:2) is highest existing
      
      // ContactObjectBoxSource will assign IDs 3 and 4
      final expectedAddedItems = [
        itemsToAdd[0].copyWith(id: 3), 
        itemsToAdd[1].copyWith(id: 4),
      ];

      when(mockBox.putMany(any)).thenAnswer((invocation) {
        final List<Contact> contacts = invocation.positionalArguments[0];
        return contacts.map((c) => c.id!).toList(); // Return the IDs assigned by ContactObjectBoxSource
      });

      final results = await contactRepository.addMany(itemsToAdd);

      expect(results.length, 2);
      expect(results[0].id, 3);
      expect(results[1].id, 4);

      final captured = verify(mockBox.putMany(captureAny)).captured.single as List<Contact>;
      expect(captured.length, 2);
      expect(captured[0].id, 3); // Verify IDs passed to putMany
      expect(captured[1].id, 4);

      // Verify cache
      expect(await contactRepository.getById(3), results[0]);
      expect(await contactRepository.getById(4), results[1]);
    });

    test('deleteMany - should delete from source and remove from cache', () async {
      when(mockBox.getAll()).thenAnswer((_) => [contact1, contact2]);
      await contactRepository.getAll(); // Populate cache

      final idsToDelete = [contact1.id!, contact2.id!];
      when(mockBox.removeMany(idsToDelete)).thenAnswer((_) => idsToDelete.length);

      await contactRepository.deleteMany(idsToDelete);

      verify(mockBox.removeMany(idsToDelete)).called(1);
      // Verify cache
      clearInteractions(mockBox);
      when(mockBox.get(contact1.id!)).thenAnswer((_) => null);
      when(mockBox.get(contact2.id!)).thenAnswer((_) => null);
      expect(await contactRepository.getById(contact1.id!), isNull);
      expect(await contactRepository.getById(contact2.id!), isNull);
    });

    test('getContactsCount - should return count from source', () async {
      when(mockBox.count()).thenAnswer((_) => 5);
      final count = await contactRepository.getContactsCount();
      expect(count, 5);
      verify(mockBox.count()).called(1);
    });

    test('deleteAll - should delete all from source and clear cache', () async {
      when(mockBox.getAll()).thenAnswer((_) => [contact1, contact2]);
      await contactRepository.getAll(); // Populate cache
      expect(await contactRepository.getById(contact1.id!), isNotNull);


      when(mockBox.removeAll()).thenAnswer((_) => 2); // Simulate 2 items removed
      await contactRepository.deleteAll();

      verify(mockBox.removeAll()).called(1);
      // Verify cache is cleared
      clearInteractions(mockBox);
      when(mockBox.get(contact1.id!)).thenAnswer((_)  => null);
      expect(await contactRepository.getById(contact1.id!), isNull);
      
      // Also check if getAll returns empty after deleteAll
      when(mockBox.getAll()).thenAnswer((_) => []);
      final contactsAfterDeleteAll = await contactRepository.getAll();
      expect(contactsAfterDeleteAll, isEmpty);
    });
  });
}
