import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    required this.child,
    this.title,
    this.subtitle,
    this.topOffsetFactor = 0.225,
    super.key,
  });

  final Widget child;
  final String? title;
  final String? subtitle;

  final double topOffsetFactor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    //final screenHeight = MediaQuery.sizeOf(context).height;
    final hasHeader = title != null || subtitle != null;

    return CustomBackgroundImage(
      backgroundImage: AppImages.authBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,

        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              4.w,
              0.h,
              4.w,
              MediaQuery.paddingOf(context).bottom + 24.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Image.asset(AppImages.launchLogoX2, height: 48.h),
                ),
                SizedBox(height: 85.h),
                if (hasHeader) ...[
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (subtitle != null)
                          Text(subtitle!, style: textTheme.bodyLarge),
                        if (title != null)
                          Text(title!, style: textTheme.headlineLarge),
                      ],
                    ),
                  ),
                  Gap(16.h),
                ],
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
