import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/config/routing/generate_routes.dart';
import 'package:fitness_app/core/theme/app_themes/app_theme.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

void main() {
  runApp(FitnessApp());
}

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilPlusInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: [
          AppLocalizations.delegate, // Add this line
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: [
          Locale('en'), // English
          Locale('ar'), // Spanish
        ],
        debugShowCheckedModeBanner: false,
        title: 'Fitness App',
        initialRoute: AppRoutes.splash,
        onGenerateRoute: GenerateRoutes.generateRoute,
      ),
    );
  }
}
