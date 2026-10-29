import 'package:fitness_app/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_event.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_state.dart';
import 'package:fitness_app/features/auth/presentation/register/view/widgets/number_wheel_picker.dart';
import 'package:fitness_app/features/auth/presentation/register/view/widgets/step_scaffold.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeightStep extends StatelessWidget {
  const WeightStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<RegisterCubit>();

    return StepScaffold(
      step: 2,
      title: l10n.weightTitle,
      subtitle: l10n.personalizedPlanHint,
      child: NumberWheelPicker(
        value: cubit.state.form.weight,
        min: 30,
        max: 250,
        unit: l10n.kgUnit,
        onChanged: (v) => cubit.doEvent(WeightChangedEvent(v)),
      ),
    );
  }
}
