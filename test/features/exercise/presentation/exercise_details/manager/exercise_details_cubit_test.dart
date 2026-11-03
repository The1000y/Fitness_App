import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercises_list_entity.dart';
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
    cubit = ExerciseDetailsCubit(GetExercisesUseCase(fakeRepo));
  });

  tearDown(() async {
    await cubit.close();
  });

  group('ExerciseDetailsCubit', () {
    test('starts with the default state', () {
      expect(cubit.state, const ExerciseDetailsState());
    });

    test('SelectExercise updates only the selected index', () {
      cubit.onEvent(const SelectExercise(2));

      expect(cubit.state.selectedIndex, 2);
      expect(cubit.state.exercisesState.data, isNull);
      expect(fakeRepo.callCount, 0);
    });

    test('LoadExercises emits loading then the loaded data', () async {
      fakeRepo.nextResult = Success(TestData.exercisesListEntity);

      final states = <ExerciseDetailsState>[];
      final subState = cubit.stream.listen(states.add);
      addTearDown(subState.cancel);

      cubit.onEvent(
        const LoadExercises(
          primeMoverMuscleId: TestData.primeMoverMuscleId,
          difficultyLevelId: TestData.difficultyLevelId,
        ),
      );

      await pumpEventQueue();

      expect(fakeRepo.callCount, 1);
      expect(fakeRepo.lastPrimeMoverMuscleId, TestData.primeMoverMuscleId);
      expect(fakeRepo.lastDifficultyLevelId, TestData.difficultyLevelId);
      expect(states.map((s) => s.exercisesState.isLoading).toList(), [
        true,
        false,
      ]);
      expect(states.last.exercisesState.data, TestData.exercisesListEntity);
      expect(states.last.exercisesState.errorMessage, isNull);
    });

    test(
      'LoadExercises failure stores the failure and emits it once',
      () async {
        const failure = UnauthorizedFailure(serverMessage: 'Expired');
        fakeRepo.nextResult = const Error(failure);

        final uiEvents = <BaseUiEvent>[];
        final subUi = cubit.uiEventStream.listen(uiEvents.add);
        addTearDown(subUi.cancel);

        final states = <ExerciseDetailsState>[];
        final subState = cubit.stream.listen(states.add);
        addTearDown(subState.cancel);

        cubit.onEvent(
          const LoadExercises(
            primeMoverMuscleId: TestData.primeMoverMuscleId,
            difficultyLevelId: TestData.difficultyLevelId,
          ),
        );

        await pumpEventQueue();

        expect(states.map((s) => s.exercisesState.isLoading).toList(), [
          true,
          false,
        ]);
        expect(states.last.exercisesState.errorMessage, failure);
        expect(states.last.exercisesState.data, isNull);
        expect(uiEvents, hasLength(1));
        final event = uiEvents.single as ShowFailureMessage;
        expect(event.failure, failure);
      },
    );

    test('a second LoadExercises while loading is ignored', () async {
      final completer = Completer<BaseResponse<ExercisesListEntity>>();
      fakeRepo.completer = completer;

      cubit.onEvent(
        const LoadExercises(
          primeMoverMuscleId: TestData.primeMoverMuscleId,
          difficultyLevelId: TestData.difficultyLevelId,
        ),
      );
      await pumpEventQueue();

      expect(fakeRepo.callCount, 1);

      cubit.onEvent(
        const LoadExercises(
          primeMoverMuscleId: 'other_muscle',
          difficultyLevelId: 'other_difficulty',
        ),
      );
      await pumpEventQueue();

      expect(fakeRepo.callCount, 1);

      completer.complete(Success(TestData.exercisesListEntity));
      await pumpEventQueue();
    });

    test('can load again after a failure', () async {
      fakeRepo.nextResult = const Error(TimeoutFailure());
      cubit.onEvent(
        const LoadExercises(
          primeMoverMuscleId: TestData.primeMoverMuscleId,
          difficultyLevelId: TestData.difficultyLevelId,
        ),
      );
      await pumpEventQueue();
      expect(fakeRepo.callCount, 1);

      fakeRepo.nextResult = Success(TestData.exercisesListEntity);
      cubit.onEvent(
        const LoadExercises(
          primeMoverMuscleId: TestData.primeMoverMuscleId,
          difficultyLevelId: TestData.difficultyLevelId,
        ),
      );
      await pumpEventQueue();

      expect(fakeRepo.callCount, 2);
      expect(cubit.state.exercisesState.data, TestData.exercisesListEntity);
    });

    test('closing while loading then completing emits nothing', () async {
      final completer = Completer<BaseResponse<ExercisesListEntity>>();
      fakeRepo.completer = completer;

      final uiEvents = <BaseUiEvent>[];
      final subUi = cubit.uiEventStream.listen(uiEvents.add);
      addTearDown(subUi.cancel);

      final states = <ExerciseDetailsState>[];
      final subState = cubit.stream.listen(states.add);
      addTearDown(subState.cancel);

      cubit.onEvent(
        const LoadExercises(
          primeMoverMuscleId: TestData.primeMoverMuscleId,
          difficultyLevelId: TestData.difficultyLevelId,
        ),
      );
      await pumpEventQueue();

      await cubit.close();

      completer.complete(Success(TestData.exercisesListEntity));
      await pumpEventQueue();

      expect(states.map((s) => s.exercisesState.isLoading).toList(), [true]);
      expect(uiEvents, isEmpty);
    });
  });
}
