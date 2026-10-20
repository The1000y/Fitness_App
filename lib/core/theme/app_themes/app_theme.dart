import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/core/theme/app_text_theme/app_text_theme.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme => _buildTheme();

 static ThemeData _buildTheme() {
  const radius = BorderRadius.all(Radius.circular(20));
  const border = OutlineInputBorder(
    borderRadius: radius,
    borderSide: BorderSide(color: AppColors.border),
  );
  const enableBorder = OutlineInputBorder(
    borderRadius: radius,
    borderSide: BorderSide(color: AppColors.primary),
  );
  const errorBorder = OutlineInputBorder(
    borderRadius: radius,
    borderSide: BorderSide(color: AppColors.accent),
  );

  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.background,
    ),
    textTheme: AppTextTheme.textTheme,
    inputDecorationTheme: const InputDecorationTheme(
      border: border,
      enabledBorder: border,
      focusedBorder: enableBorder,
      errorBorder: errorBorder,
      hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 12),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
        shape: const RoundedRectangleBorder(borderRadius: radius),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.primary),
    ),
  );
}
}
