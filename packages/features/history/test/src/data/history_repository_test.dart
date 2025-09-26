import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:history/src/data/history_repository.dart';
import 'package:history/src/domain/models/short_url.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:storage/storage.dart';

@GenerateNiceMocks([MockSpec<MemoryStorage>()])
import 'history_repository_test.mocks.dart';

void main() {
  late MockMemoryStorage storage;
  late HistoryRepositoryImpl repository;

  setUpAll(() {});

  setUp(() {
    storage = MockMemoryStorage();
    repository = HistoryRepositoryImpl(storage);
  });

  test('delegates to storage.watchList with correct key and decoder', () async {
    final controller = StreamController<List<ShortUrl>>.broadcast();

    when(storage.watchList<ShortUrl>(any, any)).thenAnswer((invocation) {
      final key = invocation.positionalArguments[0] as String;
      final decoder =
          invocation.positionalArguments[1] as ShortUrl Function(Object?);

      expect(key, 'shortened_urls');

      final decoded = decoder({
        'originalUrl': 'https://example.com',
        'alias': 'ex',
      });
      expect(decoded.originalUrl, 'https://example.com');
      expect(decoded.alias, 'ex');

      return controller.stream;
    });

    final futureFirst = repository.watchAll().first;

    final list = [
      ShortUrl(originalUrl: 'a', alias: '1'),
      ShortUrl(originalUrl: 'b', alias: '2'),
    ];
    controller.add(list);

    final first = await futureFirst;
    expect(first, list);

    verify(storage.watchList<ShortUrl>(any, any)).called(1);
    await controller.close();
  });

  test('emits subsequent updates from underlying storage stream', () async {
    final controller = StreamController<List<ShortUrl>>.broadcast();

    when(
      storage.watchList<ShortUrl>(any, any),
    ).thenAnswer((_) => controller.stream);

    final results = <List<ShortUrl>>[];
    final sub = repository.watchAll().listen(results.add);

    final first = [ShortUrl(originalUrl: 'x', alias: '1')];
    final second = [
      ShortUrl(originalUrl: 'y', alias: '2'),
      ShortUrl(originalUrl: 'z', alias: '3'),
    ];

    controller
      ..add(first)
      ..add(second);

    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(results.length, 2);
    expect(results[0], first);
    expect(results[1], second);

    await sub.cancel();
    await controller.close();
  });
}
