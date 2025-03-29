// lib/sources/usersettings_ob_source.dart
import 'package:recall/models/usersettings.dart';
import 'package:objectbox/objectbox.dart';
import 'package:recall/sources/data_source.dart';

class UserSettingsObjectBoxSource implements DataSource<UserSettings> {
  final Box<UserSettings> _userSettingsBox;

  UserSettingsObjectBoxSource(this._userSettingsBox);

  @override
  Future<UserSettings> add(UserSettings item) async {
    final id = _userSettingsBox.put(item);
    return item.copyWith(id: id);
  }

  @override
  Future<List<UserSettings>> addMany(List<UserSettings> items) async {
    final ids = _userSettingsBox.putMany(items);
    final updatedItems = <UserSettings>[];
    for (int i = 0; i < items.length; i++) {
      updatedItems.add(items[i].copyWith(id: ids[i]));
    }
    return updatedItems;
  }

  @override
  Future<void> delete(int id) async {
    _userSettingsBox.remove(id);
  }

  @override
  Future<void> deleteMany(List<int> ids) async {
    _userSettingsBox.removeMany(ids);
  }

  @override
  Future<int> count() async {
    return _userSettingsBox.count();
  }

  @override
  Future<List<UserSettings>> getAll() async {
    return _userSettingsBox.getAll();
  }

  @override
  Future<UserSettings?> getById(int id) async {
    return _userSettingsBox.get(id);
  }

  @override
  Future<UserSettings> update(UserSettings item) async {
    final id = _userSettingsBox.put(item);
    return item.copyWith(id: id);
  }

  @override
  Future<void> deleteAll() async {
    _userSettingsBox.removeAll(); // Add this implementation
  }
}
