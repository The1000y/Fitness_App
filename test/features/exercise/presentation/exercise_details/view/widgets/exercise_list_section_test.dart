import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:fitness_app/features/exercise/domain/use_cases/get_exercises_use_case.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/manager/exercise_details_cubit.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/exercise_list_section.dart';
import '../../../../../../helpers/fakes.dart';

void main() {
  const exercises = [
    ExerciseEntity(
      id: 'exercise_1',
      exercise: 'Push Up',
      difficultyLevel: 'Intermediate',
      targetMuscleGroup: 'Chest',
      primeMoverMuscle: 'Pectoralis Major',
      primaryEquipment: 'Bodyweight',
      shortYoutubeDemonstrationLink: '',
      bodyRegion: 'Upper Body',
      mechanics: 'Compound',
    ),
    ExerciseEntity(
      id: 'exercise_2',
      exercise: 'Dumbbell Fly',
      difficultyLevel: 'Beginner',
      targetMuscleGroup: 'Chest',
      primeMoverMuscle: 'Pectoralis Major',
      primaryEquipment: 'Dumbbell',
      shortYoutubeDemonstrationLink: '',
      bodyRegion: 'Upper Body',
      mechanics: 'Isolation',
    ),
  ];

  late ExerciseDetailsCubit cubit;

  setUp(() {
    cubit = ExerciseDetailsCubit(GetExercisesUseCase(FakeExerciseRepo()));
  });

  tearDown(() async {
    await cubit.close();
  });

  Future<void> pumpSection(WidgetTester tester) async {
    tester.view.physicalSize =
        const Size(375, 812) * tester.view.devicePixelRatio;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ScreenUtilPlusInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          home: BlocProvider<ExerciseDetailsCubit>.value(
            value: cubit,
            child: Scaffold(
              body: CustomScrollView(
                slivers: [
                  ExerciseListSection(
                    muscleName: 'Chest',
                    exercises: exercises,
                  ),
                ],
              ),
            ),
          ),
          onGenerateRoute: (_) => MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('player screen')),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('ExerciseListSection', () {
    testWidgets('renders the section title and every exercise', (tester) async {
      await pumpSection(tester);

      expect(find.text('Chest Exercises'), findsOneWidget);
      expect(find.text('Push Up'), findsOneWidget);
      expect(find.text('Dumbbell Fly'), findsOneWidget);
    });

    testWidgets('tapping an item selects it and opens the video player', (
      tester,
    ) async {
      await pumpSection(tester);

      await tester.tap(find.text('Dumbbell Fly'));
      await tester.pumpAndSettle();

      expect(cubit.state.selectedIndex, 1);
      expect(find.text('player screen'), findsOneWidget);
    });

    testWidgets('tapping the first item keeps the index at zero', (
      tester,
    ) async {
      await pumpSection(tester);

      await tester.tap(find.text('Push Up'));
      await tester.pumpAndSettle();

      expect(cubit.state.selectedIndex, 0);
      expect(find.text('player screen'), findsOneWidget);
    });
  });
}
