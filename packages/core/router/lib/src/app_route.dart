import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

typedef RouteBuilder = Widget Function(BuildContext, GoRouterState);

class AppRoute {
  const AppRoute({
    required this.path,
    required this.builder,
    this.name,
    this.routes = const <AppRoute>[],
  });

  final String path;
  final String? name;
  final RouteBuilder builder;
  final List<AppRoute> routes;

  GoRoute toGoRoute() {
    return GoRoute(
      path: path,
      name: name,
      builder: builder,
      routes: routes.map((r) => r.toGoRoute()).toList(),
    );
  }
}
