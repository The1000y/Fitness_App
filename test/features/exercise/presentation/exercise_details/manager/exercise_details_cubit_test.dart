import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercises_list_entity.dart';
import 'package:fitness_app/features/exercise/domain/use_cases/get_difficulty_levels_use_case.dart';
import 'package:fitness_app/features/exercise/domain/use_cases/get_exercises_use_case.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/manager/exercise_details_cubit.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/manager/exercise_details_event.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/manager/exercise_details_state.dart';
import '../../../../../helpers/fakes.dart';
import '../../../../../helpers/test_data.dart';

void main() {
  late FakeExerciseRepo fakeRepo;
  late ExerciseDetailsCubit cubit;

  setUp(() {
    fakeRepo = FakeExerciseRepo();
    cubit = ExerciseDetailsCubit(
      GetDifficultyLevelsUseCase(fakeRepo),
      GetExercisesUseCase(fakeRepo),
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  void loadLevels() {
    cubit.onEvent(
      const LoadLevels(primeMoverMuscleId: TestData.primeMoverMuscleId),
    );
  }

  group('ExerciseDetailsCubit', () {
    test('starts with the default state', () {
      expect(cubit.state, const ExerciseDetailsState());
      expect(cubit.state.isLoadingMore, false);
      expect(cubit.state.autoPlay, false);
      expect(cubit.state.playRequestId, 0);
      expect(cubit.state.selectedExercise, isNull);
    });

    test('SelectExercise does nothing when there are no exercises', () {
      cubit.onEvent(const SelectExercise(2));

      expect(cubit.state.selectedIndex, 0);
      expect(cubit.state.playRequestId, 0);
      expect(fakeRepo.callCount, 0);
    });

    test('LoadLevels loads the first page and resets selection', () async {
      fakeRepo.nextResult = Success(TestData.exercisesListEntity);

      final states = <ExerciseDetailsState>[];
      final subState = cubit.stream.listen(states.add);
      addTearDown(subState.cancel);

      loadLevels();
      await pumpEventQueue();

      expect(fakeRepo.callCount, 1);
      expect(fakeRepo.lastPrimeMoverMuscleId, TestData.primeMoverMuscleId);
      expect(fakeRepo.lastDifficultyLevelId, TestData.difficultyLevelId);
      expect(fakeRepo.lastPage, 1);
      expect(fakeRepo.lastLimit, 10);
      expect(states.map((s) => s.exercisesState.isLoading).toList(), [
        false,
        false,
        true,
        false,
      ]);
      expect(states.last.exercisesState.data, TestData.exercisesListEntity);
      expect(states.last.selectedIndex, 0);
      expect(states.last.autoPlay, false);
      expect(states.last.exercisesState.errorMessage, isNull);
    });

    test('SelectExercise clamps the index and updates playback', () async {
      fakeRepo.nextResult = Success(TestData.exercisesListEntity);
      loadLevels();
      await pumpEventQueue();

      cubit.onEvent(const SelectExercise(99));
      expect(cubit.state.selectedIndex, 1);
      expect(cubit.state.autoPlay, false);
      expect(cubit.state.playRequestId, 1);

      cubit.onEvent(const SelectExercise(-4, autoPlay: true));
      expect(cubit.state.selectedIndex, 0);
      expect(cubit.state.autoPlay, true);
      expect(cubit.state.playRequestId, 2);
    });

    test('LoadLevels failure stores the failure and emits it once', () async {
      const failure = UnauthorizedFailure(serverMessage: 'Expired');
      fakeRepo.nextResult = const Error(failure);

      final uiEvents = <BaseUiEvent>[];
      final subUi = cubit.uiEventStream.listen(uiEvents.add);
      addTearDown(subUi.cancel);

      final states = <ExerciseDetailsState>[];
      final subState = cubit.stream.listen(states.add);
      addTearDown(subState.cancel);

      loadLevels();
      await pumpEventQueue();

      expect(states.map((s) => s.exercisesState.isLoading).toList(), [
        false,
        false,
        true,
        false,
      ]);
      expect(states.last.exercisesState.errorMessage, failure);
      expect(states.last.exercisesState.data, isNull);
      expect(uiEvents, hasLength(1));
      final event = uiEvents.single as ShowFailureMessage;
      expect(event.failure, failure);
    });

    test('can load again after a failure', () async {
      fakeRepo.nextResult = const Error(TimeoutFailure());
      loadLevels();
      await pumpEventQueue();
      expect(fakeRepo.callCount, 1);

      fakeRepo.nextResult = Success(TestData.exercisesListEntity);
      loadLevels();
      await pumpEventQueue();

      expect(fakeRepo.callCount, 2);
      expect(cubit.state.exercisesState.data, TestData.exercisesListEntity);
    });

    test('LoadLevels failure stores the levels failure', () async {
      const failure = TimeoutFailure();
      fakeRepo.nextLevelsResult = const Error(failure);

      final uiEvents = <BaseUiEvent>[];
      final subUi = cubit.uiEventStream.listen(uiEvents.add);
      addTearDown(subUi.cancel);

      loadLevels();
      await pumpEventQueue();

      expect(cubit.state.levelsState.errorMessage, failure);
      expect(cubit.state.levelsState.data, isNull);
      expect(cubit.state.exercisesState.data, isNull);
      expect(fakeRepo.callCount, 0);
      expect(uiEvents, hasLength(1));
      expect((uiEvents.single as ShowFailureMessage).failure, failure);
    });

    test('SelectLevel loads the chosen level and resets selection', () async {
      fakeRepo.nextLevelsResult = Success(TestData.difficultyLevelsEntity);
      fakeRepo.nextResult = Success(TestData.exercisesListEntity);
      loadLevels();
      await pumpEventQueue();

      expect(fakeRepo.lastDifficultyLevelId, 'difficulty_beginner');

      cubit.onEvent(const SelectExercise(1));
      expect(cubit.state.selectedIndex, 1);

      cubit.onEvent(const SelectLevel(1));
      await pumpEventQueue();

      expect(cubit.state.selectedLevelIndex, 1);
      expect(cubit.state.selectedIndex, 0);
      expect(fakeRepo.callCount, 2);
      expect(fakeRepo.lastDifficultyLevelId, TestData.difficultyLevelId);
    });

    test('SelectLevel ignores invalid and unchanged indexes', () async {
      fakeRepo.nextLevelsResult = Success(TestData.difficultyLevelsEntity);
      fakeRepo.nextResult = Success(TestData.exercisesListEntity);
      loadLevels();
      await pumpEventQueue();

      cubit.onEvent(const SelectLevel(5));
      cubit.onEvent(const SelectLevel(-1));
      cubit.onEvent(const SelectLevel(0));
      await pumpEventQueue();

      expect(cubit.state.selectedLevelIndex, 0);
      expect(fakeRepo.callCount, 1);
    });

    test(
      'LoadMoreExercises is ignored while the first page is loading',
      () async {
        fakeRepo.completer = Completer<BaseResponse<ExercisesListEntity>>();
        loadLevels();
        await pumpEventQueue();

        cubit.onEvent(const LoadMoreExercises());
        await pumpEventQueue();

        expect(fakeRepo.callCount, 1);
        expect(cubit.state.isLoadingMore, false);
      },
    );

    test('LoadMoreExercises appends the next page', () async {
      final firstPage = ExercisesListEntity(
        message: 'Success',
        totalExercises: 2,
        totalPages: 2,
        currentPage: 1,
        exercises: [TestData.exercisesListEntity.exercises.first],
      );
      final secondPage = ExercisesListEntity(
        message: 'Success',
        totalExercises: 2,
        totalPages: 2,
        currentPage: 2,
        exercises: [TestData.exercisesListEntity.exercises.last],
      );

      fakeRepo.nextResult = Success(firstPage);
      loadLevels();
      await pumpEventQueue();

      fakeRepo.nextResult = Success(secondPage);
      cubit.onEvent(const LoadMoreExercises());
      await pumpEventQueue();

      expect(fakeRepo.callCount, 2);
      expect(fakeRepo.lastPage, 2);
      expect(fakeRepo.lastLimit, 10);
      expect(cubit.state.isLoadingMore, false);
      expect(cubit.state.exercisesState.data?.currentPage, 2);
      expect(cubit.state.exercisesState.data?.totalPages, 2);
      expect(cubit.state.exercisesState.data?.exercises, hasLength(2));
    });

    test('LoadMoreExercises is ignored when there are no more pages', () async {
      fakeRepo.nextResult = Success(TestData.exercisesListEntity);
      loadLevels();
      await pumpEventQueue();

      cubit.onEvent(const LoadMoreExercises());
      await pumpEventQueue();

      expect(fakeRepo.callCount, 1);
    });

    test(
      'LoadMoreExercises failure keeps data and emits the failure',
      () async {
        final firstPage = ExercisesListEntity(
          message: 'Success',
          totalExercises: 2,
          totalPages: 2,
          currentPage: 1,
          exercises: [TestData.exercisesListEntity.exercises.first],
        );
        const failure = TimeoutFailure();

        fakeRepo.nextResult = Success(firstPage);
        loadLevels();
        await pumpEventQueue();

        final uiEvents = <BaseUiEvent>[];
        final subUi = cubit.uiEventStream.listen(uiEvents.add);
        addTearDown(subUi.cancel);

        fakeRepo.nextResult = const Error(failure);
        cubit.onEvent(const LoadMoreExercises());
        await pumpEventQueue();

        expect(cubit.state.isLoadingMore, false);
        expect(cubit.state.exercisesState.data, firstPage);
        expect(uiEvents, hasLength(1));
        expect((uiEvents.single as ShowFailureMessage).failure, failure);
      },
    );

    test('closing while loading then completing emits nothing', () async {
      final completer = Completer<BaseResponse<ExercisesListEntity>>();
      fakeRepo.completer = completer;

      final uiEvents = <BaseUiEvent>[];
      final subUi = cubit.uiEventStream.listen(uiEvents.add);
      addTearDown(subUi.cancel);

      final states = <ExerciseDetailsState>[];
      final subState = cubit.stream.listen(states.add);
      addTearDown(subState.cancel);

      loadLevels();
      await pumpEventQueue();

      await cubit.close();

      completer.complete(Success(TestData.exercisesListEntity));
      await pumpEventQueue();

      expect(states.map((s) => s.exercisesState.isLoading).toList(), [
        false,
        false,
        true,
      ]);
      expect(uiEvents, isEmpty);
    });
  });
}
