import 'package:design/src/empty/empty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DesignEmpty', () {
    testWidgets('renders default icon, title and optional parts', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: DesignEmpty(title: 'No items yet')),
        ),
      );

      // Default icon should be present
      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
      // Title text
      expect(find.text('No items yet'), findsOneWidget);
      // No description/action by default
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(OutlinedButton), findsNothing);
    });

    testWidgets('renders description when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DesignEmpty(
              title: 'Empty',
              description: 'Try adding a new item using the button',
            ),
          ),
        ),
      );

      expect(
        find.text('Try adding a new item using the button'),
        findsOneWidget,
      );
    });

    testWidgets('renders action button and calls callback', (tester) async {
      var tapped = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DesignEmpty(
              title: 'Empty',
              actionLabel: 'Add',
              onAction: () => tapped++,
            ),
          ),
        ),
      );

      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);

      await tester.tap(find.byType(OutlinedButton));
      await tester.pump();

      expect(tapped, 1);
    });

    testWidgets('supports custom icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DesignEmpty(title: 'Empty', icon: Icons.bookmark_outline),
          ),
        ),
      );

      expect(find.byIcon(Icons.bookmark_outline), findsOneWidget);
    });
  });
}
