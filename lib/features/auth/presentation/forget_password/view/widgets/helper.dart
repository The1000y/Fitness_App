import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:pinput/pinput.dart';

abstract class Helper {
  static final PinTheme focusPinTheme = PinTheme(
    width: 56,
    height: 60,
    textStyle: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.primary,
    ),
    decoration: BoxDecoration(
      color: AppColors.transparent,

      border: Border(
        bottom: BorderSide(color: AppColors.primary, width: 2.w),
      ),
    ),
  );
  static final PinTheme defultPinTheme = PinTheme(
    width: 56,
    height: 60,
    textStyle: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    decoration: BoxDecoration(
      color: AppColors.transparent,
      border: Border(
        bottom: BorderSide(color: AppColors.border, width: 2.w),
      ),
    ),
  );

  static PinTheme? get submittedPinTheme => PinTheme(
    width: 56,
    height: 60,
    textStyle: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.primary,
    ),
    decoration: BoxDecoration(
      color: AppColors.transparent,
      border: Border(
        bottom: BorderSide(color: AppColors.primary, width: 2.w),
      ),
    ),
  );
}
