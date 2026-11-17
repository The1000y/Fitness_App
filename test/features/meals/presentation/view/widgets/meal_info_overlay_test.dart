import 'package:fitness_app/features/meals/presentation/view/widgets/meal_info_overlay.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../../helpers/pump_app.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  group('MealInfoOverlay', () {
    testWidgets(
      'renders mealName, description, and nutrient metrics with localized labels',
      (tester) async {
        await tester.pumpApp(
          const Scaffold(
            body: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(0.6)),
              child: MealInfoOverlay(
                mealName: 'Baked salmon',
                mealDescription: 'Seafood',
                energyAmount: '100 k',
                protenAmount: '15 G',
                carbAmount: '58 G',
                fatAmount: '20 G',
              ),
            ),
          ),
        );

        expect(find.text('Baked salmon'), findsOneWidget);
        expect(find.text('Seafood'), findsOneWidget);

        expect(find.text('100 k'), findsOneWidget);
        expect(find.text(l10n.energy), findsOneWidget);

        expect(find.text('15 G'), findsOneWidget);
        expect(find.text(l10n.protein), findsOneWidget);

        expect(find.text('58 G'), findsOneWidget);
        expect(find.text(l10n.carbs), findsOneWidget);

        expect(find.text('20 G'), findsOneWidget);
        expect(find.text(l10n.fat), findsOneWidget);
      },
    );
  });
}
