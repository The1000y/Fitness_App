import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class ProfileMenuItem extends StatelessWidget {
  final String icon;
  final String? title;
  final Widget? titleWidget;
  final Widget? trailing;
  final Color titleColor;
  final VoidCallback? onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    this.title,
    this.titleWidget,
    this.trailing,
    this.titleColor = AppColors.textPrimary,
    required this.onTap,
  }) : assert(title != null || titleWidget != null);

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 20.r,
              height: 20.r,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
            Gap(12.w),
            Expanded(
              child:
                  titleWidget ??
                  Text(
                    title!,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            ),
            Gap(12.w),
            trailing ??
                Icon(
                  isRtl ? Icons.chevron_left : Icons.chevron_right,
                  color: AppColors.primary,
                  size: 20.r,
                ),
          ],
        ),
      ),
    );
  }
}
