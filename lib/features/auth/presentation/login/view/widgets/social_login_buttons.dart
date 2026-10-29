import 'package:fitness_app/core/constants/app_icons.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({
    this.onFacebookTap,
    this.onGoogleTap,
    this.onAppleTap,
    super.key,
  });

  final VoidCallback? onFacebookTap;
  final VoidCallback? onGoogleTap;
  final VoidCallback? onAppleTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialButton(
          label: 'Facebook',
          iconPath: AppIcons.facebook,
          onTap: onFacebookTap,
        ),
        Gap(16.w),
        _SocialButton(
          label: 'Google',
          iconPath: AppIcons.google,
          onTap: onGoogleTap,
        ),
        Gap(16.w),
        _SocialButton(
          label: 'Apple',
          iconPath: AppIcons.apple,
          onTap: onAppleTap,
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.iconPath,
    this.onTap,
  });

  final String label;
  final String iconPath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: label,
      child: Material(
        color: AppColors.surfaceGlass,
        shape: CircleBorder(
          side: BorderSide(color: AppColors.white.withValues(alpha: 0.15)),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 48.r,
            height: 48.r,
            child: Center(
              child: SvgPicture.asset(iconPath, width: 22.r, height: 22.r),
            ),
          ),
        ),
      ),
    );
  }
}
