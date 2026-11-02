import 'package:fitness_app/core/shared/custom_blur_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildTestApp(Widget child) {
  return ScreenUtilPlusInit(
    designSize: const Size(375, 812),
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  group('CustomBlurCard', () {
    testWidgets('renders child widget inside blur container', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          const CustomBlurCard(
            child: Text('Card Content'),
          ),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
    });

    testWidgets('applies border when showWhiteBorders is true', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          const CustomBlurCard(
            showWhiteBorders: true,
            child: Text('Border Content'),
          ),
        ),
      );

      final containerFinder = find.descendant(
        of: find.byType(CustomBlurCard),
        matching: find.byType(Container),
      );
      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
    });

    testWidgets('omits border when showWhiteBorders is false', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          const CustomBlurCard(
            showWhiteBorders: false,
            child: Text('No Border Content'),
          ),
        ),
      );

      final containerFinder = find.descendant(
        of: find.byType(CustomBlurCard),
        matching: find.byType(Container),
      );
      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNull);
    });
  });
}

