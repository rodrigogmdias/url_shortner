import 'dart:async';

import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:history/src/domain/models/short_url.dart';
import 'package:history/src/presentation/cubit/history_cubit.dart';
import 'package:history/src/presentation/history_widget.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test_utils.dart';
@GenerateNiceMocks([MockSpec<HistoryCubit>()])
import 'history_widget_test.mocks.dart';

void main() {
  late MockHistoryCubit cubit;
  late StreamController<HistoryState> controller;

  setUpAll(() {
    provideDummy<HistoryState>(HistoryInitial());
  });

  setUp(() async {
    cubit = MockHistoryCubit();
    controller = StreamController<HistoryState>.broadcast();
    when(cubit.stream).thenAnswer((_) => controller.stream);
    when(cubit.state).thenReturn(HistoryInitial());
    when(cubit.load()).thenAnswer((_) async => Future.value());
    when(cubit.close()).thenAnswer((_) async => Future.value());
    GetIt.I.allowReassignment = true;
    GetIt.I.registerFactory<HistoryCubit>(() => cubit);
  });

  tearDown(() async {
    await controller.close();
    await cubit.close();
  });

  testWidgets('renders header and calls load on init', (tester) async {
    await tester.pumpApp(const HistoryWidget());
    expect(find.text('Recently Shortened URLs'), findsOneWidget);
    verify(cubit.load()).called(1);
  });

  testWidgets('shows loading skeleton while in HistoryLoading', (tester) async {
    await tester.pumpApp(const HistoryWidget());
    controller.add(HistoryLoading());
    await tester.pump();
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(DesignListItem), findsWidgets);
    final firstItem = tester.widget<DesignListItem>(
      find.byType(DesignListItem).first,
    );
    expect(firstItem.loading, isTrue);
  });

  testWidgets('shows empty state when HistoryLoaded with empty list', (
    tester,
  ) async {
    await tester.pumpApp(const HistoryWidget());
    controller.add(HistoryLoaded(const []));
    await tester.pump();
    expect(find.byType(DesignEmpty), findsOneWidget);
    expect(find.text('No URLs shortened yet'), findsOneWidget);
  });

  testWidgets('shows list items when HistoryLoaded with data', (tester) async {
    await tester.pumpApp(const HistoryWidget());
    final items = [
      ShortUrl(originalUrl: 'https://a.com', alias: 'a'),
      ShortUrl(originalUrl: 'https://b.com', alias: 'b'),
    ];
    controller.add(HistoryLoaded(items));
    await tester.pump();
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('https://a.com'), findsOneWidget);
    expect(find.text('a'), findsOneWidget);
    expect(find.text('https://b.com'), findsOneWidget);
    expect(find.text('b'), findsOneWidget);
  });
}
