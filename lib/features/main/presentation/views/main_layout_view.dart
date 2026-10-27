import 'package:fitness_app/config/routing/generate_routes.dart';
import 'package:fitness_app/core/constants/app_test_keys.dart';
import 'package:fitness_app/core/shared/custom_button.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/main/presentation/views/widgets/custom_floating_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

import '../../../../l10n/app_localizations.dart';

class MainLayoutView extends StatefulWidget {
  const MainLayoutView({super.key});

  @override
  State<MainLayoutView> createState() => _MainLayoutViewState();
}

class _MainLayoutViewState extends State<MainLayoutView> {
  int _currentTap = 0;

  late final taps = [
    GenerateRoutes.getHomeTap(),
    GenerateRoutes.getChatTap(),
    GenerateRoutes.getWorkoutsTap(),
    GenerateRoutes.getProfileTap(),
  ];

  Future<void> _handleBackPress() async {
    if (_currentTap != 0) {
      setState(() => _currentTap = 0);
    } else {
      await _showCloseAppDialog(context);
    }
  }

  Future<void> _showCloseAppDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    final shouldClose = await showDialog<bool>(
      context: context,
      barrierColor: AppColors.black.withValues(alpha: 0.50),
      builder: (dialogContext) {
        return Dialog(
          key: const Key(AppTestKeys.closeAppDialog),
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 26.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.closeAppConfirm,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.35,
                  ),
                ),
                const Gap(24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      key: const Key(AppTestKeys.closeAppDialogNoButton),
                      label: l10n.no,
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                      variant: ButtonVariant.outlined,
                      width: 80.w,
                      height: 38.h,
                    ),
                    CustomButton(
                      key: const Key(AppTestKeys.closeAppDialogYesButton),
                      label: l10n.yes,
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      variant: ButtonVariant.filled,
                      enabled: true,
                      width: 80.w,
                      height: 38.h,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (shouldClose == true) {
      await SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackPress();
      },
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: _currentTap,
          children: taps,
        ),
        bottomNavigationBar: CustomFloatingNavigationBar(
          key: const Key(AppTestKeys.mainLayoutBottomNav),
          currentIndex: _currentTap,
          onTap: (index) {
            setState(() => _currentTap = index);
          },
        ),
      ),
    );
  }
}
