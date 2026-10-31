import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/core/theme/app_themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme', () {
    testWidgets('lightTheme initializes with dark brightness and primary orange color', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(body: Text('Theme Test')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final theme = AppTheme.lightTheme;
      expect(theme.brightness, equals(Brightness.dark));
      expect(theme.colorScheme.primary, equals(AppColors.primary));
      expect(theme.scaffoldBackgroundColor, equals(Colors.transparent));
      expect(theme.textTheme.headlineLarge?.fontFamily, equals('BalooThambi2'));
      expect(theme.inputDecorationTheme, isNotNull);
      expect(theme.elevatedButtonTheme.style, isNotNull);
      expect(theme.outlinedButtonTheme.style, isNotNull);
    });
  });
}
