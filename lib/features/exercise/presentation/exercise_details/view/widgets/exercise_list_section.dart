import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

import 'exercise_list_item.dart';

class ExerciseListSection extends StatelessWidget {
  const ExerciseListSection({
    super.key,
    required this.muscleName,
    required this.exercises,
  });

  final String muscleName;
  final List<ExerciseEntity> exercises;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 12.h),
            child: Text(
              '$muscleName Exercises',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          sliver: SliverList.separated(
            itemCount: exercises.length,
            separatorBuilder: (context, index) => Gap(12.h),
            itemBuilder: (context, index) {
              return ExerciseListItem(
                exercise: exercises[index],
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.exerciseVideoPlayer,
                    arguments: exercises[index],
                  );
                },
              );
            },
          ),
        ),
        SliverToBoxAdapter(child: Gap(24.h)),
      ],
    );
  }
}
