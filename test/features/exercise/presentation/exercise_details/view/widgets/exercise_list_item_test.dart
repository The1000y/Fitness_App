import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/exercise_list_item.dart';
import '../../../../../../helpers/pump_app.dart';
import '../../../../../../helpers/test_data.dart';

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

  group('ExerciseListItem', () {
    testWidgets('renders the exercise summary', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: ExerciseListItem(exercise: exercise, onTap: () {}),
        ),
      );

      expect(find.text('Push Up'), findsOneWidget);
      expect(find.text('Bodyweight'), findsOneWidget);
      expect(find.text('Intermediate • Compound'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
    });

    testWidgets('shows the placeholder icon when the demo link is empty', (
      tester,
    ) async {
      await tester.pumpApp(
        Scaffold(
          body: ExerciseListItem(
            exercise: TestData.emptyLinkExerciseEntity,
            onTap: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.fitness_center), findsOneWidget);
    });

    testWidgets('invokes onTap when the item is pressed', (tester) async {
      var taps = 0;

      await tester.pumpApp(
        Scaffold(
          body: ExerciseListItem(exercise: exercise, onTap: () => taps++),
        ),
      );

      await tester.tap(find.text('Push Up'));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('uses the surface color for the card', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: ExerciseListItem(exercise: exercise, onTap: () {}),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(ExerciseListItem),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, AppColors.neutral.shade600);
      expect(decoration.borderRadius, BorderRadius.circular(16.r));
    });
  });
}
