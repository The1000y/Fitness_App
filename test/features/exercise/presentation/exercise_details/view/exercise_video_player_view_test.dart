import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/exercise_video_player_view.dart';
import '../../../../../helpers/pump_app.dart';

void main() {
  const exercise = ExerciseEntity(
    id: 'exercise_1',
    exercise: 'Push Up',
    difficultyLevel: 'Intermediate',
    targetMuscleGroup: 'Chest',
    primeMoverMuscle: 'Pectoralis Major',
    secondaryMuscle: 'Triceps',
    tertiaryMuscle: 'Anterior Deltoid',
    primaryEquipment: 'Bodyweight',
    shortYoutubeDemonstrationLink: '',
    bodyRegion: 'Upper Body',
    mechanics: 'Compound',
  );

  group('ExerciseVideoPlayerView', () {
    testWidgets('renders the exercise title, chips and target muscles', (
      tester,
    ) async {
      await tester.pumpApp(const ExerciseVideoPlayerView(exercise: exercise));
      await tester.pump();

      expect(find.text('Push Up'), findsNWidgets(2));
      expect(find.text('Bodyweight'), findsOneWidget);
      expect(find.text('Intermediate'), findsOneWidget);
      expect(find.text('Compound'), findsOneWidget);
      expect(find.text('Target Muscles'), findsOneWidget);
      expect(find.text('Prime Mover: '), findsOneWidget);
      expect(find.text('Pectoralis Major'), findsOneWidget);
      expect(find.text('Secondary: '), findsOneWidget);
      expect(find.text('Triceps'), findsOneWidget);
      expect(find.text('Tertiary: '), findsOneWidget);
      expect(find.text('Anterior Deltoid'), findsOneWidget);
    });

    testWidgets('renders the details section', (tester) async {
      await tester.pumpApp(const ExerciseVideoPlayerView(exercise: exercise));
      await tester.pump();

      expect(find.text('Details'), findsOneWidget);
      expect(find.text('Body Region: '), findsOneWidget);
      expect(find.text('Upper Body'), findsOneWidget);
      expect(find.text('Target Group: '), findsOneWidget);
      expect(find.text('Chest'), findsOneWidget);
    });

    testWidgets('hides optional muscles when they are null', (tester) async {
      const minimal = ExerciseEntity(
        id: 'exercise_2',
        exercise: 'Plank',
        difficultyLevel: 'Beginner',
        targetMuscleGroup: 'Core',
        primeMoverMuscle: 'Rectus Abdominis',
        primaryEquipment: 'Bodyweight',
        shortYoutubeDemonstrationLink: '',
        bodyRegion: 'Core',
        mechanics: 'Isolation',
      );

      await tester.pumpApp(const ExerciseVideoPlayerView(exercise: minimal));
      await tester.pump();

      expect(find.text('Secondary: '), findsNothing);
      expect(find.text('Tertiary: '), findsNothing);
      expect(find.text('Short Demo'), findsNothing);
    });

    testWidgets('back button pops the screen', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        const ExerciseVideoPlayerView(exercise: exercise),
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.byType(ExerciseVideoPlayerView), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pumpAndSettle();

      expect(find.text('open'), findsOneWidget);
      expect(find.byType(ExerciseVideoPlayerView), findsNothing);
    });
  });
}
