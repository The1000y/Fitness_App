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

    testWidgets('renders title and responds to user tap on text', (
      tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        wrapWithScreenUtil(
          ExerciseCard(
            image: 'assets/images/robot_chat.png',
            title: 'Bench Press',
            onTap: () => tapped = true,
          ),
        ),
      );

      expect(find.text('Bench Press'), findsOneWidget);

      await tester.tap(find.text('Bench Press'));
      expect(tapped, isTrue);
    });
  });
}
