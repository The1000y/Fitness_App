import 'package:fitness_app/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

abstract class AppTextTheme {
  static TextTheme textTheme = const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      color: Colors.white,
      fontFamily: AppStrings.appFont,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white,
      fontFamily: AppStrings.appFont,
    ),
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      color: Colors.white,
      fontFamily: AppStrings.appFont,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.white,
      fontFamily: AppStrings.appFont,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w800,
      color: Colors.white,
      fontFamily: AppStrings.appFont,
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Colors.white,
      fontFamily: AppStrings.appFont,
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.white,
      fontFamily: AppStrings.appFont,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white,
      fontFamily: AppStrings.appFont,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.white,
      fontFamily: AppStrings.appFont,
    ),
  );
}
