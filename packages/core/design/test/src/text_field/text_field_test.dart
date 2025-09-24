import 'package:design/src/text_field/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DesignTextField', () {
    testWidgets('renders with provided label', (tester) async {
      // Arrange
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DesignTextField(labelText: 'URL', urlController: controller),
          ),
        ),
      );

      // Assert
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('URL'), findsOneWidget);
    });

    testWidgets('updates controller text when user types', (tester) async {
      // Arrange
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DesignTextField(labelText: 'URL', urlController: controller),
          ),
        ),
      );

      // Act
      const input = 'https://example.com';
      await tester.enterText(find.byType(TextField), input);
      await tester.pump();

      // Assert
      expect(controller.text, equals(input));
    });

    testWidgets('shows initial controller text', (tester) async {
      // Arrange
      final controller = TextEditingController(text: 'prefilled');
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DesignTextField(labelText: 'URL', urlController: controller),
          ),
        ),
      );

      // Assert
      expect(find.text('prefilled'), findsOneWidget);
    });

    testWidgets('uses OutlineInputBorder with 20 border radius', (
      tester,
    ) async {
      // Arrange
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DesignTextField(labelText: 'URL', urlController: controller),
          ),
        ),
      );

      // Act
      final textField = tester.widget<TextField>(find.byType(TextField));
      final decoration = textField.decoration;

      // Assert
      expect(decoration, isNotNull);
      expect(decoration!.border, isA<OutlineInputBorder>());
      final border = decoration.border as OutlineInputBorder;
      expect(border.borderRadius, equals(BorderRadius.circular(20)));
    });
  });
}
