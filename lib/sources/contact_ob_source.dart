// lib/sources/contact_ob_source.dart
import 'package:recall/models/contact.dart';
import 'package:recall/objectbox.g.dart';
import 'package:recall/sources/data_source.dart';

class ContactObjectBoxSource implements DataSource<Contact> {
  final Box<Contact> _contactBox;

  ContactObjectBoxSource(this._contactBox);

  // MARK: ADD/UPDT
  // ObjectBox handles the ID assignment
  @override
  Future<Contact> add(Contact item) async {
    final id = _contactBox.put(item);  // add/update the contact
    return item.copyWith(id: id); // return the contact with the new ID
  }

  @override
  Future<List<Contact>> addMany(List<Contact> items) async {
    final List<int> newIds = _contactBox.putMany(items);

    final List<Contact> addedContactsWithIds = [];
    for (int i = 0; i < items.length; i++) {
      addedContactsWithIds.add(items[i].copyWith(id: newIds[i]));
    }
    return addedContactsWithIds;
  }

  // MARK: READ
    @override
  Future<List<Contact>> getAll() async {
    return _contactBox.getAll();
  }

  @override
  Future<Contact?> getById(int id) async {
    return _contactBox.get(id);
  }

  // MARK: DELETE
  @override
  Future<void> delete(int id) async {
    _contactBox.remove(id);
  }

  @override
  Future<void> deleteMany(List<int> ids) async {
    _contactBox.removeMany(ids);
  }

    @override
  Future<void> deleteAll() async {
    _contactBox.removeAll(); // Use ObjectBox's removeAll
  }

  // MARK: OTHER
  @override
  Future<int> count() async {
    return _contactBox.count();
  }


}
