import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/meals/presentation/view/widgets/data_of_ingredients.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DataOfIngredients', () {
    testWidgets('renders ingredient name and measure with appropriate styles', (tester) async {
      final theme = ThemeData.light();

      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: DataOfIngredients(
              strIngredient: 'Salmon',
              strMeasure: '2 fillets',
              theme: theme,
            ),
          ),
        ),
      );

      expect(find.text('Salmon'), findsOneWidget);
      expect(find.text('2 fillets'), findsOneWidget);

      final measureText = tester.widget<Text>(find.text('2 fillets'));
      expect(measureText.style?.color, AppColors.primary);
    });
  });
}

