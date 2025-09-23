import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:router/src/app_route.dart';

void main() {
  group('AppRoute', () {
    test('toGoRoute maps simple properties', () {
      SizedBox builder(BuildContext _, GoRouterState _) =>
          const SizedBox.shrink();
      final route = AppRoute(path: '/home', name: 'home', builder: builder);

      final go = route.toGoRoute();

      expect(go.path, '/home');
      expect(go.name, 'home');
      expect(identical(go.builder, builder), isTrue);
      expect(go.routes, isEmpty);
    });

    test('toGoRoute maps nested routes recursively', () {
      SizedBox builder(BuildContext _, GoRouterState _) =>
          const SizedBox.shrink();

      final child = AppRoute(path: 'child', builder: builder);
      final child2 = AppRoute(path: 'child2', name: 'c2', builder: builder);
      final parent = AppRoute(
        path: '/parent',
        name: 'parent',
        builder: builder,
        routes: [child, child2],
      );

      final goParent = parent.toGoRoute();

      expect(goParent.path, '/parent');
      expect(goParent.name, 'parent');
      expect(goParent.routes.length, 2);

      final goChild = goParent.routes[0] as GoRoute;
      final goChild2 = goParent.routes[1] as GoRoute;

      expect(goChild.path, 'child');
      expect(goChild.name, isNull);
      expect(identical(goChild.builder, builder), isTrue);

      expect(goChild2.path, 'child2');
      expect(goChild2.name, 'c2');
      expect(identical(goChild2.builder, builder), isTrue);
    });
  });
}
