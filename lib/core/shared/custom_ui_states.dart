import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors/app_colors.dart';

// ═════════════════════════════════════════════════════════════
// Theme / Color Constants
// ═════════════════════════════════════════════════════════════

abstract final class _T {
  static const Color primary = AppColors.primary;
  static const Color accent = AppColors.accent;
  static const Color textPrimary = AppColors.textPrimary;
  static const Color textSecondary = AppColors.textSecondary;
  static const Color textMuted = Color(0xFFA7A7A7);
  static const Color iconBubble = Color(0x22FF4100);
  static const Color strip = AppColors.surfaceMuted;
  static const double radius = 24.0;
  static const String? font = null;
}

// ═════════════════════════════════════════════════════════════
// MEALS  (full-area states that replace the grid)
// ═════════════════════════════════════════════════════════════

/// Shown when the meals list is empty.
///   MealsEmptyState(categoryLabel: 'Dinner', onRefresh: reload)
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

/// Shown when loading meals fails.
///   MealsErrorState(onRetry: reload)
///   MealsErrorState(isOffline: true, onRetry: reload)
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

// ═════════════════════════════════════════════════════════════
// Shared building blocks
// ═════════════════════════════════════════════════════════════

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
        // bottom space keeps content clear of the floating nav bar
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: _T.iconBubble,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: _T.primary),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: _T.font,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                height: 1.2,
                color: _T.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: _T.font,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 1.4,
                color: _T.textSecondary,
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
      constraints: const BoxConstraints(minHeight: 46),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _T.strip,
        borderRadius: BorderRadius.circular(_T.radius),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: isError ? _T.primary : _T.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: _T.font,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                height: 1.2,
                color: _T.textSecondary,
              ),
            ),
          ),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: _T.primary,
                minimumSize: const Size(48, 40),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_T.radius),
                ),
              ),
              child: Text(
                actionLabel!,
                style: const TextStyle(
                  fontFamily: _T.font,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
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
    final radius = BorderRadius.circular(_T.radius);
    return Material(
      color: filled ? _T.primary : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: filled ? BorderSide.none : const BorderSide(color: _T.accent),
      ),
      child: InkWell(
        borderRadius: radius,
        onTap: onPressed,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 40, minWidth: 96),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Center(
              widthFactor: 1,
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: _T.font,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: filled ? Colors.white : _T.textMuted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
