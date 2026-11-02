import 'package:fitness_app/features/meals/presentation/view/widgets/shimmers/shimmers.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  group('Meals Shimmer Widgets', () {
    testWidgets('CategoryTabBarShimmer renders without error', (tester) async {
      await tester.pumpApp(const CategoryTabBarShimmer());
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(CategoryTabBarShimmer), findsOneWidget);
    });

    testWidgets('MealCardShimmer renders without error', (tester) async {
      await tester.pumpApp(const MealCardShimmer());
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(MealCardShimmer), findsOneWidget);
    });

    testWidgets('MealsGridShimmer renders without error', (tester) async {
      await tester.pumpApp(const MealsGridShimmer());
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(MealsGridShimmer), findsOneWidget);
    });

    testWidgets('MealsViewShimmer renders without error', (tester) async {
      await tester.pumpApp(const MealsViewShimmer());
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(MealsViewShimmer), findsOneWidget);
      expect(find.byType(CategoryTabBarShimmer), findsOneWidget);
      expect(find.byType(MealsGridShimmer), findsOneWidget);
    });
  });
}
