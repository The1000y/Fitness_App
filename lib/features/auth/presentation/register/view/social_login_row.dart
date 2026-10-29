import 'package:fitness_app/core/constants/app_icons.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class SocialLoginRow extends StatelessWidget {
  const SocialLoginRow({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Divider(color: AppColors.textSecondary, thickness: 0.5),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Text(
                l10n.or,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const Expanded(
              child: Divider(color: AppColors.textSecondary, thickness: 0.5),
            ),
          ],
        ),
        Gap(16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialButton(icon: AppIcons.facebook, onTap: () {}),
            Gap(16.w),
            _SocialButton(icon: AppIcons.google, onTap: () {}),
            Gap(16.w),
            _SocialButton(icon: AppIcons.apple, onTap: () {}),
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.icon, required this.onTap});

  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        width: 40.r,
        height: 40.r,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface,
        ),
        child: SvgPicture.asset(icon, width: 35.r, height: 35.r),
      ),
    );
  }
}
