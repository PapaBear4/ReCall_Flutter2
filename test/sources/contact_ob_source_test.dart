import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/models/contact_enums.dart';
import 'package:recall/objectbox.g.dart'; // For Contact_ and Condition
import 'package:recall/sources/contact_ob_source.dart';

// Import the generated mocks
import 'contact_ob_source_test.mocks.dart';

// --- Explicit Mock Class Definitions ---
class MockBoxContact extends Mock implements Box<Contact> {}
class MockQueryContact extends Mock implements Query<Contact> {}
// Keep MockQueryBuilder defined at the bottom if needed for intermediate stubbing

// Annotation to generate implementations for the mocks above
@GenerateNiceMocks([
  MockSpec<Box<Contact>>(as: #MockBoxContact), // Use 'as' to link spec to class
  MockSpec<Query<Contact>>(as: #MockQueryContact),
])
void main() {
  // Use the explicitly defined mock types
  late MockBoxContact mockBox;
  late MockQueryContact mockQueryActive;
  late MockQueryContact mockQueryArchived;
  late MockQueryContact mockQueryAll;
  late ContactObjectBoxSource dataSource;

  // Helper function to create a dummy contact
  Contact createContact(int id, {bool isActive = true}) => Contact(
        id: id,
        firstName: 'First$id',
        lastName: 'Last$id',
        isActive: isActive,
        frequency: ContactFrequency.monthly.value,
      );

  setUp(() {
    // Create mocks using the explicitly defined classes
    mockBox = MockBoxContact();
    mockQueryActive = MockQueryContact();
    mockQueryArchived = MockQueryContact();
    mockQueryAll = MockQueryContact();

    // --- Adjusted Stubbing (using intermediate MockQueryBuilder) ---
    // Need intermediate mocks because the source code calls .build() on the result of .query()
    final mockQueryBuilderActive = MockQueryBuilder<Contact>();
    final mockQueryBuilderArchived = MockQueryBuilder<Contact>();
    final mockQueryBuilderAll = MockQueryBuilder<Contact>();

    when(mockBox.query(argThat(isA<Condition<Contact>>()
        .having((c) => c.toString(), 'toString', contains('Contact_.isActive.equals(true)')))))
        .thenReturn(mockQueryBuilderActive);
    when(mockQueryBuilderActive.build()).thenReturn(mockQueryActive); // Return MockQueryContact

    when(mockBox.query(argThat(isA<Condition<Contact>>()
        .having((c) => c.toString(), 'toString', contains('Contact_.isActive.equals(false)')))))
        .thenReturn(mockQueryBuilderArchived);
    when(mockQueryBuilderArchived.build()).thenReturn(mockQueryArchived); // Return MockQueryContact

    // Stub for the 'all' query (assuming it's called with no condition)
    when(mockBox.query(null)).thenReturn(mockQueryBuilderAll);
    when(mockQueryBuilderAll.build()).thenReturn(mockQueryAll); // Return MockQueryContact

    // Stub query stream methods with explicit casting
    // TODO: fix this to avoid explicit casting
    /*
    when(mockQueryActive.stream())
        .thenAnswer((_) => Stream<List<Contact>>.value([]) as Stream<List<Contact>>); // Explicit cast
    when(mockQueryArchived.stream())
        .thenAnswer((_) => Stream<List<Contact>>.value([]) as Stream<List<Contact>>); // Explicit cast
    when(mockQueryAll.stream())
        .thenAnswer((_) => Stream<List<Contact>>.value([]) as Stream<List<Contact>>); // Explicit cast
*/
    // Stub query count methods
    when(mockQueryActive.count()).thenReturn(0);
    when(mockQueryArchived.count()).thenReturn(0);
    when(mockQueryAll.count()).thenReturn(0);

    // Stub close methods for queries
    when(mockQueryActive.close()).thenReturn(null);
    when(mockQueryArchived.close()).thenReturn(null);
    when(mockQueryAll.close()).thenReturn(null);

    // Create the data source instance
    dataSource = ContactObjectBoxSource(mockBox);

    // Clear interactions if needed (especially if setup runs multiple times)
    clearInteractions(mockBox);
    clearInteractions(mockQueryActive);
    clearInteractions(mockQueryArchived);
    clearInteractions(mockQueryAll);

    // Re-apply stubs needed after constructor/clearing with explicit casting
    when(mockBox.query(argThat(isA<Condition<Contact>>()
        .having((c) => c.toString(), 'toString', contains('Contact_.isActive.equals(true)')))))
        .thenReturn(mockQueryBuilderActive);
    when(mockQueryBuilderActive.build()).thenReturn(mockQueryActive);
    when(mockBox.query(argThat(isA<Condition<Contact>>()
        .having((c) => c.toString(), 'toString', contains('Contact_.isActive.equals(false)')))))
        .thenReturn(mockQueryBuilderArchived);
    when(mockQueryBuilderArchived.build()).thenReturn(mockQueryArchived);
    when(mockBox.query(null)).thenReturn(mockQueryBuilderAll);
    when(mockQueryBuilderAll.build()).thenReturn(mockQueryAll);
    //TODO: fix this to avoid explicit casting
    /*
    when(mockQueryActive.stream()).thenAnswer((_) => Stream<List<Contact>>.value([]) as Stream<List<Contact>>); // Explicit cast
    when(mockQueryArchived.stream()).thenAnswer((_) => Stream<List<Contact>>.value([]) as Stream<List<Contact>>); // Explicit cast
    when(mockQueryAll.stream()).thenAnswer((_) => Stream<List<Contact>>.value([]) as Stream<List<Contact>>); // Explicit cast
   */ when(mockQueryActive.count()).thenReturn(0);
    when(mockQueryArchived.count()).thenReturn(0);
    when(mockQueryAll.count()).thenReturn(0);
    when(mockQueryActive.close()).thenReturn(null);
    when(mockQueryArchived.close()).thenReturn(null);
    when(mockQueryAll.close()).thenReturn(null);
  });

  tearDown(() {
    dataSource.dispose(); // Ensure queries are closed
  });

  group('ContactObjectBoxSource Tests', () {
    test('Constructor initializes query builders', () {
      expect(dataSource, isNotNull);
      expect(() => dataSource.getAllStream(), returnsNormally);
      expect(() => dataSource.getActiveContactStream(), returnsNormally);
    });

    test('add() puts item in box and returns with ID', () async {
      final contact = createContact(0); // ID 0 or null before adding
      when(mockBox.put(contact)).thenReturn(1); // Simulate assigning ID 1

      final addedContact = await dataSource.add(contact);

      verify(mockBox.put(contact)).called(1);
      expect(addedContact.id, 1);
      expect(addedContact.firstName, contact.firstName);
    });

    test('addMany() puts items in box and returns with IDs', () async {
      final contacts = [createContact(0), createContact(0)];
      final expectedIds = [1, 2];
      when(mockBox.putMany(contacts)).thenReturn(expectedIds);

      final addedContacts = await dataSource.addMany(contacts);

      verify(mockBox.putMany(contacts)).called(1);
      expect(addedContacts.length, 2);
      expect(addedContacts[0].id, 1);
      expect(addedContacts[1].id, 2);
    });

    test('update() puts item in box', () async {
      final contact = createContact(1);
      when(mockBox.put(contact)).thenReturn(1); // put returns the ID

      final updatedContact = await dataSource.update(contact);

      verify(mockBox.put(contact)).called(1);
      expect(updatedContact.id, 1); // ID should remain the same
    });

    test('updateMany() puts items in box', () async {
      final contacts = [createContact(1), createContact(2)];
      final expectedIds = [1, 2];
      when(mockBox.putMany(contacts)).thenReturn(expectedIds);

      final updatedContacts = await dataSource.updateMany(contacts);

      verify(mockBox.putMany(contacts)).called(1);
      expect(updatedContacts.length, 2);
      expect(updatedContacts[0].id, 1);
      expect(updatedContacts[1].id, 2);
    });

    test('delete() removes item from box', () async {
      const id = 1;
      when(mockBox.remove(id)).thenReturn(true); // Simulate successful removal

      await dataSource.delete(id);

      verify(mockBox.remove(id)).called(1);
    });

    test('deleteMany() removes items from box', () async {
      final ids = [1, 2];
      when(mockBox.removeMany(ids)).thenReturn(2); // Simulate removing 2 items

      await dataSource.deleteMany(ids);

      verify(mockBox.removeMany(ids)).called(1);
    });

    test('deleteAll() removes all items from box', () async {
      when(mockBox.removeAll()).thenReturn(5); // Simulate removing 5 items

      await dataSource.deleteAll();

      verify(mockBox.removeAll()).called(1);
    });

    test('getById() gets item from box', () async {
      const id = 1;
      final contact = createContact(id);
      when(mockBox.get(id)).thenReturn(contact);

      final result = await dataSource.getById(id);

      verify(mockBox.get(id)).called(1);
      expect(result, contact);
    });

    test('getAll() gets all items from box', () async {
      final contacts = [createContact(1), createContact(2)];
      when(mockBox.getAll()).thenReturn(contacts);

      final result = await dataSource.getAll();

      verify(mockBox.getAll()).called(1);
      expect(result, contacts);
    });

    test('count() gets count from box', () async {
      when(mockBox.count()).thenReturn(10);

      final result = await dataSource.count();

      verify(mockBox.count()).called(1);
      expect(result, 10);
    });

    test('getAllStream() returns stream from "all" query', () {
      final stream = dataSource.getAllStream();
      expect(stream, isNotNull);
      verify(mockQueryAll.stream()).called(1);
    });

    test('getActiveContactStream() returns stream from "active" query', () {
      //TODO: figure this one out
    });

    test('getCountStream() returns count stream for known query', () {
      //TODO: figure this one out
    });

    test('getCountStream() throws for unknown query', () {
      expect(() => dataSource.getCountStream('unknown_query'),
          throwsArgumentError);
    });

    test('getActiveContactCount() returns count from query', () async {
      when(mockQueryActive.count()).thenReturn(3);

      final count = await dataSource.getActiveContactCount();

      expect(count, 3);
      verify(mockQueryActive.count()).called(1);
      verify(mockQueryActive.close()).called(1);
    });

    test('dispose() closes all cached queries', () {
      dataSource.getAllStream();
      dataSource.getActiveContactStream();
      dataSource.getCountStream(ContactQueryNames.active);

      dataSource.dispose();

      verify(mockQueryAll.close()).called(1);
      verify(mockQueryActive.close()).called(1);
      verifyNever(mockQueryArchived.close());
    });
  });
}

// Need to define this intermediate mock because the source code uses it
class MockQueryBuilder<T> extends Mock implements QueryBuilder<T> {}
