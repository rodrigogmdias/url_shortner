import 'package:design/src/empty/empty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_utils.dart';

void main() {
  group('DesignEmpty', () {
    testWidgets('renders default icon, title and optional parts', (
      tester,
    ) async {
      await tester.pumpApp(const DesignEmpty(title: 'No items yet'));

      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
      expect(find.text('No items yet'), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(OutlinedButton), findsNothing);
    });

    testWidgets('renders description when provided', (tester) async {
      await tester.pumpApp(
        const DesignEmpty(
          title: 'Empty',
          description: 'Try adding a new item using the button',
        ),
      );

      expect(
        find.text('Try adding a new item using the button'),
        findsOneWidget,
      );
    });

    testWidgets('renders action button and calls callback', (tester) async {
      var tapped = 0;
      await tester.pumpApp(
        DesignEmpty(
          title: 'Empty',
          actionLabel: 'Add',
          onAction: () => tapped++,
        ),
      );

      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);

      await tester.tap(find.byType(OutlinedButton));
      await tester.pump();

      expect(tapped, 1);
    });

    testWidgets('supports custom icon', (tester) async {
      await tester.pumpApp(
        const DesignEmpty(title: 'Empty', icon: Icons.bookmark_outline),
      );

      expect(find.byIcon(Icons.bookmark_outline), findsOneWidget);
    });
  });
}
