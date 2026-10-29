import 'package:fitness_app/core/constants/app_icons.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_event.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_option.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_state.dart';
import 'package:fitness_app/features/auth/presentation/register/view/widgets/gender_option.dart';
import 'package:fitness_app/features/auth/presentation/register/view/widgets/step_scaffold.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

class GenderStep extends StatelessWidget {
  const GenderStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<RegisterCubit>();

    return StepScaffold(
      step: 0,
      title: l10n.genderTitle,
      subtitle: l10n.genderSubtitle,
      child: BlocBuilder<RegisterCubit, RegisterState>(
        buildWhen: (p, c) => p.form.gender != c.form.gender,
        builder: (context, state) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GenderOption(
              label: l10n.male,
              icon: AppIcons.maleGender,
              selected: state.form.gender == Gender.male,
              onTap: () => cubit.doEvent(const GenderSelectedEvent(Gender.male)),
            ),
            Gap(20.h),
            GenderOption(
              label: l10n.female,
              icon: AppIcons.femaleGender,
              selected: state.form.gender == Gender.female,
              onTap: () =>
                  cubit.doEvent(const GenderSelectedEvent(Gender.female)),
            ),
          ],
        ),
      ),
    );
  }
}
