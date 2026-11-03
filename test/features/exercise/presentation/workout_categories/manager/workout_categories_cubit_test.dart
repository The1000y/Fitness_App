import 'dart:async';

import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_groups_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_by_group_entity.dart';
import 'package:fitness_app/features/exercise/domain/repo/exercise_repo.dart';
import 'package:fitness_app/features/exercise/domain/use_cases/get_muscle_groups_use_case.dart';
import 'package:fitness_app/features/exercise/domain/use_cases/get_muscles_by_group_use_case.dart';
import 'package:fitness_app/features/exercise/presentation/workout_categories/manager/workout_categories_cubit.dart';
import 'package:fitness_app/features/exercise/presentation/workout_categories/manager/workout_categories_event.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockExerciseRepo extends Mock implements ExerciseRepo {}

void main() {
  late MockExerciseRepo repo;
  late WorkoutCategoriesCubit cubit;

  setUp(() {
    repo = MockExerciseRepo();
    cubit = WorkoutCategoriesCubit(
      GetMuscleGroupsUseCase(repo),
      GetMusclesByGroupUseCase(repo),
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  test('emits loading and loaded categories, then loads the first group', () async {
    const categories = MuscleGroupsEntity(
      message: 'success',
      musclesGroup: [MuscleGroupEntity(id: 'group-1', name: 'Chest')],
    );
    const muscles = MusclesByGroupEntity(message: 'success', muscles: []);

    when(
      () => repo.getMusclesGroups(),
    ).thenAnswer((_) async => const Success(categories));
    when(
      () => repo.getMusclesByGroup(id: 'group-1'),
    ).thenAnswer((_) async => const Success(muscles));

    final loading = cubit.stream.firstWhere(
      (state) => state.workoutCategoriesState.isLoading,
    );
    final loaded = cubit.stream.firstWhere(
      (state) => state.workoutCategoriesState.data != null,
    );
    final musclesLoaded = cubit.stream.firstWhere(
      (state) => state.musclesState.data != null,
    );

    cubit.onEvent(const WorkoutCategoriesRequested());

    expect((await loading).workoutCategoriesState.isLoading, isTrue);
    final loadedState = await loaded;
    expect(loadedState.workoutCategoriesState.data, categories);
    expect(loadedState.workoutCategoriesState.isLoading, isFalse);
    expect(loadedState.selectedGroupId, 'group-1');
    expect((await musclesLoaded).musclesState.data, muscles);
    verify(() => repo.getMusclesGroups()).called(1);
    verify(() => repo.getMusclesByGroup(id: 'group-1')).called(1);
  });

  test('stores category failures and emits a failure UI event', () async {
    const failure = InternetConnectionFailure();
    when(
      () => repo.getMusclesGroups(),
    ).thenAnswer((_) async => const Error(failure));

    final event = cubit.uiEventStream.first;
    final failed = cubit.stream.firstWhere(
      (state) => state.workoutCategoriesState.errorMessage != null,
    );

    cubit.onEvent(const WorkoutCategoriesRequested());

    final state = await failed;
    expect(state.workoutCategoriesState.errorMessage, failure);
    expect(await event, isA<ShowFailureMessage>());
    verify(() => repo.getMusclesGroups()).called(1);
    verifyNever(() => repo.getMusclesByGroup(id: any(named: 'id')));
  });

  test('handles empty categories without requesting muscles', () async {
    const categories = MuscleGroupsEntity(message: 'success', musclesGroup: []);
    when(
      () => repo.getMusclesGroups(),
    ).thenAnswer((_) async => const Success(categories));

    final loaded = cubit.stream.firstWhere(
      (state) => state.workoutCategoriesState.data != null,
    );
    cubit.onEvent(const WorkoutCategoriesRequested());

    final state = await loaded;
    expect(state.workoutCategoriesState.data, categories);
    expect(state.selectedGroupId, isNull);
    verifyNever(() => repo.getMusclesByGroup(id: any(named: 'id')));
  });

  test('preserves existing muscles when a selected group request fails', () async {
    const categories = MuscleGroupsEntity(
      message: 'success',
      musclesGroup: [
        MuscleGroupEntity(id: 'group-1', name: 'Chest'),
        MuscleGroupEntity(id: 'group-2', name: 'Back'),
      ],
    );
    const existingMuscles = MusclesByGroupEntity(
      message: 'group-1',
      muscles: [
        MuscleEntity(id: 'muscle-1', name: 'Pectoral', image: 'chest.png'),
      ],
    );
    const failure = InternetConnectionFailure();

    when(
      () => repo.getMusclesGroups(),
    ).thenAnswer((_) async => const Success(categories));
    when(
      () => repo.getMusclesByGroup(id: 'group-1'),
    ).thenAnswer((_) async => const Success(existingMuscles));
    when(
      () => repo.getMusclesByGroup(id: 'group-2'),
    ).thenAnswer((_) async => const Error(failure));

    final musclesLoaded = cubit.stream.firstWhere(
      (state) => state.musclesState.data != null,
    );
    cubit.onEvent(const WorkoutCategoriesRequested());
    await musclesLoaded;

    final failed = cubit.stream.firstWhere(
      (state) => state.musclesState.errorMessage != null,
    );
    cubit.onEvent(const MuscleGroupSelected(id: 'group-2'));

    final state = await failed;
    expect(state.selectedGroupId, 'group-2');
    expect(state.musclesState.errorMessage, failure);
    expect(state.musclesState.data, existingMuscles);
    verify(() => repo.getMusclesByGroup(id: 'group-1')).called(1);
    verify(() => repo.getMusclesByGroup(id: 'group-2')).called(1);
  });

  test('ignores stale muscle responses when requests complete out of order', () async {
    const categories = MuscleGroupsEntity(
      message: 'success',
      musclesGroup: [
        MuscleGroupEntity(id: 'group-1', name: 'Chest'),
        MuscleGroupEntity(id: 'group-2', name: 'Back'),
      ],
    );
    final firstRequest = Completer<BaseResponse<MusclesByGroupEntity>>();
    final secondRequest = Completer<BaseResponse<MusclesByGroupEntity>>();

    when(
      () => repo.getMusclesGroups(),
    ).thenAnswer((_) async => const Success(categories));
    when(() => repo.getMusclesByGroup(id: any(named: 'id'))).thenAnswer((
      invocation,
    ) {
      final id = invocation.namedArguments[#id] as String;
      return id == 'group-1' ? firstRequest.future : secondRequest.future;
    });

    final categoriesLoaded = cubit.stream.firstWhere(
      (state) => state.workoutCategoriesState.data != null,
    );
    cubit.onEvent(const WorkoutCategoriesRequested());
    await categoriesLoaded;
    cubit.onEvent(const MuscleGroupSelected(id: 'group-2'));

    const latestMuscles = MusclesByGroupEntity(
      message: 'group-2',
      muscles: [MuscleEntity(id: 'muscle-2', name: 'Back', image: 'back.png')],
    );
    final latestLoaded = cubit.stream.firstWhere(
      (state) => state.musclesState.data == latestMuscles,
    );
    secondRequest.complete(const Success(latestMuscles));
    await latestLoaded;

    firstRequest.complete(
      const Success(
        MusclesByGroupEntity(message: 'group-1', muscles: []),
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.musclesState.data, latestMuscles);
    verify(() => repo.getMusclesByGroup(id: 'group-1')).called(1);
    verify(() => repo.getMusclesByGroup(id: 'group-2')).called(1);
  });
}
