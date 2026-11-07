import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class ExerciseEmptyView extends StatelessWidget {
  const ExerciseEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Text(
        l10n.exerciseNoExercisesFound,
        style: TextStyle(color: AppColors.textSecondary, fontSize: 16.sp),
      ),
    );
  }
}
