import 'package:design/src/text/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DesignText', () {
    testWidgets('defaults to h3 (18, bold)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: DesignText('Hello'))),
      );

      final text = tester.widget<Text>(find.text('Hello'));
      expect(text.style?.fontSize, 18);
      expect(text.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('renders h1 style', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: DesignText('H1', type: DesignTextType.h1)),
        ),
      );
      final w = tester.widget<Text>(find.text('H1'));
      expect(w.style?.fontSize, 32);
      expect(w.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('renders h2 style', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: DesignText('H2', type: DesignTextType.h2)),
        ),
      );
      final w = tester.widget<Text>(find.text('H2'));
      expect(w.style?.fontSize, 24);
      expect(w.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('renders h3 style', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: DesignText('H3', type: DesignTextType.h3)),
        ),
      );
      final w = tester.widget<Text>(find.text('H3'));
      expect(w.style?.fontSize, 18);
      expect(w.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('renders body style', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: DesignText('Body', type: DesignTextType.body)),
        ),
      );
      final w = tester.widget<Text>(find.text('Body'));
      expect(w.style?.fontSize, 14);
      expect(w.style?.fontWeight, FontWeight.normal);
    });

    testWidgets('renders caption style', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DesignText('Caption', type: DesignTextType.caption),
          ),
        ),
      );
      final w = tester.widget<Text>(find.text('Caption'));
      expect(w.style?.fontSize, 12);
      expect(w.style?.fontWeight, FontWeight.w400);
    });
  });
}
