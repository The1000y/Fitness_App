import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

class DataOfIngredients extends StatelessWidget {
  const DataOfIngredients({
    super.key,
    required this.strIngredient,
    required this.strMeasure, required this.theme,
  });
  final String strIngredient;
  final String strMeasure;
  final ThemeData theme ;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(strIngredient, style: theme.textTheme.bodyLarge),
        Text(
          strMeasure,
          style: theme.textTheme.bodyMedium!.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }
}
