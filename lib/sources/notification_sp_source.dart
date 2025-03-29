// lib/sources/notifications_sp_source.dart
import 'package:recall/models/notification.dart';
import 'package:recall/sources/data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotificationSharedPreferencesSource implements DataSource<Notification> {
  final String _key = 'notifications';

  @override
  Future<Notification> add(Notification item) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = await getAll();
    int nextId = 1;
    if (notifications.isNotEmpty) {
      nextId = notifications.map((e) => e.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
    }
    final newItem = item.copyWith(id: nextId);
    notifications.add(newItem);
    final encoded = notifications.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, encoded);
    return newItem;
  }

  @override
  Future<List<Notification>> addMany(List<Notification> items) async {
     final prefs = await SharedPreferences.getInstance();
    final notifications = await getAll();
    int nextId = 1;
    if (notifications.isNotEmpty) {
      nextId = notifications.map((e) => e.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
    }
    final updatedItems = <Notification>[];
    for(final item in items){
      final newItem = item.copyWith(id: nextId++);
       notifications.add(newItem);
      updatedItems.add(newItem);
    }
     final encoded = notifications.map((e) => jsonEncode(e.toJson())).toList();
     await prefs.setStringList(_key, encoded);
    return updatedItems;
  }


  @override
  Future<void> delete(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = await getAll();
    notifications.removeWhere((element) => element.id == id);
    final encoded = notifications.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, encoded);
  }

   @override
  Future<void> deleteMany(List<int> ids) async {
     final prefs = await SharedPreferences.getInstance();
    final notifications = await getAll();
     notifications.removeWhere((element) => ids.contains(element.id));
      final encoded = notifications.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, encoded);
  }
    @override
  Future<int> count() async {
    final notifications = await getAll();
    return notifications.length;
  }


  @override
  Future<List<Notification>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getStringList(_key) ?? [];
    return encoded.map((e) => Notification.fromJson(jsonDecode(e))).toList();
  }

  @override
  Future<Notification?> getById(int id) async {
    final notifications = await getAll();
    try {
      return notifications.firstWhere((element) => element.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Notification> update(Notification item) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = await getAll();
    final index = notifications.indexWhere((element) => element.id == item.id);
    if (index != -1) {
      notifications[index] = item;
    }
    final encoded = notifications.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, encoded);
    return item;
  }

  @override
  Future<void> deleteAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, []); // Add this implementation (clear the list)
  }
}
