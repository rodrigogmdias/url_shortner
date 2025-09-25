import 'package:design/src/skeleton/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_utils.dart';

void main() {
  group('DesignSkeleton', () {
    testWidgets('renders rectangle with given size and default radius', (
      tester,
    ) async {
      final theme = ThemeData.light();

      await tester.pumpApp(
        const DesignSkeleton(width: 120, height: 16),
        theme: theme,
      );

      final containerFinder = find.descendant(
        of: find.byType(DesignSkeleton),
        matching: find.byType(Container),
      );

      final size = tester.getSize(containerFinder);
      expect(size.width, 120);
      expect(size.height, 16);

      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.shape, BoxShape.rectangle);
      expect(
        decoration.borderRadius,
        const BorderRadius.all(Radius.circular(6)),
      );

      final expectedColor = theme.colorScheme.onSurface.withValues(alpha: 0.08);
      expect(decoration.color, expectedColor);
    });

    testWidgets('supports custom color and custom radius', (tester) async {
      const customColor = Colors.red;
      const radius = BorderRadius.all(Radius.circular(10));

      await tester.pumpApp(
        const DesignSkeleton(
          width: 80,
          height: 10,
          color: customColor,
          borderRadius: radius,
        ),
      );

      final containerFinder = find.descendant(
        of: find.byType(DesignSkeleton),
        matching: find.byType(Container),
      );

      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, customColor);
      expect(decoration.borderRadius, radius);
      expect(decoration.shape, BoxShape.rectangle);
    });

    testWidgets('renders circle with given diameter', (tester) async {
      await tester.pumpApp(const DesignSkeleton.circle(diameter: 40));

      final containerFinder = find.descendant(
        of: find.byType(DesignSkeleton),
        matching: find.byType(Container),
      );

      final size = tester.getSize(containerFinder);
      expect(size.width, 40);
      expect(size.height, 40);

      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);
      expect(decoration.borderRadius, isNull);
    });
  });
}
