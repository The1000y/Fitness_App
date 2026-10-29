import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

class AuthLinkText extends StatelessWidget {
  const AuthLinkText({
    required this.label,
    required this.onPressed,
    this.bold = false,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppColors.accent,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.accent,
          fontWeight: bold ? FontWeight.w800 : null,
        ),
      ),
    );
  }
}
