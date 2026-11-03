import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class ExerciseEmptyView extends StatelessWidget {
  const ExerciseEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No exercises found',
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 16.sp,
        ),
      ),
    );
  }
}
