import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors/app_colors.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.prefixIconConstraints,

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
  final BoxConstraints? prefixIconConstraints;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: widget.validator != null ? null : 48.h,
      child: TextFormField(
        keyboardAppearance: Brightness.dark,
        onTapUpOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        onChanged: widget.onChanged,
        textInputAction: widget.textInputAction,
        style:
            theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontSize: 15.sp,
            ) ??
            TextStyle(color: AppColors.textPrimary, fontSize: 15.sp),
        cursorColor: theme.colorScheme.primary,
        decoration: InputDecoration(
          hintText: widget.hintText,
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
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textSecondary,
                    size: 20.r,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
