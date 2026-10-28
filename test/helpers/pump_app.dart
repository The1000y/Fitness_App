import 'package:fitness_app/config/routing/generate_routes.dart';
import 'package:fitness_app/core/theme/app_themes/app_theme.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget child, {
    Locale locale = const Locale('en'),
    Size size = const Size(375, 812),
  }) async {
    view.physicalSize = size * view.devicePixelRatio;
    addTearDown(view.reset);

    await pumpWidget(
      ScreenUtilPlusInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          locale: locale,
          theme: AppTheme.lightTheme,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          home: child,
          onGenerateRoute: GenerateRoutes.generateRoute,
        ),
      ),
    );
  }
}
