import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_by_group_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_entity.dart';
import 'package:fitness_app/features/exercise/domain/repo/exercise_repo.dart';
import 'package:fitness_app/features/exercise/domain/use_cases/get_muscle_groups_use_case.dart';
import 'package:fitness_app/features/exercise/domain/use_cases/get_muscles_by_group_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockExerciseRepo extends Mock implements ExerciseRepo {}

void main() {
  late MockExerciseRepo repo;

  setUp(() {
    repo = MockExerciseRepo();
  });

  test('GetMuscleGroupsUseCase returns the repository response', () async {
    const response = Success<MusclesByGroupEntity>(
      MusclesByGroupEntity(
        message: 'success',
        musclesGroup: [MuscleGroupEntity(id: 'group-1', name: 'Chest')],
      ),
    );
    when(() => repo.getMusclesGroups()).thenAnswer((_) async => response);

    final result = await GetMuscleGroupsUseCase(repo)();

    expect(result, same(response));
    verify(() => repo.getMusclesGroups()).called(1);
  });

  test(
    'GetMusclesByGroupUseCase forwards the id and returns the response',
    () async {
      const response = Error<MusclesEntity>(InternetConnectionFailure());
      when(
        () => repo.getMusclesByGroup(id: 'group-1'),
      ).thenAnswer((_) async => response);

      final result = await GetMusclesByGroupUseCase(repo)(id: 'group-1');

      expect(result, same(response));
      verify(() => repo.getMusclesByGroup(id: 'group-1')).called(1);
    },
  );
}
