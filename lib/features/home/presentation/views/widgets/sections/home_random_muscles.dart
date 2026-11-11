import 'package:fitness_app/config/base/base_state.dart';
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
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class HomeRandomMuscles extends StatelessWidget {
  const HomeRandomMuscles({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionTitle(title: l10n.recommendationToDay),
        SizedBox(height: 7.h),
        BlocSelector<HomeCubit, HomeState, BaseState<MusclesByGroupEntity>>(
          selector: (state) => state.randomMusclesState,
          builder: (context, state) => HomeStateView<MusclesByGroupEntity>(
            state: state,
            height: 104,
            loading: const HomeImageCardsShimmer(size: 104),
            onRetry: () => context.read<HomeCubit>().onEvent(
              const HomeRandomMusclesRetried(),
            ),
            builder: (context, data) => HomeCardsRow(
              height: 104,
              itemCount: data.muscles.length,
              itemBuilder: (context, index) {
                final muscle = data.muscles[index];
                return HomeImageCard(
                  imageUrl: muscle.image,
                  title: muscle.name,
                  size: 104,
                  labelPadding: 8,
                  onTap: () => openExerciseDetails(
                    context,
                    muscleId: muscle.id,
                    muscleName: muscle.name,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
