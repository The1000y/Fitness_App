import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/hero_placeholder.dart';
import '../../../../../../helpers/pump_app.dart';

void main() {
  group('HeroPlaceholder', () {
    testWidgets('shows a loader and a back button while loading', (
      tester,
    ) async {
      await tester.pumpApp(
        const Scaffold(body: HeroPlaceholder(isLoading: true)),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(BackButton), findsOneWidget);
    });

    testWidgets('hides the loader when it is not loading', (tester) async {
      await tester.pumpApp(
        const Scaffold(body: HeroPlaceholder(isLoading: false)),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(BackButton), findsOneWidget);
    });
  });
}
