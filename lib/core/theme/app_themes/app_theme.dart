import 'package:fitness_app/core/constants/app_strings.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/core/theme/app_text_theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme => _buildTheme();

  static ThemeData _buildTheme() {
    final inputRadius = BorderRadius.circular(20.r);
    final buttonRadius = BorderRadius.circular(30.r);

    // ===== Input Borders =====
    final defaultBorder = OutlineInputBorder(
      borderRadius: inputRadius,
      borderSide: BorderSide(
        color: AppColors.border.withValues(alpha: 0.4),
        width: 1.w,
      ),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: inputRadius,
      borderSide: BorderSide(color: AppColors.primary, width: 1.2.w),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: inputRadius,
      borderSide: BorderSide(color: AppColors.accent, width: 1.w),
    );

    final focusedErrorBorder = OutlineInputBorder(
      borderRadius: inputRadius,
      borderSide: BorderSide(color: AppColors.accent, width: 1.2.w),
    );

    return ThemeData(
      fontFamily:AppStrings.appFont ,
      extensions: [
        YoutubePlayerTheme(
          progressBarActiveColor: AppColors.primary,
          progressBarBufferedColor: AppColors.primary.withValues(alpha: 0.4),
          progressBarBackgroundColor: AppColors.white.withValues(alpha: 0.25),
          controlsColor: AppColors.white,
          titleStyle:AppTextTheme.textTheme.labelMedium,
          timerStyle: AppTextTheme.textTheme.labelSmall,
        ),
      ],
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.background,
      ),
      textTheme: AppTextTheme.textTheme,

      // ===== Input Decoration =====
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        border: defaultBorder,
        enabledBorder: defaultBorder,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: focusedErrorBorder,
        hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 15.sp),
      ),

      // ===== Elevated Button (Filled) =====
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          shape: RoundedRectangleBorder(borderRadius: buttonRadius),
          textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
      ),

      // ===== Outlined Button =====
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.8),
            width: 1.5.w,
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          shape: RoundedRectangleBorder(borderRadius: buttonRadius),
          textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
      ),
    );
  }
}
