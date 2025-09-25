import 'package:design/src/button/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_utils.dart';

void main() {
  group('DesignButton', () {
    testWidgets('renders label when provided', (tester) async {
      await tester.pumpApp(const DesignButton(labelText: 'Submit'));

      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpApp(const DesignButton(icon: Icons.add));

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('renders spacing only when both icon and label are provided', (
      tester,
    ) async {
      // Both icon and label -> one SizedBox of width 4
      await tester.pumpApp(
        const DesignButton(labelText: 'Go', icon: Icons.link),
      );

      final withBothFinder = find.descendant(
        of: find.byType(OutlinedButton),
        matching: find.byType(SizedBox),
      );
      final sizedBoxesBoth = tester.widgetList<SizedBox>(withBothFinder);
      expect(sizedBoxesBoth.where((w) => w.width == 4).length, 1);

      // Only label -> no SizedBox of width 4
      await tester.pumpApp(const DesignButton(labelText: 'OnlyLabel'));
      final withLabelOnlyFinder = find.descendant(
        of: find.byType(OutlinedButton),
        matching: find.byType(SizedBox),
      );
      final sizedBoxesLabelOnly = tester.widgetList<SizedBox>(
        withLabelOnlyFinder,
      );
      expect(sizedBoxesLabelOnly.where((w) => w.width == 4).isEmpty, isTrue);

      // Only icon -> no SizedBox of width 4
      await tester.pumpApp(const DesignButton(icon: Icons.link));
      final withIconOnlyFinder = find.descendant(
        of: find.byType(OutlinedButton),
        matching: find.byType(SizedBox),
      );
      final sizedBoxesIconOnly = tester.widgetList<SizedBox>(
        withIconOnlyFinder,
      );
      expect(sizedBoxesIconOnly.where((w) => w.width == 4).isEmpty, isTrue);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var tapped = 0;
      await tester.pumpApp(
        DesignButton(labelText: 'Tap', onPressed: () => tapped++),
      );

      await tester.tap(find.byType(OutlinedButton));
      await tester.pump();

      expect(tapped, 1);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await tester.pumpApp(const DesignButton(labelText: 'Disabled'));

      final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
      // onPressed is null when disabled
      expect(button.onPressed, isNull);
    });

    testWidgets('shows loading indicator and disables button when loading', (
      tester,
    ) async {
      var tapped = 0;
      await tester.pumpApp(
        DesignButton(
          labelText: 'Tap',
          icon: Icons.add,
          onPressed: () => tapped++,
          loading: true,
        ),
      );

      // Button should be disabled when loading
      final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
      expect(button.onPressed, isNull);

      // Should show progress indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Should NOT show icon or label while loading
      expect(find.byIcon(Icons.add), findsNothing);
      expect(find.text('Tap'), findsNothing);

      // Taps should not invoke callback while disabled
      await tester.tap(find.byType(OutlinedButton));
      await tester.pump();
      expect(tapped, 0);
    });

    testWidgets('toggles content when loading changes', (tester) async {
      // Not loading initially -> shows label
      await tester.pumpApp(DesignButton(labelText: 'Submit', onPressed: () {}));
      expect(find.text('Submit'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Rebuild in loading state -> hides label, shows spinner
      await tester.pumpApp(
        const DesignButton(labelText: 'Submit', loading: true),
      );
      expect(find.text('Submit'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
