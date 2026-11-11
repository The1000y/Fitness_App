import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/exercise_hero_info.dart';
import '../../../../../../helpers/pump_app.dart';

void main() {
  group('ExerciseHeroInfo', () {
    testWidgets('renders the muscle name and the play hint', (tester) async {
      await tester.pumpApp(
        const Scaffold(body: ExerciseHeroInfo(muscleName: 'Chest')),
      );

      expect(find.text('Chest'), findsOneWidget);
      expect(find.text('Tap to play demo'), findsOneWidget);
    });
  });
}
