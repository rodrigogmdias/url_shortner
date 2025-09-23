import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:router/src/app_router.dart';
import 'package:router/src/default_not_found.dart';

void main() {
  testWidgets(
    'AppRouter displays DefaultNotFound on initial route with no routes',
    (tester) async {
      final router = AppRouter(const []);
      await tester.pumpWidget(
        MaterialApp.router(routerConfig: router.routerConfig),
      );
      await tester.pumpAndSettle();

      final notFound = tester.widget<DefaultNotFound>(
        find.byType(DefaultNotFound),
      );
      expect(notFound.path, '/');
    },
  );

  testWidgets(
    'AppRouter displays DefaultNotFound with correct path for unknown route',
    (tester) async {
      final router = AppRouter(const [], initialLocation: '/unknown');
      await tester.pumpWidget(
        MaterialApp.router(routerConfig: router.routerConfig),
      );
      await tester.pumpAndSettle();

      final notFound = tester.widget<DefaultNotFound>(
        find.byType(DefaultNotFound),
      );
      expect(notFound.path, '/unknown');
    },
  );
}
