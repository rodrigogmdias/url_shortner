import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/src/presentation/home_page.dart';

void main() {
  testWidgets('renders injected create and history widgets inside layout', (
    tester,
  ) async {
    const create = Key('create-widget');
    const history = Key('history-widget');

    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(
          create: SizedBox(key: create, height: 48),
          history: SizedBox(key: history),
        ),
      ),
    );

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(SafeArea), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) => w is Padding && w.padding == const EdgeInsets.all(16.0),
      ),
      findsOneWidget,
    );
    expect(find.byKey(create), findsOneWidget);
    expect(find.byKey(history), findsOneWidget);
  });
}
