// lib/sources/contact_ob_source.dart
import 'package:logger/logger.dart';
import 'package:recall/models/contact.dart';
import 'package:objectbox/objectbox.dart';
import 'package:recall/sources/data_source.dart';

var obLogger = Logger();

class ContactObjectBoxSource implements DataSource<Contact> {
  final Box<Contact> _contactBox;

  ContactObjectBoxSource(this._contactBox);

  @override
  Future<Contact> add(Contact item) async {
    obLogger.i('ob received this contact: $item');
    final id = _contactBox.put(item);
    obLogger.i('new id is: $id');
    obLogger.i('try to return from box: ${item.copyWith(id: id)}');
    return item.copyWith(id: id);
    //item.copyWith(id: id);
  }

  @override
  Future<List<Contact>> addMany(List<Contact> items) async {
    final ids = _contactBox.putMany(items);
    final updatedItems = <Contact>[];
    for (int i = 0; i < items.length; i++) {
      updatedItems.add(items[i].copyWith(id: ids[i]));
    }
    return updatedItems;
  }

  @override
  Future<void> delete(int id) async {
    _contactBox.remove(id);
  }

  @override
  Future<void> deleteMany(List<int> ids) async {
    _contactBox.removeMany(ids);
  }

  @override
  Future<int> count() async {
    return _contactBox.count();
  }

  @override
  Future<List<Contact>> getAll() async {
    return _contactBox.getAll();
  }

  @override
  Future<Contact?> getById(int id) async {
    return _contactBox.get(id);
  }

  @override
  Future<Contact> update(Contact item) async {
    final id = _contactBox.put(item);
    return item.copyWith(id: id);
  }
}
