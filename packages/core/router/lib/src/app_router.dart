import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:router/router.dart';
import 'package:router/src/default_not_found.dart';

class AppRouter {
  AppRouter(this._appRoutes, {this.initialLocation});

  final List<AppRoute> _appRoutes;
  final String? initialLocation;

  late final GoRouter _goRouter = GoRouter(
    initialLocation: initialLocation,
    routes: _appRoutes.map((r) => r.toGoRoute()).toList(),
    errorBuilder: (context, state) {
      return DefaultNotFound(path: state.uri.toString());
    },
  );

  RouterConfig<RouteMatchList> get routerConfig => _goRouter;
}
