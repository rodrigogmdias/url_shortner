import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/src/presentation/home_page.dart';
import 'package:home/src/routes.dart';
import 'package:router/router.dart';

// No DI fakes needed; we'll inject stub widgets into HomePage via route builder.

void main() {
  test('homeRoutes exposes a single route for \'/\'', () {
    final routes = homeRoutes;
    expect(routes, hasLength(1));
    expect(routes.first.path, '/');
    expect(routes.first.name, isNull);
  });

  testWidgets('AppRouter renders HomePage at / with injected stubs', (
    tester,
  ) async {
    const kCreate = Key('stub-create');
    const kHistory = Key('stub-history');

    final testRoutes = <AppRoute>[
      AppRoute(
        path: '/',
        builder: (context, state) => const HomePage(
          create: SizedBox(key: kCreate),
          history: SizedBox(key: kHistory),
        ),
      ),
    ];

    final appRouter = AppRouter(testRoutes, initialLocation: '/');

    await tester.pumpWidget(
      MaterialApp.router(routerConfig: appRouter.routerConfig),
    );
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byKey(kCreate), findsOneWidget);
    expect(find.byKey(kHistory), findsOneWidget);
  });
}
