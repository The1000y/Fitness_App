import 'dart:async';

import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_by_group_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_entity.dart';
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

  test('emits loading then loaded category groups', () async {
    const groups = MusclesByGroupEntity(
      message: 'success',
      musclesGroup: [MuscleGroupEntity(id: 'group-1', name: 'Chest')],
    );
    when(
      () => repo.getMusclesGroups(),
    ).thenAnswer((_) async => const Success(groups));
    final states = <dynamic>[];
    final subscription = cubit.stream.listen(states.add);
    final loaded = cubit.stream.firstWhere(
      (state) => state.workoutCategoriesState.data != null,
    );

    cubit.onEvent(const WorkoutCategoriesRequested());
    final state = await loaded;

    expect(states.first.workoutCategoriesState.isLoading, isTrue);
    expect(state.workoutCategoriesState.data, groups);
    expect(state.workoutCategoriesState.isLoading, isFalse);
    verify(() => repo.getMusclesGroups()).called(1);
    await subscription.cancel();
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
  });

  test(
    'keeps existing muscle data while loading and after a failure',
    () async {
      const firstResult = MusclesEntity(
        message: 'previous',
        totalMuscles: 1,
        muscles: [
          MuscleEntity(id: 'muscle-1', name: 'Chest', image: 'chest.png'),
        ],
      );
      when(
        () => repo.getMusclesByGroup(id: 'group-1'),
      ).thenAnswer((_) async => const Success(firstResult));

      final firstLoaded = cubit.stream.firstWhere(
        (state) => state.musclesState.data != null,
      );
      cubit.onEvent(const MusclesByGroupRequested(id: 'group-1'));
      await firstLoaded;

      final pending = Completer<BaseResponse<MusclesEntity>>();
      when(
        () => repo.getMusclesByGroup(id: 'group-2'),
      ).thenAnswer((_) => pending.future);

      final loading = cubit.stream.firstWhere(
        (state) => state.musclesState.isLoading,
      );
      cubit.onEvent(const MusclesByGroupRequested(id: 'group-2'));
      expect((await loading).musclesState.data, firstResult);

      final failed = cubit.stream.firstWhere(
        (state) => state.musclesState.errorMessage != null,
      );
      pending.complete(const Error(InternetConnectionFailure()));
      final state = await failed;

      expect(state.musclesState.errorMessage, isA<InternetConnectionFailure>());
      expect(state.musclesState.data, firstResult);
    },
  );

  test(
    'latest muscle group request wins when responses arrive out of order',
    () async {
      final firstRequest = Completer<BaseResponse<MusclesEntity>>();
      final secondRequest = Completer<BaseResponse<MusclesEntity>>();
      when(() => repo.getMusclesByGroup(id: any(named: 'id'))).thenAnswer((
        invocation,
      ) {
        final id = invocation.namedArguments[#id] as String;
        return id == 'group-1' ? firstRequest.future : secondRequest.future;
      });

      cubit.onEvent(const MusclesByGroupRequested(id: 'group-1'));
      await Future<void>.delayed(Duration.zero);
      cubit.onEvent(const MusclesByGroupRequested(id: 'group-2'));
      await Future<void>.delayed(Duration.zero);

      const latestResult = MusclesEntity(
        message: 'group-2',
        totalMuscles: 1,
        muscles: [
          MuscleEntity(id: 'muscle-2', name: 'Back', image: 'back.png'),
        ],
      );
      final latestLoaded = cubit.stream.firstWhere(
        (state) => state.musclesState.data?.message == 'group-2',
      );
      secondRequest.complete(const Success(latestResult));
      await latestLoaded;

      firstRequest.complete(
        const Success(
          MusclesEntity(message: 'group-1', totalMuscles: 0, muscles: []),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.musclesState.data, latestResult);
      verify(() => repo.getMusclesByGroup(id: 'group-1')).called(1);
      verify(() => repo.getMusclesByGroup(id: 'group-2')).called(1);
    },
  );

  test('does not emit a response after the cubit is closed', () async {
    final response = Completer<BaseResponse<MusclesEntity>>();
    when(
      () => repo.getMusclesByGroup(id: 'group-1'),
    ).thenAnswer((_) => response.future);

    cubit.onEvent(const MusclesByGroupRequested(id: 'group-1'));
    await Future<void>.delayed(Duration.zero);
    await cubit.close();
    response.complete(
      const Success(
        MusclesEntity(message: 'success', totalMuscles: 0, muscles: []),
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(cubit.isClosed, isTrue);
  });
}
