import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/localization/app_failure_message_mapper.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class HomeSectionStateView<T> extends StatelessWidget {
  const HomeSectionStateView({
    super.key,
    required this.state,
    required this.height,
    required this.onRetry,
    required this.builder,
    this.loadingBuilder,
  });

  final BaseState<T> state;
  final double height;
  final VoidCallback onRetry;
  final WidgetBuilder? loadingBuilder;
  final Widget Function(BuildContext context, T data) builder;

  @override
  Widget build(BuildContext context) {
    final data = state.data;
    if (data != null) return builder(context, data);

    final failure = state.errorMessage;
    if (failure != null) {
      final l10n = AppLocalizations.of(context)!;
      return SizedBox(
        height: height.h,
        child: Row(
          children: [
            Expanded(
              child: Text(
                appFailureMessageMapper(failure, l10n),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            IconButton(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
            ),
          ],
        ),
      );
    }

    final loading = loadingBuilder;
    if (loading != null) return loading(context);

    return SizedBox(
      height: height.h,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
