import 'package:design/src/list_item/list_item.dart';
import 'package:design/src/skeleton/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_utils.dart';

void main() {
  group('DesignListItem loading', () {
    testWidgets('renders two DesignSkeletons with expected widths', (
      tester,
    ) async {
      await tester.pumpApp(
        const SizedBox(width: 200, child: DesignListItem(loading: true)),
      );

      final skeletons = find.byType(DesignSkeleton);
      expect(skeletons, findsNWidgets(2));

      final first = skeletons.at(0);
      final second = skeletons.at(1);

      final firstSize = tester.getSize(first);
      final secondSize = tester.getSize(second);

      expect(firstSize.height, 16);
      expect(secondSize.height, 12);

      expect(firstSize.width, closeTo(100, 0.01));
      expect(secondSize.width, closeTo(70, 0.01));
    });

    testWidgets('uses screen width when maxWidth is not finite', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: const MediaQueryData(size: Size(320, 640)),
              child: Row(children: const [DesignListItem(loading: true)]),
            ),
          ),
        ),
      );

      final skeletons = find.byType(DesignSkeleton);
      expect(skeletons, findsNWidgets(2));

      final first = skeletons.at(0);
      final second = skeletons.at(1);

      final firstSize = tester.getSize(first);
      final secondSize = tester.getSize(second);

      expect(firstSize.width, closeTo(160, 0.01));
      expect(secondSize.width, closeTo(112, 0.01));
    });
  });
}
