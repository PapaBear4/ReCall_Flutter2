// lib/sources/data_source.dart

/// Abstract interface for data sources in the application
///
/// This interface defines the standard operations that all data sources must implement,
/// including CRUD operations and stream access methods. It serves as a contract
/// that all concrete data source implementations must fulfill, ensuring
/// consistency across different storage mechanisms.
library;

abstract class DataSource<T> {
  // MARK: - CRUD Operations

  /// Returns a list of all items in the data source
  ///
  /// This is the most basic retrieval operation and should return every item
  /// regardless of status or filter criteria.
  Future<List<T>> getAll();

  /// Returns a single item by ID or null if not found
  ///
  /// Provides direct access to a specific item when its ID is known.
  /// Returns null rather than throwing an exception when the item doesn't exist.
  Future<T?> getById(int id);

  /// Adds a new item to the data source and returns the updated item with an ID
  ///
  /// The returned item should include any fields that were generated or modified during
  /// the storage process, such as the assigned ID.
  Future<T> add(T item);

  /// Adds multiple items at once and returns them with assigned IDs
  ///
  /// A batch operation that's more efficient than calling add() multiple times.
  /// Returns all items with their newly assigned IDs.
  Future<List<T>> addMany(List<T> items);

  /// Updates an existing item and returns the updated version
  ///
  /// Used to modify an item that already exists in the data source.
  /// The implementation should verify the item exists before updating.
  Future<T> update(T item);

  /// Updates multiple items at once and returns the updated versions
  ///
  /// A batch operation for efficiently updating multiple items in a single transaction.
  /// All items should already exist in the data source.
  Future<List<T>> updateMany(List<T> items);

  /// Deletes an item by its ID
  ///
  /// Permanently removes the item from the data source.
  Future<void> delete(int id);

  /// Deletes multiple items by their IDs
  ///
  /// A batch operation for efficiently removing multiple items in a single operation.
  Future<void> deleteMany(List<int> ids);

  /// Deletes all items in the data source
  ///
  /// Completely clears the data source. This is a destructive operation
  /// and should be used with caution.
  Future<void> deleteAll();

  /// Returns the total count of items in the data source
  ///
  /// More efficient than fetching all items when only the count is needed.
  /// Use this for one-time count operations when reactive updates aren't needed.
  Future<int> count();

  // MARK: - STREAMS

  /// Returns a stream that emits all items in the data source
  Stream<List<T>> getAllStream();

  /// Returns a stream that emits a count based on the provided query name
  ///
  /// This provides reactive counts that update automatically when data changes.
  /// Use this when you need to display counts that should update in real-time.
  Stream<int> getCountStream(String queryName);

  // MARK: - Resource Management

  /// Cleans up resources used by the data source
  ///
  /// This method should be called when the data source is no longer needed.
  /// It should close any open streams, database connections, or other resources.
  void dispose();
}
