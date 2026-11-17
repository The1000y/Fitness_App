import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/core/shared/category_filter_widget.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_groups_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_by_group_entity.dart';
import 'package:fitness_app/features/home/presentation/manager/home_cubit.dart';
import 'package:fitness_app/features/home/presentation/manager/home_event.dart';
import 'package:fitness_app/features/home/presentation/manager/home_state.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/common/home_cards_row.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/common/home_image_card.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/common/home_navigation.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/common/home_section_title.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/common/home_state_view.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/shimmer/home_image_cards_shimmer.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/shimmer/home_tab_bar_shimmer.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class HomeUpcomingWorkouts extends StatelessWidget {
  const HomeUpcomingWorkouts({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionTitle(
          title: l10n.upcomingWorkouts,
          actionLabel: l10n.seeAll,
          onAction: () =>
              Navigator.pushNamed(context, AppRoutes.workoutCategories),
        ),
        SizedBox(height: 8.h),
        BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (previous, current) =>
              previous.muscleGroupsState != current.muscleGroupsState ||
              previous.groupMusclesState != current.groupMusclesState ||
              previous.selectedGroupId != current.selectedGroupId,
          builder: (context, state) {
            final cubit = context.read<HomeCubit>();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeStateView<MuscleGroupsEntity>(
                  state: state.muscleGroupsState,
                  height: 48,
                  loading: const HomeTabBarShimmer(),
                  onRetry: () => cubit.onEvent(const HomeMuscleGroupsRetried()),
                  builder: (context, data) {
                    return CategoryTabBar(
                      height: 38,
                      categories: data.musclesGroup
                          .map((group) => group.name)
                          .toList(),
                      selectedCategory: state.selectedGroup?.name ?? '',
                      onCategorySelected: (name) {
                        final group = data.musclesGroup
                            .where((group) => group.name == name)
                            .firstOrNull;
                        if (group != null) {
                          cubit.onEvent(HomeMuscleGroupSelected(group.id));
                        }
                      },
                    );
                  },
                ),
                SizedBox(height: 8.h),
                HomeStateView<MusclesByGroupEntity>(
                  state: state.groupMusclesState,
                  height: 80,
                  loading: const HomeImageCardsShimmer(size: 80),
                  onRetry: () {
                    final id = state.selectedGroupId;
                    if (id != null) cubit.onEvent(HomeMuscleGroupSelected(id));
                  },
                  builder: (context, data) => HomeCardsRow(
                    height: 80,
                    itemCount: data.muscles.length,
                    itemBuilder: (context, index) {
                      final muscle = data.muscles[index];
                      return HomeImageCard(
                        imageUrl: muscle.image,
                        title: muscle.name,
                        size: 80,
                        labelPadding: 4,
                        onTap: () => openExerciseDetails(
                          context,
                          muscleId: muscle.id,
                          muscleName: muscle.name,
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
