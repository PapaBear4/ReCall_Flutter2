// lib/repositories/repository.dart

/// Generic repository interface for data access
/// 
/// This interface defines the standard operations that all repositories must implement,
/// providing a common way to interact with different types of data.
abstract class Repository<T> {
  /// Gets all items from the repository
  Future<List<T>> getAll();
  
  /// Gets a single item by its ID, returns null if not found
  Future<T?> getById(int id);
  
  /// Adds a new item to the repository
  Future<T> add(T item);
  
  /// Adds multiple items at once
  Future<List<T>> addMany(List<T> items);
  
  /// Updates an existing item in the repository
  Future<T> update(T item);
  
  /// Updates multiple items at once
  Future<List<T>> updateMany(List<T> items);
  
  /// Deletes an item by its ID
  Future<void> delete(int id);
  
  /// Deletes multiple items by their IDs
  Future<void> deleteMany(List<int> ids);
  
  /// Deletes all items in the repository
  Future<void> deleteAll();
  
  /// Returns a count of items in the repository
  Future<int> count();

  /// Returns a stream of all items in the repository
  Stream<List<T>> getAllStream();
  
  /// Returns a count stream based on query name
  Stream<int> getCountStream(String queryName);
}
