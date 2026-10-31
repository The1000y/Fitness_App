import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/exercise_card.dart';
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
  group('ExerciseCard', () {
    testWidgets('renders exercise title and responds to tap', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        wrapWithScreenUtil(
          ExerciseCard(
            image: AppImages.authBackground,
            title: 'Push Ups',
            onTap: () {
              tapped = true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Push Ups'), findsOneWidget);

      await tester.tap(find.byType(ExerciseCard));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}
