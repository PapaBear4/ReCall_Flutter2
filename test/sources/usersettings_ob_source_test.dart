import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recall/models/usersettings.dart';
import 'package:recall/models/contact_enums.dart';
import 'package:recall/objectbox.g.dart'; // For Box
import 'package:recall/sources/usersettings_ob_source.dart';

// Import the generated mocks
import 'usersettings_ob_source_test.mocks.dart';

// Annotation to generate mocks
@GenerateMocks([Box])
void main() {
  late MockBox<UserSettings> mockBox;
  late UserSettingsObjectBoxSource dataSource;

  // Helper function to create dummy settings
  UserSettings createSettings(int id) => UserSettings(
        id: id,
        remindersEnabled: true,
        alertsEnabled: true,
        notificationHour: 8,
        notificationMinute: 0,
        defaultFrequency: ContactFrequency.monthly.value,
      );

  setUp(() {
    mockBox = MockBox<UserSettings>();
    // Stub initial getAll and count for constructor initialization
    when(mockBox.getAll()).thenReturn([]);
    when(mockBox.count()).thenReturn(0);

    dataSource = UserSettingsObjectBoxSource(mockBox);

    // Clear initial invocations from constructor
    clearInteractions(mockBox);
  });

  tearDown(() {
    dataSource.dispose();
  });

  group('UserSettingsObjectBoxSource Tests', () {
    test('Constructor initializes streams', () {
      // Re-run setup to check constructor calls
      when(mockBox.getAll()).thenReturn([]);
      when(mockBox.count()).thenReturn(0);
      dataSource = UserSettingsObjectBoxSource(mockBox);

      // Verify getAll and count were called by constructor's refresh methods
      verify(mockBox.getAll()).called(1);
      verify(mockBox.count()).called(1);
    });

    test('add() puts item, refreshes streams, returns with ID', () async {
      final settings = createSettings(0);
      final settingsWithId = createSettings(1);
      when(mockBox.put(settings)).thenReturn(1);
      // Stub getAll/count for refresh calls
      when(mockBox.getAll()).thenReturn([settingsWithId]);
      when(mockBox.count()).thenReturn(1);

      final addedSettings = await dataSource.add(settings);

      verify(mockBox.put(settings)).called(1);
      expect(addedSettings.id, 1);
      // Verify streams were refreshed
      verify(mockBox.getAll()).called(1);
      verify(mockBox.count()).called(1);
      // Check stream emission (simple check)
      expectLater(dataSource.getAllStream(), emits([settingsWithId]));
      expectLater(dataSource.getCountStream(UserSettingsQueryNames.all), emits(1));
    });

    test('addMany() puts items, refreshes streams, returns with IDs', () async {
       final settingsList = [createSettings(0), createSettings(0)];
       final settingsWithIds = [createSettings(1), createSettings(2)];
       when(mockBox.putMany(settingsList)).thenReturn([1, 2]);
       when(mockBox.getAll()).thenReturn(settingsWithIds);
       when(mockBox.count()).thenReturn(2);

       final addedSettings = await dataSource.addMany(settingsList);

       verify(mockBox.putMany(settingsList)).called(1);
       expect(addedSettings.length, 2);
       expect(addedSettings[0].id, 1);
       expect(addedSettings[1].id, 2);
       verify(mockBox.getAll()).called(1);
       verify(mockBox.count()).called(1);
       expectLater(dataSource.getAllStream(), emits(settingsWithIds));
       expectLater(dataSource.getCountStream(UserSettingsQueryNames.all), emits(2));
    });

    test('update() puts item, refreshes streams', () async {
      final settings = createSettings(1);
      when(mockBox.put(settings)).thenReturn(1);
      when(mockBox.getAll()).thenReturn([settings]);
      when(mockBox.count()).thenReturn(1);

      final updatedSettings = await dataSource.update(settings);

      verify(mockBox.put(settings)).called(1);
      expect(updatedSettings.id, 1);
      verify(mockBox.getAll()).called(1);
      verify(mockBox.count()).called(1);
      expectLater(dataSource.getAllStream(), emits([settings]));
      expectLater(dataSource.getCountStream(UserSettingsQueryNames.all), emits(1));
    });

     test('updateMany() puts items, refreshes streams', () async {
       final settingsList = [createSettings(1), createSettings(2)];
       when(mockBox.putMany(settingsList)).thenReturn([1, 2]);
       when(mockBox.getAll()).thenReturn(settingsList);
       when(mockBox.count()).thenReturn(2);

       final updatedSettings = await dataSource.updateMany(settingsList);

       verify(mockBox.putMany(settingsList)).called(1);
       expect(updatedSettings.length, 2);
       expect(updatedSettings[0].id, 1);
       expect(updatedSettings[1].id, 2);
       verify(mockBox.getAll()).called(1);
       verify(mockBox.count()).called(1);
       expectLater(dataSource.getAllStream(), emits(settingsList));
       expectLater(dataSource.getCountStream(UserSettingsQueryNames.all), emits(2));
    });

    test('delete() removes item, refreshes streams', () async {
      const id = 1;
      when(mockBox.remove(id)).thenReturn(true);
      when(mockBox.getAll()).thenReturn([]);
      when(mockBox.count()).thenReturn(0);

      await dataSource.delete(id);

      verify(mockBox.remove(id)).called(1);
      verify(mockBox.getAll()).called(1);
      verify(mockBox.count()).called(1);
      expectLater(dataSource.getAllStream(), emits([]));
      expectLater(dataSource.getCountStream(UserSettingsQueryNames.all), emits(0));
    });

     test('deleteMany() removes items, refreshes streams', () async {
       final ids = [1, 2];
       when(mockBox.removeMany(ids)).thenReturn(2);
       when(mockBox.getAll()).thenReturn([]);
       when(mockBox.count()).thenReturn(0);

       await dataSource.deleteMany(ids);

       verify(mockBox.removeMany(ids)).called(1);
       verify(mockBox.getAll()).called(1);
       verify(mockBox.count()).called(1);
       expectLater(dataSource.getAllStream(), emits([]));
       expectLater(dataSource.getCountStream(UserSettingsQueryNames.all), emits(0));
    });

     test('deleteAll() removes all items, refreshes streams', () async {
       when(mockBox.removeAll()).thenReturn(5);
       when(mockBox.getAll()).thenReturn([]);
       when(mockBox.count()).thenReturn(0);

       await dataSource.deleteAll();

       verify(mockBox.removeAll()).called(1);
       verify(mockBox.getAll()).called(1);
       verify(mockBox.count()).called(1);
       expectLater(dataSource.getAllStream(), emits([]));
       expectLater(dataSource.getCountStream(UserSettingsQueryNames.all), emits(0));
    });

    test('getById() gets item from box', () async {
      const id = 1;
      final settings = createSettings(id);
      when(mockBox.get(id)).thenReturn(settings);

      final result = await dataSource.getById(id);

      verify(mockBox.get(id)).called(1);
      expect(result, settings);
    });

    test('getAll() gets all items from box', () async {
      final settingsList = [createSettings(1), createSettings(2)];
      when(mockBox.getAll()).thenReturn(settingsList);

      final result = await dataSource.getAll();

      verify(mockBox.getAll()).called(1); // Called directly by the method
      expect(result, settingsList);
    });

    test('count() gets count from box', () async {
      when(mockBox.count()).thenReturn(10);

      final result = await dataSource.count();

      verify(mockBox.count()).called(1); // Called directly by the method
      expect(result, 10);
    });

    test('getAllStream() returns stream and refreshes', () {
      final settingsList = [createSettings(1)];
      when(mockBox.getAll()).thenReturn(settingsList);

      final stream = dataSource.getAllStream();

      verify(mockBox.getAll()).called(1); // Called by _refreshSettings
      expect(stream, isNotNull);
      expectLater(stream, emits(settingsList));
    });

    test('getCountStream() returns stream for "all" and refreshes', () {
      when(mockBox.count()).thenReturn(5);

      final stream = dataSource.getCountStream(UserSettingsQueryNames.all);

      verify(mockBox.count()).called(1); // Called by _refreshCount
      expect(stream, isNotNull);
      expectLater(stream, emits(5));
    });

     test('getCountStream() returns empty stream for unknown query', () {
      final stream = dataSource.getCountStream('unknown');
      expect(stream, isNotNull);
      expectLater(stream, emits(0)); // Default behavior
    });

    test('dispose() closes streams', () async {
      // Expect controllers to be closed
      // Listen to streams to ensure they complete when closed
      final settingsFuture = dataSource.getAllStream().toList();
      final countFuture = dataSource.getCountStream(UserSettingsQueryNames.all).toList();

      dataSource.dispose();

      // Check if streams are done
      await expectLater(settingsFuture, completion(isEmpty)); // isEmpty because no items were added after setup
      await expectLater(countFuture, completion(isEmpty)); // isEmpty because no items were added after setup
    });
  });
}
