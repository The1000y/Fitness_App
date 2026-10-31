import 'package:fitness_app/core/constants/app_icons.dart';
import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/custom_blur_card.dart';
import 'package:fitness_app/core/shared/custom_button.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_event.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_state.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class StepScaffold extends StatelessWidget {
  const StepScaffold({
    super.key,
    required this.step,
    required this.title,
    required this.child,
    this.subtitle,
  });

  /// 0..5 (shown as 1/6 .. 6/6)
  final int step;
  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Gap(16.h),
        SizedBox(
          width: double.infinity,
          height: 56.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(start: 20.w),
                  child: _BackButton(
                    onTap: () => context.read<RegisterCubit>().doEvent(
                      const PreviousStepEvent(),
                    ),
                  ),
                ),
              ),
              SvgPicture.asset(AppImages.logo, height: 56.h),
            ],
          ),
        ),
        Gap(12.h),
        _StepProgress(step: step),
        Gap(12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 18.sp),
                ),
                if (subtitle != null)
                  Text(subtitle!, style: theme.textTheme.titleSmall),
              ],
            ),
          ),
        ),
        Gap(16.h),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: CustomBlurCard(
              sigma: 16,
              showWhiteBorders: true,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [child, Gap(20.h), const _NextButton()],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        width: 32.r,
        height: 32.r,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
        ),
        child: SvgPicture.asset(
          AppIcons.arrowBack,
          width: 16.r,
          height: 16.r,
          colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
        ),
      ),
    );
  }
}

class _StepProgress extends StatelessWidget {
  const _StepProgress({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const total = RegisterFormData.totalSteps;

    return SizedBox(
      width: 44.r,
      height: 44.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: (step + 1) / total,
              strokeWidth: 3,
              color: AppColors.primary,
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
            ),
          ),
          Text(
            l10n.stepOfTotal(step + 1, total),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (p, c) =>
          p.form.canProceed != c.form.canProceed || p.isLoading != c.isLoading,
      builder: (context, state) => CustomButton(
        label: l10n.next,
        height: 46.h,
        enabled: state.form.canProceed,
        isLoading: state.isLoading,
        onPressed: () =>
            context.read<RegisterCubit>().doEvent(const NextStepEvent()),
      ),
    );
  }
}
