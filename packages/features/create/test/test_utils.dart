import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget child, {
    ThemeData? theme,
    Locale? locale,
    List<NavigatorObserver>? navigatorObservers,
  }) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(body: child),
        theme: theme,
        locale: locale,
        navigatorObservers: navigatorObservers ?? const <NavigatorObserver>[],
      ),
    );
  }
}
