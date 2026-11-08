import 'package:fitness_app/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_event.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_state.dart';
import 'package:fitness_app/features/auth/presentation/register/view/widgets/number_wheel_picker.dart';
import 'package:fitness_app/features/auth/presentation/register/view/widgets/step_scaffold.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgeStep extends StatelessWidget {
  const AgeStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<RegisterCubit>();

    return StepScaffold(
      step: 1,
      title: l10n.ageTitle,
      subtitle: l10n.personalizedPlanHint,
      child: NumberWheelPicker(
        value: cubit.state.form.age,
        min: 10,
        max: 100,
        unit: l10n.yearUnit,
        onChanged: (v) => cubit.doEvent(AgeChangedEvent(v)),
      ),
    );
  }
}
