import 'package:fitness_app/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_event.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_option.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_state.dart';
import 'package:fitness_app/features/auth/presentation/register/view/widgets/option_tile.dart';
import 'package:fitness_app/features/auth/presentation/register/view/widgets/step_scaffold.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class GoalStep extends StatelessWidget {
  const GoalStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final options = <(Goal, String)>[
      (Goal.gainWeight, l10n.goalGainWeight),
      (Goal.loseWeight, l10n.goalLoseWeight),
      (Goal.getFitter, l10n.goalGetFitter),
      (Goal.gainFlexibility, l10n.goalGainFlexibility),
      (Goal.learnBasics, l10n.goalLearnBasics),
    ];

    return StepScaffold(
      step: 4,
      title: l10n.goalTitle,
      subtitle: l10n.personalizedPlanHint,
      child: BlocBuilder<RegisterCubit, RegisterState>(
        buildWhen: (p, c) => p.form.goal != c.form.goal,
        builder: (context, state) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (goal, label) in options)
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: OptionTile(
                  label: label,
                  selected: state.form.goal == goal,
                  onTap: () => context.read<RegisterCubit>().doEvent(
                    GoalSelectedEvent(goal),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
