import 'package:fitness_app/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

abstract class AppTextTheme {
  static TextTheme textTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.w800,
      color: Colors.white,
      fontFamily: AppStrings.appFont,
    ),
    titleMedium: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: Colors.white,
      fontFamily: AppStrings.appFont,
    ),
    titleLarge: TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.w800,
      color: Colors.white,
      fontFamily: AppStrings.appFont,
    ),
    titleSmall: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: Colors.white,
      fontFamily: AppStrings.appFont,
    ),
    labelLarge: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w800,
      color: Colors.white,
      fontFamily: AppStrings.appFont,
    ),
    labelSmall: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: Colors.white,
      fontFamily: AppStrings.appFont,
    ),
    labelMedium: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w500,
      color: Colors.white,
      fontFamily: AppStrings.appFont,
    ),
    bodyMedium: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: Colors.white,
      fontFamily: AppStrings.appFont,
    ),
    bodySmall: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: Colors.white,
      fontFamily: AppStrings.appFont,
    ),
  );
}
