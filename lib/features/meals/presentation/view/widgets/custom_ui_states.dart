import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'package:fitness_app/core/theme/app_colors/app_colors.dart';

class MealsEmptyState extends StatelessWidget {
  const MealsEmptyState({super.key, this.categoryLabel, this.onRefresh});

  final String? categoryLabel;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final label = categoryLabel?.toLowerCase();
    return _FullState(
      icon: Icons.restaurant_menu_rounded,
      title: label == null ? l10n.noMealsYet : l10n.noCategoryMealsYet(label),
      message: l10n.noMealsMessage,
      actionLabel: onRefresh == null ? null : l10n.refresh,
      onAction: onRefresh,
      filled: false,
    );
  }
}

class MealsErrorState extends StatelessWidget {
  const MealsErrorState({
    super.key,
    required this.onRetry,
    this.isOffline = false,
    this.message,
  });

  final VoidCallback onRetry;
  final bool isOffline;
  final String? message; // optional server/error text

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _FullState(
      icon: isOffline ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
      title: isOffline ? l10n.noInternetConnection : l10n.somethingWentWrong,
      message:
          message ??
          (isOffline ? l10n.checkConnectionMessage : l10n.couldNotLoadMeals),
      actionLabel: l10n.tryAgain,
      onAction: onRetry,
      filled: true,
    );
  }
}

// ═════════════════════════════════════════════════════════════
// CATEGORIES  (compact strips that replace the tab bar)
// ═════════════════════════════════════════════════════════════

/// Shown when there are no categories (instead of Breakfast/Lunch/Dinner).
class CategoriesEmptyState extends StatelessWidget {
  const CategoriesEmptyState({super.key, this.onRefresh});
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _CompactState(
      icon: Icons.category_outlined,
      text: l10n.noCategoriesAvailable,
      actionLabel: onRefresh == null ? null : l10n.refresh,
      onAction: onRefresh,
    );
  }
}

/// Shown when loading categories fails.
class CategoriesErrorState extends StatelessWidget {
  const CategoriesErrorState({super.key, required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _CompactState(
      icon: Icons.error_outline_rounded,
      text: l10n.couldNotLoadCategories,
      actionLabel: l10n.retry,
      onAction: onRetry,
      isError: true,
    );
  }
}

class _FullState extends StatelessWidget {
  const _FullState({
    required this.icon,
    required this.title,
    required this.message,
    required this.filled,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final bool filled;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 100.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88.w,
              height: 88.h,
              decoration: const BoxDecoration(
                color: AppColors.iconBubble,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40.r, color: AppColors.primary),
            ),

            const SizedBox(height: 24),

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20.sp,
                height: 1.2,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                height: 1.4,
                color: AppColors.textSecondary,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              _PillButton(
                label: actionLabel!,
                onPressed: onAction!,
                filled: filled,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CompactState extends StatelessWidget {
  const _CompactState({
    required this.icon,
    required this.text,
    this.actionLabel,
    this.onAction,
    this.isError = false,
  });

  final IconData icon;
  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 46.h),
      padding: REdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18.r,
            color: isError ? AppColors.primary : AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
                height: 1.2,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                minimumSize: Size(48.w, 40.h),
                padding: REdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
              ),
              child: Text(
                actionLabel!,
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.sp),
              ),
            ),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.label,
    required this.onPressed,
    required this.filled,
  });

  final String label;
  final VoidCallback onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(24.r);
    return Material(
      color: filled ? AppColors.primary : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: filled
            ? BorderSide.none
            : const BorderSide(color: AppColors.accent),
      ),
      child: InkWell(
        borderRadius: radius,
        onTap: onPressed,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 40.h, minWidth: 96.w),
          child: Padding(
            padding: REdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Center(
              widthFactor: 1,
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.sp,
                  color: filled ? Colors.white : AppColors.textMuted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
