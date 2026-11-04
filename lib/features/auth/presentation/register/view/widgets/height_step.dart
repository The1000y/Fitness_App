import 'package:fitness_app/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_event.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_state.dart';
import 'package:fitness_app/features/auth/presentation/register/view/widgets/number_wheel_picker.dart';
import 'package:fitness_app/features/auth/presentation/register/view/widgets/step_scaffold.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HeightStep extends StatelessWidget {
  const HeightStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<RegisterCubit>();

    return StepScaffold(
      step: 3,
      title: l10n.heightTitle,
      subtitle: l10n.personalizedPlanHint,
      child: NumberWheelPicker(
        value: cubit.state.form.height,
        min: 100,
        max: 250,
        unit: l10n.cmUnit,
        onChanged: (v) => cubit.doEvent(HeightChangedEvent(v)),
      ),
    );
  }
}
