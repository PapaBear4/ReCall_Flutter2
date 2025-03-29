// lib/repositories/repository.dart
abstract class Repository<T> {
  Future<List<T>> getAll();
  Future<T?> getById(int id);
  Future<T> add(T item);
  Future<List<T>> addMany(List<T> items);
  Future<T> update(T item);
  Future<void> delete(int id);
  Future<void> deleteAll();
}