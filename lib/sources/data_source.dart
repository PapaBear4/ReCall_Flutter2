// lib/sources/data_source.dart
abstract class DataSource<T> {
  Future<List<T>> getAll();
  Future<T?> getById(int id);
  Future<T> add(T item);
  Future<List<T>> addMany(List<T> items);
  Future<void> delete(int id);
  Future<void> deleteMany(List<int> ids);
  Future<int> count();
  Future<void> deleteAll();
}
