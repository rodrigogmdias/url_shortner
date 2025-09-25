import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test utilities for the design package.
///
/// Provides a convenient way to pump widgets wrapped with
/// MaterialApp and Scaffold so individual tests do not need
/// to repeat the same boilerplate code.
extension PumpDesignApp on WidgetTester {
  /// Pumps [child] wrapped in a [MaterialApp] with a [Scaffold].
  ///
  /// Optional [theme], [locale] and [navigatorObservers] can be provided
  /// when a test needs to customize the app environment.
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
