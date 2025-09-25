import 'package:design/src/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_utils.dart';

void main() {
  group('DesignToast', () {
    testWidgets('success() convenience method shows success toast', (
      tester,
    ) async {
      await tester.pumpApp(const SizedBox());
      final context = tester.element(find.byType(Scaffold));

      DesignToast.success(
        context,
        'All good',
        duration: const Duration(days: 1),
      );
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('All good'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);

      final bar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(bar.backgroundColor, Colors.green.shade600);
      expect(bar.duration, const Duration(days: 1));
    });

    testWidgets('warning() convenience method shows warning toast', (
      tester,
    ) async {
      await tester.pumpApp(const SizedBox());
      final context = tester.element(find.byType(Scaffold));

      DesignToast.warning(
        context,
        'Be careful',
        duration: const Duration(days: 1),
      );
      await tester.pump();

      expect(find.text('Be careful'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);

      final bar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(bar.backgroundColor, Colors.orange.shade700);
      expect(bar.duration, const Duration(days: 1));
    });
    testWidgets('shows success toast with correct styling', (tester) async {
      await tester.pumpApp(const SizedBox());
      final context = tester.element(find.byType(Scaffold));

      DesignToast.show(
        context,
        message: 'All good',
        type: DesignToastType.success,
        duration: const Duration(days: 1),
      );
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('All good'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);

      final bar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(bar.backgroundColor, Colors.green.shade600);
      expect(bar.behavior, SnackBarBehavior.floating);
      expect(bar.margin, const EdgeInsets.all(16));
      expect(
        (bar.shape as RoundedRectangleBorder).borderRadius,
        BorderRadius.circular(12),
      );
      expect(bar.duration, const Duration(days: 1));
    });

    testWidgets('shows warning toast with correct styling', (tester) async {
      await tester.pumpApp(const SizedBox());
      final context = tester.element(find.byType(Scaffold));

      DesignToast.show(
        context,
        message: 'Be careful',
        type: DesignToastType.warning,
        duration: const Duration(days: 1),
      );
      await tester.pump();

      expect(find.text('Be careful'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);

      final bar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(bar.backgroundColor, Colors.orange.shade700);
    });

    testWidgets('shows error toast using convenience method', (tester) async {
      await tester.pumpApp(const SizedBox());
      final context = tester.element(find.byType(Scaffold));

      DesignToast.error(context, 'Failure', duration: const Duration(days: 1));
      await tester.pump();

      expect(find.text('Failure'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);

      final bar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(bar.backgroundColor, Colors.red.shade600);
    });

    testWidgets('shows action and triggers callback', (tester) async {
      await tester.pumpApp(const SizedBox());
      final context = tester.element(find.byType(Scaffold));

      var tapped = false;
      DesignToast.show(
        context,
        message: 'With action',
        actionLabel: 'UNDO',
        onAction: () => tapped = true,
        duration: const Duration(days: 1),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SnackBarAction), findsOneWidget);
      await tester.tap(find.byType(SnackBarAction));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('hideCurrent=true replaces current snackbar immediately', (
      tester,
    ) async {
      await tester.pumpApp(const SizedBox());
      final context = tester.element(find.byType(Scaffold));

      DesignToast.show(
        context,
        message: 'First',
        duration: const Duration(days: 1),
      );
      await tester.pump();

      expect(find.text('First'), findsOneWidget);

      DesignToast.show(
        context,
        message: 'Second',
        duration: const Duration(days: 1),
        hideCurrent: true,
      );
      await tester.pump();

      expect(find.text('First'), findsNothing);
      expect(find.text('Second'), findsOneWidget);
    });

    testWidgets('hideCurrent=false keeps current snackbar visible', (
      tester,
    ) async {
      await tester.pumpApp(const SizedBox());
      final context = tester.element(find.byType(Scaffold));

      DesignToast.show(
        context,
        message: 'First',
        duration: const Duration(days: 1),
      );
      await tester.pump();

      DesignToast.show(
        context,
        message: 'Second',
        duration: const Duration(days: 1),
        hideCurrent: false,
      );
      await tester.pump();

      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsNothing);
    });
  });
}
