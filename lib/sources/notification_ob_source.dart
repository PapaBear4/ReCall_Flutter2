// lib/sources/notification_ob_source.dart
import 'package:recall/models/notification.dart';
import 'package:objectbox/objectbox.dart';
import 'package:recall/sources/data_source.dart';

class NotificationObjectBoxSource implements DataSource<Notification> {
  final Box<Notification> _notificationBox;

  NotificationObjectBoxSource(this._notificationBox);

  @override
  Future<Notification> add(Notification item) async {
    final id = _notificationBox.put(item);
    return item.copyWith(id: id);
  }

  @override
  Future<List<Notification>> addMany(List<Notification> items) async {
    final ids = _notificationBox.putMany(items);
    final updatedItems = <Notification>[];
    for (int i = 0; i < items.length; i++) {
      updatedItems.add(items[i].copyWith(id: ids[i]));
    }
    return updatedItems;
  }


  @override
  Future<void> delete(int id) async {
    _notificationBox.remove(id);
  }

  @override
  Future<void> deleteMany(List<int> ids) async {
    _notificationBox.removeMany(ids);
  }

  @override
  Future<int> count() async {
    return _notificationBox.count();
  }


  @override
  Future<List<Notification>> getAll() async {
    return _notificationBox.getAll();
  }

  @override
  Future<Notification?> getById(int id) async {
    return _notificationBox.get(id);
  }

  @override
  Future<Notification> update(Notification item) async {
    final id = _notificationBox.put(item);
    return item.copyWith(id: id);
  }

  @override
  Future<void> deleteAll() async {
    _notificationBox.removeAll(); // Add this implementation
  }
}
