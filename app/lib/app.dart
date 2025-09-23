import 'package:app/routes.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:router/router.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  AppRouter router = AppRouter(appRoutes);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router.routerConfig);
  }
}
