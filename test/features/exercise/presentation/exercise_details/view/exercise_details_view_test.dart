import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercises_list_entity.dart';
import 'package:fitness_app/features/exercise/domain/use_cases/get_exercises_use_case.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/manager/exercise_details_cubit.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/exercise_details_view.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/exercise_empty_view.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/exercise_error_view.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/hero_video_section.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../../../helpers/fakes.dart';
import '../../../../../helpers/pump_app.dart';
import '../../../../../helpers/test_data.dart';

void main() {
  late AppLocalizations l10n;
  late FakeExerciseRepo fakeRepo;

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
  ];

  const loadedEntity = ExercisesListEntity(
    message: 'Success',
    totalExercises: 1,
    totalPages: 1,
    currentPage: 1,
    exercises: exercises,
  );

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  setUp(() {
    fakeRepo = FakeExerciseRepo();
    getIt.registerFactory<ExerciseDetailsCubit>(
      () => ExerciseDetailsCubit(GetExercisesUseCase(fakeRepo)),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  Widget view() => ExerciseDetailsView(
    primeMoverMuscleId: TestData.primeMoverMuscleId,
    difficultyLevelId: TestData.difficultyLevelId,
    muscleName: 'Chest',
  );

  group('ExerciseDetailsView', () {
    testWidgets('loads the exercises with the received ids', (tester) async {
      fakeRepo.nextResult = const Success(loadedEntity);

      await tester.pumpApp(view());
      await tester.pumpAndSettle();

      expect(fakeRepo.callCount, 1);
      expect(fakeRepo.lastPrimeMoverMuscleId, TestData.primeMoverMuscleId);
      expect(fakeRepo.lastDifficultyLevelId, TestData.difficultyLevelId);
      expect(find.byType(HeroVideoSection), findsOneWidget);
      expect(find.text('Chest Exercises'), findsOneWidget);
      expect(find.text('Push Up'), findsOneWidget);
    });

    testWidgets('shows a loader until the request completes', (tester) async {
      fakeRepo.completer = Completer<BaseResponse<ExercisesListEntity>>();

      await tester.pumpApp(view());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      fakeRepo.completer!.complete(const Success(loadedEntity));
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Push Up'), findsOneWidget);
    });

    testWidgets('shows the error view and a snackbar on failure', (
      tester,
    ) async {
      fakeRepo.nextResult = const Error(InternetConnectionFailure());

      await tester.pumpApp(view());
      await tester.pumpAndSettle();

      expect(find.byType(ExerciseErrorView), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.text(l10n.failureInternetConnection),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows the empty view when the list is empty', (tester) async {
      fakeRepo.nextResult = const Success(
        ExercisesListEntity(
          message: 'Success',
          totalExercises: 0,
          totalPages: 0,
          currentPage: 0,
          exercises: [],
        ),
      );

      await tester.pumpApp(view());
      await tester.pumpAndSettle();

      expect(find.byType(ExerciseEmptyView), findsOneWidget);
      expect(find.text('No exercises found'), findsOneWidget);
    });
  });
}
