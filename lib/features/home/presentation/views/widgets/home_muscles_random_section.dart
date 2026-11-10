import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_by_group_entity.dart';
import 'package:fitness_app/features/home/presentation/manager/home_cubit.dart';
import 'package:fitness_app/features/home/presentation/manager/home_event.dart';
import 'package:fitness_app/features/home/presentation/manager/home_state.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/shimmer/home_image_cards_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../config/routing/app_routes.dart';
import '../../../../../core/theme/app_colors/app_colors.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../exercise/presentation/exercise_details/args/exercise_details_args.dart';
import 'home_image_title_card.dart';
import 'home_section_state_view.dart';

class HomeMusclesRandomSection extends StatelessWidget {
  const HomeMusclesRandomSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.recommendationToDay,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            height: 1.2,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 7.h),
        BlocSelector<HomeCubit, HomeState, BaseState<MusclesByGroupEntity>>(
          selector: (state) => state.randomMusclesState,
          builder: (context, randomMuscles) {
            return HomeSectionStateView<MusclesByGroupEntity>(
              state: randomMuscles,
              height: 104,
              loadingBuilder: (_) => const HomeImageCardsShimmer(size: 104),
              onRetry: () => context.read<HomeCubit>().onEvent(
                const HomeRandomMusclesRetried(),
              ),
              builder: (context, data) {
                return SizedBox(
                  height: 104.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: data.muscles.length,
                    separatorBuilder: (_, __) => SizedBox(width: 12.w),
                    itemBuilder: (context, index) {
                      final muscle = data.muscles[index];
                      return HomeImageTitleCard(
                        imageUrl: muscle.image,
                        title: muscle.name,
                        size: 104.w,
                        labelHeight: 30.h,
                        labelPadding: EdgeInsets.symmetric(horizontal: 8.w),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.exerciseDetails,
                            arguments: ExerciseDetailsArgs(
                              primeMoverMuscleId: muscle.id,
                              muscleName: muscle.name,
                            ),
                          );
                        },
                      );
                    },
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
