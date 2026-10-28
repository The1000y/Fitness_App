import 'package:fitness_app/core/shared/custom_bottom_tab_bar.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildTestApp({
  required Locale locale,
  required int selectedIndex,
  required ValueChanged<int> onTabSelected,
}) {
  return ScreenUtilPlusInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    splitScreenMode: true,
    child: MaterialApp(
      locale: locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        bottomNavigationBar: CustomBottomTabBar(
          selectedIndex: selectedIndex,
          onTabSelected: onTabSelected,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('shows translated tab labels and selects a tab', (tester) async {
    int? selectedTab;

    await tester.pumpWidget(
      _buildTestApp(
        locale: const Locale('en'),
        selectedIndex: 0,
        onTabSelected: (index) => selectedTab = index,
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Activity'), findsOneWidget);
    expect(find.text('Workouts'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    final selectedIcon = tester.widget<Icon>(find.byIcon(Icons.home));
    expect(selectedIcon.color, AppColors.primary);

    final unselectedIcon = tester.widget<Icon>(
      find.byIcon(Icons.local_fire_department_outlined),
    );
    expect(unselectedIcon.color, AppColors.textSecondary);

    await tester.tap(find.text('Workouts'));
    expect(selectedTab, 2);
  });

  testWidgets('shows Arabic tab labels when Arabic is selected', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildTestApp(
        locale: const Locale('ar'),
        selectedIndex: 0,
        onTabSelected: (_) {},
      ),
    );

    expect(find.text('الرئيسية'), findsOneWidget);
    expect(find.text('النشاط'), findsOneWidget);
    expect(find.text('التمارين'), findsOneWidget);
    expect(find.text('الملف الشخصي'), findsOneWidget);
  });
}
