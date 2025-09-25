import 'package:design/src/text_field/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_utils.dart';

void main() {
  group('DesignTextField', () {
    testWidgets('renders with provided label', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpApp(
        DesignTextField(labelText: 'URL', urlController: controller),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('URL'), findsOneWidget);
    });

    testWidgets('updates controller text when user types', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpApp(
        DesignTextField(labelText: 'URL', urlController: controller),
      );

      const input = 'https://example.com';
      await tester.enterText(find.byType(TextField), input);
      await tester.pump();

      expect(controller.text, equals(input));
    });

    testWidgets('shows initial controller text', (tester) async {
      final controller = TextEditingController(text: 'prefilled');
      addTearDown(controller.dispose);

      await tester.pumpApp(
        DesignTextField(labelText: 'URL', urlController: controller),
      );

      expect(find.text('prefilled'), findsOneWidget);
    });

    testWidgets('uses OutlineInputBorder with 20 border radius', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpApp(
        DesignTextField(labelText: 'URL', urlController: controller),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      final decoration = textField.decoration;

      expect(decoration, isNotNull);
      expect(decoration!.border, isA<OutlineInputBorder>());
      final border = decoration.border as OutlineInputBorder;
      expect(border.borderRadius, equals(BorderRadius.circular(20)));
    });
  });
}
