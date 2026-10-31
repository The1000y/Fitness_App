import 'package:fitness_app/features/meals/presentation/widgets/information_data_about_meals.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MealInfoOverlay extends StatelessWidget {
  const MealInfoOverlay({
    super.key,
    required this.mealName,
    required this.mealDescription,
    required this.energyAmount,
    required this.protenAmount,
    required this.carbAmount,
    required this.fatAmount,
  });
  final String mealName;
  final String mealDescription;
  final String energyAmount;
  final String protenAmount;
  final String carbAmount;
  final String fatAmount;

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mealName,
            style: theme.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight(500),
            ),
          ),
          Gap(1),
          Text(mealDescription, style: theme.textTheme.titleMedium),
          Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InformationDataAboutMeals(
                number: energyAmount,
                title: l10n.energy,
              ),

              InformationDataAboutMeals(
                number: protenAmount,
                title: l10n.protein,
              ),

              InformationDataAboutMeals(number: carbAmount, title: l10n.carbs),

              InformationDataAboutMeals(number: fatAmount, title: l10n.fat),
            ],
          ),
          Gap(10),
        ],
      ),
    );
  }
}
