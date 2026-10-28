import 'package:fitness_app/core/shared/custom_blur_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

class AuthCard extends StatelessWidget {
  const AuthCard({required this.child, this.title, super.key});

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomBlurCard(
      showWhiteBorders: false,
      borderRadius: BorderRadius.circular(50.r),
      padding: EdgeInsetsDirectional.fromSTEB(16.w, 24.h, 16.w, 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Text(
              title!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Gap(24.h),
          ],
          child,
        ],
      ),
    );
  }
}