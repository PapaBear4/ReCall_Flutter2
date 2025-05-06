// lib/sources/contact_ob_source.dart
import 'package:recall/utils/logger.dart'; // Adjust path if needed
import 'package:recall/models/contact.dart';
import 'package:recall/objectbox.g.dart';
import 'package:recall/sources/data_source.dart';

class ContactObjectBoxSource implements DataSource<Contact> {
  final Box<Contact> _contactBox;

  ContactObjectBoxSource(this._contactBox);

  @override
  Future<Contact> add(Contact item) async {
    logger.i('ob received this contact: $item');
    final query =
        _contactBox.query().order(Contact_.id, flags: Order.descending).build();
    final highId = query.findFirst()?.id ?? 0;
    //add the newId to the item
    final contactToAdd = item.copyWith(id: highId + 1);

    final id = _contactBox.put(contactToAdd);
    logger.i('new id is: $id');
    logger.i('try to return from box: ${item.copyWith(id: id)}');
    return item.copyWith(id: id);
    //item.copyWith(id: id);
  }

  @override
  Future<List<Contact>> addMany(List<Contact> items) async {
    final query =
        _contactBox.query().order(Contact_.id, flags: Order.descending).build();
    final highId = query.findFirst()?.id ?? 0;
    final firstNewId = highId + 1;
    //set new ids
    final newItems = <Contact>[];
    for (int i = 0; i < items.length; i++) {
      newItems.add(items[i].copyWith(id: firstNewId + i));
    }
    final ids = _contactBox.putMany(newItems);
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
    logger.i(
        'ContactObjectBoxSource: Updating contact: $item, isActive: ${item.isActive}');
    final id = _contactBox.put(item);
    return item.copyWith(id: id);
  }

  @override
  Future<void> deleteAll() async {
    _contactBox.removeAll(); // Use ObjectBox's removeAll
  }
}
