import 'package:fitness_app/core/shared/exercise_card.dart';
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
  group('ExerciseCard', () {
    testWidgets('renders title and responds to user tap', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        _buildTestApp(
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

