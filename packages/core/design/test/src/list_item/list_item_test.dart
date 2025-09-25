import 'package:design/src/list_item/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_utils.dart';

void main() {
  group('DesignListItem', () {
    testWidgets('renders title and subtitle with expected styles', (
      tester,
    ) async {
      await tester.pumpApp(
        const DesignListItem(title: 'My Title', subtitle: 'My Subtitle'),
      );

      final titleText = tester.widget<Text>(find.text('My Title'));
      final subtitleText = tester.widget<Text>(find.text('My Subtitle'));

      expect(titleText.style?.fontSize, 14);
      expect(titleText.style?.fontWeight, FontWeight.normal);

      expect(subtitleText.style?.fontSize, 12);
      expect(subtitleText.style?.fontWeight, FontWeight.w400);
    });

    testWidgets('does not render button when buttonIcon is null', (
      tester,
    ) async {
      await tester.pumpApp(
        const DesignListItem(title: 'No Button', subtitle: 'No Icon Provided'),
      );

      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('renders button with icon and triggers onPressed', (
      tester,
    ) async {
      var pressed = false;

      await tester.pumpApp(
        DesignListItem(
          title: 'With Button',
          subtitle: 'Has Icon',
          buttonIcon: Icons.add,
          buttonOnPressed: () {
            pressed = true;
          },
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(pressed, isTrue);
    });
  });
}
