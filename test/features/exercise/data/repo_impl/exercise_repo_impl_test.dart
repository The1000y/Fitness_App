import 'package:dio/dio.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/exercise/data/data_source/remote/exercise_remote_data_source.dart';
import 'package:fitness_app/features/exercise/data/model/responses/muscle_group_response.dart';
import 'package:fitness_app/features/exercise/data/model/responses/muscle_response.dart';
import 'package:fitness_app/features/exercise/data/model/responses/muscles_by_group_response.dart';
import 'package:fitness_app/features/exercise/data/model/responses/muscles_response.dart';
import 'package:fitness_app/features/exercise/data/repo_impl/exercise_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockExerciseRemoteDataSource extends Mock
    implements ExerciseRemoteDataSource {}

void main() {
  late MockExerciseRemoteDataSource remote;
  late ExerciseRepoImpl repo;

  setUp(() {
    remote = MockExerciseRemoteDataSource();
    repo = ExerciseRepoImpl(remote);
  });

  test('maps group response to entities', () async {
    when(() => remote.getMusclesGroups()).thenAnswer(
      (_) async => MusclesResponse(
        message: 'success',
        musclesGroup: [MuscleGroupResponse(id: 'group-1', name: 'Abdominals')],
      ),
    );

    final result = await repo.getMusclesGroups();

    expect(result, isA<Success>());
    expect((result as Success).data.musclesGroup.single.id, 'group-1');
    verify(() => remote.getMusclesGroups()).called(1);
  });

  test('forwards the group id and maps muscle response to entities', () async {
    when(() => remote.getMusclesByGroup('group-1')).thenAnswer(
      (_) async => MusclesByGroupResponse(
        message: 'success',
        totalMuscles: 1,
        muscles: [
          MuscleResponse(
            id: 'muscle-1',
            name: 'Rectus Abdominis',
            image: 'https://example.com/rectus.png',
          ),
        ],
      ),
    );

    final result = await repo.getMusclesByGroup(id: 'group-1');

    expect(result, isA<Success>());
    final muscles = (result as Success).data.muscles;
    expect(muscles.single.name, 'Rectus Abdominis');
    expect(muscles.single.image, 'https://example.com/rectus.png');
    verify(() => remote.getMusclesByGroup('group-1')).called(1);
  });

  test('maps Dio connection failures to an application failure', () async {
    when(() => remote.getMusclesGroups()).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/muscles'),
        type: DioExceptionType.connectionError,
      ),
    );

    final result = await repo.getMusclesGroups();

    expect(result, isA<Error>());
    expect((result as Error).failure, isA<InternetConnectionFailure>());
  });
}
