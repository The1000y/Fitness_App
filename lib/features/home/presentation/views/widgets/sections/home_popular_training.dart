import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/core/shared/custom_blur_effect.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/home/domain/entities/popular_training_entity.dart';
import 'package:fitness_app/features/home/presentation/manager/home_cubit.dart';
import 'package:fitness_app/features/home/presentation/manager/home_event.dart';
import 'package:fitness_app/features/home/presentation/manager/home_state.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/common/home_cards_row.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/common/home_image_card.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/common/home_navigation.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/common/home_section_title.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/common/home_state_view.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/shimmer/popular_training_shimmer.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class HomePopularTraining extends StatelessWidget {
  const HomePopularTraining({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionTitle(title: l10n.popularTraining),
        SizedBox(height: 7.h),
        BlocSelector<HomeCubit, HomeState,
            BaseState<List<PopularTrainingEntity>>>(
          selector: (state) => state.popularTrainingState,
          builder: (context, state) =>
              HomeStateView<List<PopularTrainingEntity>>(
                state: state,
                height: 176,
                loading: const PopularTrainingShimmer(),
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
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: 14.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  }
                  return HomeCardsRow(
                    height: 176,
                    itemCount: trainings.length,
                    itemBuilder: (context, index) =>
                        _card(context, trainings[index]),
                  );
                },
              ),
        ),
      ],
    );
  }

  Widget _card(BuildContext context, PopularTrainingEntity training) {
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openExerciseDetails(
          context,
          muscleId: training.muscleId,
          muscleName: training.muscleName,
          difficultyLevelId: training.difficultyLevelId,
        ),
        child: SizedBox(
          width: 200.w,
          height: 176.h,
          child: Stack(
            fit: StackFit.expand,
            children: [
              homeNetworkImage(training.muscleImage),
              const ColoredBox(color: AppColors.scrim),
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
              Positioned(
                top: 138.h,
                left: 16.w,
                right: 16.w,
                height: 30.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _pill(
                      context,
                      l10n.tasksCount(training.totalExercises),
                      FontWeight.w400,
                      AppColors.textPrimary,
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: _pill(
                        context,
                        training.difficultyLevelName.trim(),
                        FontWeight.w700,
                        AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pill(
      BuildContext context,
      String text,
      FontWeight weight,
      Color color,
      ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: CustomBlurEffect(
        sigma: 10,
        child: ColoredBox(
          color: AppColors.surface,
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
                    fontWeight: weight,
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