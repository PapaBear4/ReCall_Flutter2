// lib/sources/contact_ob_source.dart
import 'dart:async';
import 'package:recall/utils/logger.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/objectbox.g.dart';
import 'package:recall/sources/data_source.dart';

/// Names for predefined contact queries
class ContactQueryNames {
  static const String active = 'active';
  static const String archived = 'archived';
  static const String overdue = 'overdue';
  static const String birthday = 'birthday';
  static const String anniversary = 'anniversary';
  static const String all = 'all';

  // Prevent instantiation
  ContactQueryNames._();
}

/// Data source for accessing Contact objects in ObjectBox database
class ContactObjectBoxSource implements DataSource<Contact> {
  final Box<Contact> _box;

  /// Map of query builders for predefined queries
  late final Map<String, QueryBuilder<Contact>> _queryBuilders;

  /// Map to store active query streams
  final Map<String, Stream<List<Contact>>> _streams = {};

  /// Map to store active count streams
  final Map<String, Stream<int>> _countStreams = {};

  /// Map of active query objects for cleanup
  final Map<String, Query<Contact>> _queries = {};

  /// Creates a new ContactObjectBoxSource with the given box
  ContactObjectBoxSource(this._box) {
    _initializeQueryBuilders();
  }

  /// Initializes predefined query builders
  void _initializeQueryBuilders() {
    _queryBuilders = {
      // Active contacts query
      ContactQueryNames.active: _box.query(Contact_.isActive.equals(true)),

      // Archived contacts query
      ContactQueryNames.archived: _box.query(Contact_.isActive.equals(false)),

      // All contacts query
      ContactQueryNames.all: _box.query(),

      // Other predefined queries
      // ...
    };
  }

  // MARK: - Basic CRUD Operations

  /// Gets all contacts from the database
  @override
  Future<List<Contact>> getAll() async {
    try {
      return _box.getAll();
    } catch (e) {
      logger.e("Error in ContactObjectBoxSource.getAll: $e");
      rethrow;
    }
  }

  /// Adds a new contact to the database
  @override
  Future<Contact> add(Contact item) async {
    logger.i('Adding contact: $item');

    // Let ObjectBox assign the ID
    final id = _box.put(item);
    logger.i('Contact added with ID: $id');

    return item.copyWith(id: id);
  }

  /// Adds multiple contacts at once
  @override
  Future<List<Contact>> addMany(List<Contact> items) async {
    if (items.isEmpty) return [];

    // Let ObjectBox assign IDs
    final ids = _box.putMany(items);

    // Create return list with the assigned IDs
    final updatedItems = <Contact>[];
    for (int i = 0; i < items.length; i++) {
      updatedItems.add(items[i].copyWith(id: ids[i]));
    }

    return updatedItems;
  }

  /// Updates an existing contact
  @override
  Future<Contact> update(Contact item) async {
    final id = _box.put(item);
    return item.copyWith(id: id);
  }

  /// Updates multiple contacts at once
  @override
  Future<List<Contact>> updateMany(List<Contact> items) async {
    if (items.isEmpty) return [];

    // Save all updated items at once
    final ids = _box.putMany(items);

    // Create return list with the confirmed IDs
    final updatedItems = <Contact>[];
    for (int i = 0; i < items.length; i++) {
      updatedItems.add(items[i].copyWith(id: ids[i]));
    }

    return updatedItems;
  }

  /// Deletes a single contact by ID
  @override
  Future<void> delete(int id) async {
    _box.remove(id);
  }

  /// Deletes multiple contacts by their IDs
  @override
  Future<void> deleteMany(List<int> ids) async {
    if (ids.isEmpty) return;

    _box.removeMany(ids);
  }

  /// Deletes all contacts from the database
  @override
  Future<void> deleteAll() async {
    _box.removeAll();
  }

  /// Gets the total count of contacts in the database
  @override
  Future<int> count() async {
    return _box.count();
  }

  /// Gets a single contact by ID
  @override
  Future<Contact?> getById(int id) async {
    return _box.get(id);
  }

  // MARK: - Stream Access Methods

  /// Gets a stream of all contacts
  @override
  Stream<List<Contact>> getAllStream() {
    const queryName = ContactQueryNames.all;
    // Check if a stream for 'all' contacts already exists
    if (_streams.containsKey(queryName)) {
      return _streams[queryName]!;
    }

    // Get the query builder for the 'all' query
    final queryBuilder = _queryBuilders[queryName];
    if (queryBuilder == null) {
      // This should ideally not happen if initialized correctly
      throw StateError('Query builder for "$queryName" not found.');
    }

    // Build the query
    final query = queryBuilder.build();

    // Store the query for later disposal
    _queries[queryName] = query;

    // Create the stream from the query
    final stream = query.stream();

    // Store the stream
    _streams[queryName] = stream as Stream<List<Contact>>;

    return stream as Stream<List<Contact>>;
  }

  /// Gets a stream of active contacts
  Stream<List<Contact>> getActiveContactStream() {
    // TODO: Convert this to a getFilteredContactStream method that accepts a query name
    const queryName = ContactQueryNames.active;
    // Check if a stream for 'active' contacts already exists
    if (_streams.containsKey(queryName)) {
      return _streams[queryName]!;
    }

    // Get the query builder for the 'active' query
    final queryBuilder = _queryBuilders[queryName];
     if (queryBuilder == null) {
      // This should ideally not happen if initialized correctly
      throw StateError('Query builder for "$queryName" not found.');
    }

    // Build the query
    final query = queryBuilder.build();

    // Store the query for later disposal
    _queries[queryName] = query;

    // Create the stream from the query
    final stream = query.stream();

    // Store the stream
    _streams[queryName] = stream as Stream<List<Contact>>;

    return stream as Stream<List<Contact>>;
  }


  /// Gets a stream with the count of contacts matching the named query
  @override
  Stream<int> getCountStream(String queryName) {
    // Check if a count stream for this query already exists
    if (_countStreams.containsKey(queryName)) {
      return _countStreams[queryName]!;
    }

    // Get the query builder for the given name
    final queryBuilder = _queryBuilders[queryName];
    if (queryBuilder == null) {
      throw ArgumentError('Unknown query name: $queryName');
    }

    // Build the query
    final query = queryBuilder.build();

    // Store the query for later disposal
    _queries[queryName] = query;

    // Create a stream that emits the count every time the data changes
    final stream = query.stream().map((_) {
      // Return the count of items matching this query
      return query.count();
    }).distinct(); // Ensure we only emit distinct counts

    // Store the count stream
    _countStreams[queryName] = stream;

    return stream;
  }

  /// Gets the current count of active contacts
  Future<int> getActiveContactCount() async {
    try {
      // Create a query for active contacts
      final query = _box.query(Contact_.isActive.equals(true)).build();
      
      // Get the count
      final count = query.count();
      
      // Close the query to free resources
      query.close();
      
      return count;
    } catch (e) {
      logger.e("Error counting active contacts: $e");
      rethrow;
    }
  }

  // MARK: - Resource Management

  /// Releases resources used by this data source
  @override
  void dispose() {
    // Close all active queries stored in the _queries map
    logger.d("Closing ${_queries.length} queries.");
    for (final query in _queries.values) {
      query.close();
    }

    _queries.clear();
    _streams.clear();
    _countStreams.clear();
    logger.d("ContactObjectBoxSource disposed.");
  }
}
