import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors/app_colors.dart';

class AppTextFormField extends StatefulWidget {
  const AppTextFormField({
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.textInputAction,
    super.key,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? prefixIcon;
  final bool isPassword;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(20.r);

    final defaultBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: AppColors.border.withValues(alpha: 0.4),
        width: 1.w,
      ),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: theme.colorScheme.primary,
        width: 1.2.w,
      ),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: theme.colorScheme.secondary,
        width: 1.w,
      ),
    );

    final focusedErrorBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: theme.colorScheme.secondary,
        width: 1.2.w,
      ),
    );

    return SizedBox(
      height: widget.validator != null ? null : 48.h,
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        onChanged: widget.onChanged,
        textInputAction: widget.textInputAction,
        style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontSize: 15.sp,
            ) ??
            TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15.sp,
            ),
        cursorColor: theme.colorScheme.primary,
        decoration: InputDecoration(
          isDense: true,
          hintText: widget.hintText,
          hintStyle: theme.inputDecorationTheme.hintStyle?.copyWith(
                fontSize: 15.sp,
              ) ??
              TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15.sp,
              ),
          prefixIcon: widget.prefixIcon != null
              ? Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 12.w),
                  child: SvgPicture.asset(
                    widget.prefixIcon!,
                    width: 18.w,
                    height: 18.h,
                    colorFilter: const ColorFilter.mode(
                      AppColors.textSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
                )
              : null,
          prefixIconConstraints: BoxConstraints(
            minWidth: 46.w,
            minHeight: 18.h,
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.textSecondary,
                    size: 20.r,
                  ),
                )
              : null,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
          border: defaultBorder,
          enabledBorder: defaultBorder,
          focusedBorder: focusedBorder,
          errorBorder: errorBorder,
          focusedErrorBorder: focusedErrorBorder,
        ),
      ),
    );
  }
}
