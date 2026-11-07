import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/features/meals/presentation/widgets/information_data_about_meals.dart';
import 'package:fitness_app/features/meals/presentation/widgets/meal_info_overlay.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  group('MealInfoOverlay', () {
    testWidgets('renders the meal name and description', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: MealInfoOverlay(
            mealName: 'Grilled Salmon',
            mealDescription: 'Rich in omega-3',
            energyAmount: '350',
            protenAmount: '30',
            carbAmount: '10',
            fatAmount: '18',
          ),
        ),
      );

      expect(find.text('Grilled Salmon'), findsOneWidget);
      expect(find.text('Rich in omega-3'), findsOneWidget);
    });

    testWidgets('renders every nutrition value with its label', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: MealInfoOverlay(
            mealName: 'Grilled Salmon',
            mealDescription: 'Rich in omega-3',
            energyAmount: '350',
            protenAmount: '30',
            carbAmount: '10',
            fatAmount: '18',
          ),
        ),
      );

      expect(find.text('350'), findsOneWidget);
      expect(find.text(l10n.energy), findsOneWidget);
      expect(find.text('30'), findsOneWidget);
      expect(find.text(l10n.protein), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      expect(find.text(l10n.carbs), findsOneWidget);
      expect(find.text('18'), findsOneWidget);
      expect(find.text(l10n.fat), findsOneWidget);
      expect(find.byType(InformationDataAboutMeals), findsNWidgets(4));
    });
  });
}
