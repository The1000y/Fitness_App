import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/meals/presentation/view/widgets/information_data_about_meals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InformationDataAboutMeals', () {
    testWidgets('renders number and title inside decorated container', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          child: const MaterialApp(
            home: Scaffold(
              body: InformationDataAboutMeals(number: '100 k', title: 'Energy'),
            ),
          ),
        ),
      );

      expect(find.text('100 k'), findsOneWidget);
      expect(find.text('Energy'), findsOneWidget);

      final titleWidget = tester.widget<Text>(find.text('Energy'));
      expect(titleWidget.style?.color, AppColors.primary);
    });
  });
}
