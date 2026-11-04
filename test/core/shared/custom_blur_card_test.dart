import 'package:fitness_app/core/shared/custom_blur_card.dart';
import 'package:fitness_app/core/shared/custom_blur_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

Widget wrapWithScreenUtil(Widget child) {
  return ScreenUtilPlusInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    child: MaterialApp(
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  group('CustomBlurCard', () {
    testWidgets('renders child within ClipRRect and CustomBlurEffect', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithScreenUtil(
          const CustomBlurCard(
            showWhiteBorders: true,
            child: Text('Card Content'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Card Content'), findsOneWidget);
      expect(find.byType(ClipRRect), findsOneWidget);
      expect(find.byType(CustomBlurEffect), findsOneWidget);
    });
  });
}
