import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:history/src/domain/load_history_use_case.dart';
import 'package:history/src/domain/models/short_url.dart';
import 'package:history/src/presentation/cubit/history_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<LoadHistoryUseCase>()])
import 'history_cubit_test.mocks.dart';

void main() {
  late MockLoadHistoryUseCase useCase;
  late HistoryCubit cubit;

  setUp(() {
    useCase = MockLoadHistoryUseCase();
    cubit = HistoryCubit(useCase);
  });

  tearDown(() async {
    await cubit.close();
  });

  test('initial state is HistoryInitial', () {
    expect(cubit.state, isA<HistoryInitial>());
  });

  test('emits Loading then subscribes and emits Loaded after delay', () {
    fakeAsync((fa) {
      final controller = StreamController<List<ShortUrl>>.broadcast();
      when(useCase.call()).thenAnswer((_) => controller.stream);

      final received = <HistoryState>[];
      final sub = cubit.stream.listen(received.add);

      cubit.load();

      fa.flushMicrotasks();
      expect(received.last, isA<HistoryLoading>());

      fa.elapse(const Duration(seconds: 2));
      fa.flushMicrotasks();

      final items = [
        ShortUrl(originalUrl: 'a', alias: '1'),
        ShortUrl(originalUrl: 'b', alias: '2'),
      ];
      controller.add(items);

      fa.flushMicrotasks();

      expect(received.whereType<HistoryLoaded>().length, 1);
      expect(received.whereType<HistoryLoaded>().first.urls.length, 2);

      sub.cancel();
      controller.close();
      verify(useCase.call()).called(1);
    });
  });

  test('propagates further updates as HistoryLoaded states', () {
    fakeAsync((fa) {
      final controller = StreamController<List<ShortUrl>>.broadcast();
      when(useCase.call()).thenAnswer((_) => controller.stream);

      final received = <HistoryState>[];
      final sub = cubit.stream.listen(received.add);

      cubit.load();
      fa.elapse(const Duration(seconds: 2));
      fa.flushMicrotasks();

      controller
        ..add([ShortUrl(originalUrl: 'x', alias: '1')])
        ..add([ShortUrl(originalUrl: 'y', alias: '2')]);

      fa.flushMicrotasks();

      final loaded = received.whereType<HistoryLoaded>().toList();
      expect(loaded.length, 2);
      expect(loaded.first.urls.first.alias, '1');

      sub.cancel();
      controller.close();
    });
  });
}
