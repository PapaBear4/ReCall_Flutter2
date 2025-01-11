// lib/sources/contacts_ob_source.dart
import 'package:recall/models/contact.dart';
import 'package:objectbox/objectbox.dart';
import 'package:recall/sources/data_source.dart';

class ContactsObjectBoxSource implements DataSource<Contact> {
  final Box<Contact> _contactBox;

  ContactsObjectBoxSource(this._contactBox);

  @override
  Future<Contact> add(Contact item) async {
    final id = _contactBox.put(item);
    return item.copyWith(id: id);
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
