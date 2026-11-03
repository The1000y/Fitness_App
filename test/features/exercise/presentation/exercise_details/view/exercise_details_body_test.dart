import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercises_list_entity.dart';
import 'package:fitness_app/features/exercise/domain/use_cases/get_exercises_use_case.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/manager/exercise_details_cubit.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/manager/exercise_details_event.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/exercise_details_body.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/exercise_empty_view.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/exercise_error_view.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/exercise_list_section.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/hero_video_section.dart';
import '../../../../../helpers/fakes.dart';
import '../../../../../helpers/pump_app.dart';
import '../../../../../helpers/test_data.dart';

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

  const loadedEntity = ExercisesListEntity(
    message: 'Success',
    totalExercises: 2,
    totalPages: 1,
    currentPage: 1,
    exercises: exercises,
  );

  late FakeExerciseRepo fakeRepo;
  late ExerciseDetailsCubit cubit;

  setUp(() {
    fakeRepo = FakeExerciseRepo();
    cubit = ExerciseDetailsCubit(GetExercisesUseCase(fakeRepo));
  });

  tearDown(() async {
    await cubit.close();
  });

  void load() {
    cubit.onEvent(
      const LoadExercises(
        primeMoverMuscleId: TestData.primeMoverMuscleId,
        difficultyLevelId: TestData.difficultyLevelId,
      ),
    );
  }

  Widget body() {
    return BlocProvider<ExerciseDetailsCubit>.value(
      value: cubit,
      child: const ExerciseDetailsBody(muscleName: 'Chest'),
    );
  }

  group('ExerciseDetailsBody', () {
    testWidgets('shows a loader while exercises are loading', (tester) async {
      fakeRepo.completer = Completer<BaseResponse<ExercisesListEntity>>();
      load();

      await tester.pumpApp(body());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders the hero section and exercise list on success', (
      tester,
    ) async {
      fakeRepo.nextResult = const Success(loadedEntity);
      load();

      await tester.pumpApp(body());
      await tester.pumpAndSettle();

      expect(find.byType(HeroVideoSection), findsOneWidget);
      expect(find.byType(ExerciseListSection), findsOneWidget);
      expect(find.text('Chest'), findsOneWidget);
      expect(find.text('Chest Exercises'), findsOneWidget);
      expect(find.text('Push Up'), findsOneWidget);
      expect(find.text('Dumbbell Fly'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('renders the error view when loading fails', (tester) async {
      fakeRepo.nextResult = const Error(UnknownFailure());
      load();

      await tester.pumpApp(body());
      await tester.pumpAndSettle();

      expect(find.byType(ExerciseErrorView), findsOneWidget);
      expect(find.text('Failed to load exercises'), findsOneWidget);
      expect(find.byType(HeroVideoSection), findsNothing);
    });

    testWidgets('renders the empty view when there are no exercises', (
      tester,
    ) async {
      fakeRepo.nextResult = const Success(
        ExercisesListEntity(
          message: 'Success',
          totalExercises: 0,
          totalPages: 0,
          currentPage: 0,
          exercises: [],
        ),
      );
      load();

      await tester.pumpApp(body());
      await tester.pumpAndSettle();

      expect(find.byType(ExerciseEmptyView), findsOneWidget);
      expect(find.text('No exercises found'), findsOneWidget);
      expect(find.byType(ExerciseListSection), findsNothing);
    });
  });
}
