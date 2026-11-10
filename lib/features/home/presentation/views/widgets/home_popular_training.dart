import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/core/shared/custom_blur_effect.dart';
import 'package:fitness_app/features/home/domain/entities/popular_training_entity.dart';
import 'package:fitness_app/features/home/presentation/manager/home_cubit.dart';
import 'package:fitness_app/features/home/presentation/manager/home_event.dart';
import 'package:fitness_app/features/home/presentation/manager/home_state.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/shimmer/popular_training_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../config/routing/app_routes.dart';
import '../../../../../core/theme/app_colors/app_colors.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../exercise/presentation/exercise_details/args/exercise_details_args.dart';
import 'home_section_state_view.dart';

class HomePopularTraining extends StatelessWidget {
  const HomePopularTraining({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.popularTraining,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleMedium?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 7.h),
        BlocSelector<
          HomeCubit,
          HomeState,
          BaseState<List<PopularTrainingEntity>>
        >(
          selector: (state) => state.popularTrainingState,
          builder: (context, popularTraining) {
            // Same "loading" definition HomeSectionStateView uses internally.
            final isLoading =
                popularTraining.data == null &&
                popularTraining.errorMessage == null;
            if (isLoading) return const PopularTrainingShimmer();

            return HomeSectionStateView<List<PopularTrainingEntity>>(
              state: popularTraining,
              height: 176,
              onRetry: () => context.read<HomeCubit>().onEvent(
                const HomePopularTrainingRetried(),
              ),
              builder: (context, trainings) {
                if (trainings.isEmpty) {
                  return SizedBox(
                    height: 176.h,
                    child: Center(
                      child: Text(
                        l10n.noPopularTraining,
                        style: textTheme.titleSmall?.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }
                return SizedBox(
                  height: 176.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: trainings.length,
                    separatorBuilder: (_, __) => SizedBox(width: 12.w),
                    itemBuilder: (context, index) =>
                        _PopularTrainingCard(training: trainings[index]),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _PopularTrainingCard extends StatelessWidget {
  const _PopularTrainingCard({required this.training});

  final PopularTrainingEntity training;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final image = training.muscleImage;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.exerciseDetails,
            arguments: ExerciseDetailsArgs(
              primeMoverMuscleId: training.muscleId,
              muscleName: training.muscleName,
            ),
          );
        },
        child: SizedBox(
          width: 200.w,
          height: 176.h,
          child: Stack(
          fit: StackFit.expand,
          children: [
            // Background: this muscle's own image.
            if (image != null && image.isNotEmpty)
              Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const _ImagePlaceholder(),
              )
            else
              const _ImagePlaceholder(),

            // Dark overlay (#00000080).
            const ColoredBox(color: AppColors.scrim),

            // Heading: top 96, height 34.
            Positioned(
              top: 96.h,
              left: 0,
              right: 0,
              height: 34.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Center(
                  child: Text(
                    '${l10n.strengthenYour} ${training.muscleName.trim()}',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontFamily: 'Baloo Thambi 2',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),

            // Bottom row: top 138, height 30, horizontal padding 16.
            Positioned(
              top: 138.h,
              left: 16.w,
              right: 16.w,
              height: 30.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _InfoPill(
                    text: l10n.tasksCount(training.totalExercises),
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                  ),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: _InfoPill(
                      text: training.difficultyLevelName.trim(),
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),);
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.text,
    required this.fontWeight,
    required this.color,
  });

  final String text;
  final FontWeight fontWeight;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: CustomBlurEffect(
        sigma: 10,
        child: ColoredBox(
          color: AppColors.surface, // #24242480
          child: SizedBox(
            height: 30.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Center(
                widthFactor: 1,
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontFamily: 'Baloo Thambi 2',
                    fontSize: 12.sp,
                    fontWeight: fontWeight,
                    height: 1.2,
                    color: color,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceMuted,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.textSecondary,
        size: 24.r,
      ),
    );
  }
}
