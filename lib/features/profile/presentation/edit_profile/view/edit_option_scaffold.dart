import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/custom_blur_card.dart';
import 'package:fitness_app/core/shared/custom_button.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

class EditOptionScaffold extends StatelessWidget {
  const EditOptionScaffold({
    super.key,
    required this.title,
    required this.child,
    required this.onDone,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return  Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56.h,
          child: Center(
            child: Image.asset(AppImages.launchLogoX2, height: 48.h),
          ),
        ),
        Gap(148.5.h),
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
            child: CustomBlurCard(
              sigma: 20,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  child,
                  Gap(24.h),
                  CustomButton(
                    label: l10n.done,
                    height: 38.h,
                    onPressed: onDone,
                  ),
                  Gap(4.h),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}