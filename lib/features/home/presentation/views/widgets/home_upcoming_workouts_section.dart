import 'package:fitness_app/features/exercise/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_by_group_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_entity.dart';
import 'package:fitness_app/features/home/presentation/manager/home_cubit.dart';
import 'package:fitness_app/features/home/presentation/manager/home_event.dart';
import 'package:fitness_app/features/home/presentation/manager/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../config/routing/app_routes.dart';
import '../../../../../core/shared/category_filter_widget.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/presentation/login/view/widgets/home_section_header.dart';
import 'home_image_title_card.dart';
import 'home_section_state_view.dart';


List<MuscleGroupEntity> _uniqueByName(List<MuscleGroupEntity> groups) {
  final seen = <String>{};
  return groups.where((group) => seen.add(group.name)).toList();
}

class HomeUpcomingWorkoutsSection extends StatelessWidget {
  const HomeUpcomingWorkoutsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          title: l10n.upcomingWorkouts,
          actionLabel: l10n.seeAll,
            onActionPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.workoutCategories,
            ),
        ),
        SizedBox(height: 8.h),
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final cubit = context.read<HomeCubit>();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeSectionStateView<MusclesByGroupEntity>(
                  state: state.muscleGroupsState,
                  height: 48,
                  onRetry: () => cubit.onEvent(const HomeMuscleGroupsRetried()),
                  builder: (context, data) {
                    final groups = _uniqueByName(data.musclesGroup);
                    final selected = groups
                        .where((group) => group.id == state.selectedGroupId)
                        .firstOrNull;

                    return CategoryTabBar(
                      height: 30.h,
                      categories: groups.map((group) => group.name).toList(),
                      selectedCategory: selected?.name ?? '',
                      onCategorySelected: (name) {
                        final group = groups
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
                HomeSectionStateView<MusclesEntity>(
                  state: state.groupMusclesState,
                  height: 80.h,
                  onRetry: () {
                    final id = state.selectedGroupId;
                    if (id != null) cubit.onEvent(HomeMuscleGroupSelected(id));
                  },
                  builder: (context, data) {
                    return SizedBox(
                      height: 80.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: data.muscles.length,
                        separatorBuilder: (_, __) => SizedBox(width: 12.w),
                        itemBuilder: (context, index) {
                          final muscle = data.muscles[index];
                          return HomeImageTitleCard(
                            imageUrl: muscle.image,
                            title: muscle.name,
                            size: 80.w,
                            labelHeight: 30.h,
                            labelPadding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                            ),
                            onTap: () {
                              // Navigation action
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}