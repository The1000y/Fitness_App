import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/hero_video_section.dart';
import '../../../../../../helpers/pump_app.dart';

void main() {
  const exercise = ExerciseEntity(
    id: 'exercise_1',
    exercise: 'Push Up',
    difficultyLevel: 'Intermediate',
    targetMuscleGroup: 'Chest',
    primeMoverMuscle: 'Pectoralis Major',
    primaryEquipment: 'Bodyweight',
    shortYoutubeDemonstrationLink: '',
    bodyRegion: 'Upper Body',
    mechanics: 'Compound',
  );

  group('HeroVideoSection', () {
    testWidgets('renders the muscle name and play hint', (tester) async {
      await tester.pumpApp(
        const HeroVideoSection(exercise: exercise, muscleName: 'Chest'),
      );

      expect(find.text('Chest'), findsOneWidget);
      expect(find.text('Tap to play demo'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    });

    testWidgets('shows the placeholder when the demo link is empty', (
      tester,
    ) async {
      await tester.pumpApp(
        const HeroVideoSection(exercise: exercise, muscleName: 'Chest'),
      );

      expect(find.byIcon(Icons.fitness_center), findsOneWidget);
      expect(find.byType(AspectRatio), findsOneWidget);
    });

    testWidgets('tapping without a video id does not start playback', (
      tester,
    ) async {
      await tester.pumpApp(
        const HeroVideoSection(exercise: exercise, muscleName: 'Chest'),
      );

      await tester.tap(find.byType(HeroVideoSection));
      await tester.pump();

      expect(find.text('Tap to play demo'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
    });

    testWidgets('shows the stop hint only while playing', (tester) async {
      await tester.pumpApp(
        const HeroVideoSection(exercise: exercise, muscleName: 'Chest'),
      );

      expect(find.text('Tap to stop demo'), findsNothing);
      expect(find.text('Tap to play demo'), findsOneWidget);
    });
  });
}
