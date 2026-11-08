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

class ActivityStep extends StatelessWidget {
  const ActivityStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final options = <(ActivityLevel, String)>[
      (ActivityLevel.rookie, l10n.activityRookie),
      (ActivityLevel.beginner, l10n.levelBeginner),
      (ActivityLevel.intermediate, l10n.levelIntermediate),
      (ActivityLevel.advance, l10n.levelAdvanced),
      (ActivityLevel.trueBeast, l10n.activityTrueBeast),
    ];

    return StepScaffold(
      step: 5,
      title: l10n.activityTitle,
      child: BlocBuilder<RegisterCubit, RegisterState>(
        buildWhen: (p, c) => p.form.activityLevel != c.form.activityLevel,
        builder: (context, state) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (level, label) in options)
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: OptionTile(
                  label: label,
                  selected: state.form.activityLevel == level,
                  onTap: () => context.read<RegisterCubit>().doEvent(
                    ActivityLevelSelectedEvent(level),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
