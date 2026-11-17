import 'package:fitness_app/features/profile/presentation/edit_profile/manager/edit_profile_cubit.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/manager/edit_profile_state.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/view/edit_field_tile.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

import '../../../../auth/presentation/register/manager/register_option.dart';
import '../manager/edit_profile_event.dart';
import 'edit_activity_view.dart';
import 'edit_goal_view.dart';
import 'edit_weight_view.dart';

class EditProfileFieldsWidget extends StatelessWidget {
  const EditProfileFieldsWidget({super.key});

  String _activityLabel(String? apiValue, AppLocalizations l10n) {
    for (final level in ActivityLevel.values) {
      if (level.apiValue == apiValue) {
        return switch (level) {
          ActivityLevel.rookie => l10n.activityRookie,
          ActivityLevel.beginner => l10n.levelBeginner,
          ActivityLevel.intermediate => l10n.levelIntermediate,
          ActivityLevel.advance => l10n.levelAdvanced,
          ActivityLevel.trueBeast => l10n.activityTrueBeast,
        };
      }
    }
    return apiValue ?? '';
  }

  String _goalLabel(String? apiValue, AppLocalizations l10n) {
    for (final goal in Goal.values) {
      if (goal.apiValue == apiValue) {
        return switch (goal) {
          Goal.gainWeight => l10n.goalGainWeight,
          Goal.loseWeight => l10n.goalLoseWeight,
          Goal.getFitter => l10n.goalGetFitter,
          Goal.gainFlexibility => l10n.goalGainFlexibility,
          Goal.learnBasics => l10n.goalLearnBasics,
        };
      }
    }
    return apiValue ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        BlocBuilder<EditProfileCubit, EditProfileState>(
          buildWhen: (p, c) => p.weight != c.weight,
          builder: (context, state) => EditFieldTile(
            label: l10n.yourWeight,
            value: '${state.weight?.round() ?? 0} ${l10n.kgUnit}',
            onTap: () async {
              final cubit = context.read<EditProfileCubit>();
              final result = await Navigator.push<int>(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      EditWeightView(initialWeight: state.weight?.round() ?? 0),
                ),
              );
              if (result != null) {
                cubit.doEvent(EditWeightChangedEvent(result.toDouble()));
              }
            },
          ),
        ),
        Gap(16.h),
        BlocBuilder<EditProfileCubit, EditProfileState>(
          buildWhen: (p, c) => p.goal != c.goal,
          builder: (context, state) => EditFieldTile(
            label: l10n.yourGoal,
            value: _goalLabel(state.goal, l10n),
            onTap: () async {
              final cubit = context.read<EditProfileCubit>();
              final result = await Navigator.push<Goal>(
                context,
                MaterialPageRoute(
                  builder: (_) => EditGoalView(initialGoal: state.goal),
                ),
              );
              if (result != null) {
                cubit.doEvent(GoalChangedEvent(result.apiValue));
              }
            },
          ),
        ),
        Gap(16.h),
        BlocBuilder<EditProfileCubit, EditProfileState>(
          buildWhen: (p, c) => p.activityLevel != c.activityLevel,
          builder: (context, state) => EditFieldTile(
            label: l10n.yourActivityLevel,
            value: _activityLabel(state.activityLevel, l10n),
            onTap: () async {
              final cubit = context.read<EditProfileCubit>();
              final result = await Navigator.push<ActivityLevel>(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      EditActivityView(initialLevel: state.activityLevel),
                ),
              );
              if (result != null) {
                cubit.doEvent(ActivityLevelChangedEvent(result.apiValue));
              }
            },
          ),
        ),
      ],
    );
  }
}
