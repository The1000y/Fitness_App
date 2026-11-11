import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/localization/app_failure_message_mapper.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class HomeStateView<T> extends StatelessWidget {
  const HomeStateView({
    super.key,
    required this.state,
    required this.height,
    required this.loading,
    required this.onRetry,
    required this.builder,
  });

  final BaseState<T> state;
  final double height;
  final Widget loading;
  final VoidCallback onRetry;
  final Widget Function(BuildContext context, T data) builder;

  @override
  Widget build(BuildContext context) {
    final data = state.data;
    if (data != null) return builder(context, data);

    final failure = state.errorMessage;
    if (failure == null) return loading;

    return SizedBox(
      height: height.h,
      child: Row(
        children: [
          Expanded(
            child: Text(
              appFailureMessageMapper(failure, AppLocalizations.of(context)!),
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
}
