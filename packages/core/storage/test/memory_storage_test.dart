import 'package:flutter_test/flutter_test.dart';
import 'package:storage/src/memory_storage.dart';

void main() {
  late MemoryStorage storage;

  setUp(() {
    storage = MemoryStorage();
  });

  tearDown(() {
    storage.dispose();
  });

  group('MemoryStorage key/value', () {
    test('watch emits initial value and subsequent updates', () async {
      final events = <String?>[];
      final sub = storage.watch('foo').listen(events.add);
      await pumpEventQueue();

      await storage.save('foo', 'bar');
      await pumpEventQueue();

      await storage.save('foo', 'baz');
      await pumpEventQueue();

      expect(events, <String?>[null, 'bar', 'baz']);
      await sub.cancel();
    });

    test('delete notifies watchers with null', () async {
      await storage.save('foo', 'bar');

      final events = <String?>[];
      final sub = storage.watch('foo').listen(events.add);
      await pumpEventQueue();

      await storage.delete('foo');
      await pumpEventQueue();

      expect(events, <String?>['bar', null]);
      await sub.cancel();
    });

    test('watch emits only for specified key', () async {
      final events = <String?>[];
      final sub = storage.watch('a').listen(events.add);
      await pumpEventQueue();
      final lengthAfterInitial = events.length;

      await storage.save('b', 'no');
      await pumpEventQueue();
      expect(events.length, lengthAfterInitial);

      await storage.save('a', 'x');
      await pumpEventQueue();
      expect(events, <String?>[null, 'x']);
      await sub.cancel();
    });

    test('getAllKeys returns all saved keys', () async {
      await storage.save('a', '1');
      await storage.save('b', '2');
      await storage.save('c', '3');

      final keys = await storage.getAllKeys();
      expect(keys, containsAll(<String>['a', 'b', 'c']));
    });
  });

  group('MemoryStorage list operations', () {
    test('addToList and getList handle empty and append', () async {
      await storage.addToList<int>('numbers', 1);
      await storage.addToList<int>('numbers', 2);

      final list = await storage.getList<int>(
        'numbers',
        (e) => (e as num).toInt(),
      );
      expect(list, <int>[1, 2]);
    });

    test(
      'addToList wraps non-list decoded JSON into list and appends',
      () async {
        await storage.save('numbers', '5');
        await storage.addToList<int>('numbers', 7);

        final list = await storage.getList<int>(
          'numbers',
          (e) => (e as num).toInt(),
        );
        expect(list, <int>[5, 7]);
      },
    );

    test(
      'addToList initializes empty list when current JSON is invalid',
      () async {
        await storage.save('numbers', 'not-json');
        await storage.addToList<int>('numbers', 3);

        final list = await storage.getList<int>(
          'numbers',
          (e) => (e as num).toInt(),
        );
        expect(list, <int>[3]);
      },
    );

    test('watchList emits initial list and updates', () async {
      final events = <List<int>>[];
      final sub = storage
          .watchList<int>('numbers', (e) => (e as num).toInt())
          .listen(events.add);
      await pumpEventQueue();

      await storage.addToList<int>('numbers', 1);
      await pumpEventQueue();

      await storage.addToList<int>('numbers', 2);
      await pumpEventQueue();

      expect(events, <List<int>>[
        <int>[],
        <int>[1],
        <int>[1, 2],
      ]);
      await sub.cancel();
    });

    test('addToList supports custom toEncodable mapper', () async {
      final items = [_Item('a'), _Item('b')];

      for (final item in items) {
        await storage.addToList<_Item>(
          'items',
          item,
          toEncodable: (v) => {'value': v.value},
        );
      }

      final decoded = await storage.getList<Map<String, dynamic>>(
        'items',
        (e) => Map<String, dynamic>.from(e as Map),
      );

      expect(decoded, <Map<String, dynamic>>[
        {'value': 'a'},
        {'value': 'b'},
      ]);
    });

    test('getList wraps non-list JSON into a single-element list', () async {
      await storage.save('single', '5');

      final list = await storage.getList<int>(
        'single',
        (e) => (e as num).toInt(),
      );
      expect(list, <int>[5]);
    });

    test('getList returns empty list on invalid JSON', () async {
      await storage.save('invalid', 'not-json');

      final list = await storage.getList<Object>('invalid', (e) => e as Object);
      expect(list, isEmpty);
    });

    test('watchList emits empty after clearList', () async {
      await storage.addToList<int>('numbers', 1);
      await storage.addToList<int>('numbers', 2);

      final events = <List<int>>[];
      final sub = storage
          .watchList<int>('numbers', (e) => (e as num).toInt())
          .listen(events.add);
      await pumpEventQueue();

      await storage.clearList('numbers');
      await pumpEventQueue();

      expect(events, <List<int>>[
        <int>[1, 2],
        <int>[],
      ]);
      await sub.cancel();
    });
  });
}

class _Item {
  final String value;
  _Item(this.value);
}
