import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:history/src/data/history_repository.dart';
import 'package:history/src/domain/load_history_use_case.dart';
import 'package:history/src/domain/models/short_url.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<HistoryRepository>()])
import 'load_history_use_case_test.mocks.dart';

void main() {
  late MockHistoryRepository repository;
  late LoadHistoryUseCase useCase;

  setUp(() {
    repository = MockHistoryRepository();
    useCase = LoadHistoryUseCaseImpl(repository);
  });

  test('returns reversed list from watchAll() on first emission', () async {
    final controller = StreamController<List<ShortUrl>>.broadcast();
    when(repository.watchAll()).thenAnswer((_) => controller.stream);

    final futureFirst = useCase().first;

    final items = [
      ShortUrl(originalUrl: 'a', alias: '1'),
      ShortUrl(originalUrl: 'b', alias: '2'),
      ShortUrl(originalUrl: 'c', alias: '3'),
    ];
    controller.add(items);

    final result = await futureFirst;
    expect(result.map((e) => e.alias).toList(), ['3', '2', '1']);

    await controller.close();
    verify(repository.watchAll()).called(1);
  });

  test('propagates updates, always reversing the order', () async {
    final controller = StreamController<List<ShortUrl>>.broadcast();
    when(repository.watchAll()).thenAnswer((_) => controller.stream);

    final received = <List<ShortUrl>>[];
    final sub = useCase().listen(received.add);

    controller
      ..add([
        ShortUrl(originalUrl: 'x', alias: '1'),
        ShortUrl(originalUrl: 'y', alias: '2'),
      ])
      ..add([ShortUrl(originalUrl: 'k', alias: '10')]);

    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(received.length, 2);
    expect(received[0].map((e) => e.alias).toList(), ['2', '1']);
    expect(received[1].map((e) => e.alias).toList(), ['10']);

    await sub.cancel();
    await controller.close();
    verify(repository.watchAll()).called(1);
  });

  test('empty list stays empty', () async {
    final controller = StreamController<List<ShortUrl>>.broadcast();
    when(repository.watchAll()).thenAnswer((_) => controller.stream);

    final futureFirst = useCase().first;
    controller.add(const <ShortUrl>[]);

    final result = await futureFirst;
    expect(result, isEmpty);

    await controller.close();
    verify(repository.watchAll()).called(1);
  });
}
