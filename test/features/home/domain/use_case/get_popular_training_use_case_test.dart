import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/app/presentation/cubit/locale/app_locale_cubit.dart';
import 'package:fitness_app/features/exercise/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_entity.dart';
import 'package:fitness_app/features/home/domain/services/random_service.dart';
import 'package:fitness_app/features/home/domain/use_case/get_popular_training_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../helpers/fakes.dart';

class FakeRandomService implements RandomService {
  final int indexToReturn;
  FakeRandomService([this.indexToReturn = 0]);

  @override
  int nextInt(int max) => indexToReturn < max ? indexToReturn : 0;
}

void main() {
  late FakeExerciseRepo fakeRepo;
  late FakeRandomService fakeRandomService;
  late GetPopularTrainingUseCase useCase;

  setUp(() async {
    await getIt.reset();
    final storage = InMemorySecureStorage();
    getIt.registerSingleton<AppLocaleCubit>(AppLocaleCubit(storage));

    fakeRepo = FakeExerciseRepo();
    fakeRandomService = FakeRandomService(0);
    useCase = GetPopularTrainingUseCase(fakeRepo, fakeRandomService);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('GetPopularTrainingUseCase', () {
    test('returns popular training list successfully', () async {
      fakeRepo.nextLevelsResult = const Success([
        DifficultyLevelEntity(id: 'diff-1', name: 'Beginner'),
      ]);
      fakeRepo.nextTotalExercisesResult = const Success(5);

      const muscle = MuscleEntity(id: 'muscle-1', name: 'Chest', image: 'url');

      final result = await useCase(muscles: [muscle]);

      expect(result, isA<Success<List<dynamic>>>());
      final trainings = (result as Success).data;
      expect(trainings.length, 1);
      expect(trainings.first.muscleId, 'muscle-1');
      expect(trainings.first.muscleName, 'Chest');
      expect(trainings.first.totalExercises, 5);
      expect(trainings.first.difficultyLevelId, 'diff-1');
    });

    test('returns empty list when difficulty levels list is empty', () async {
      fakeRepo.nextLevelsResult = const Success([]);

      const muscle = MuscleEntity(id: 'muscle-1', name: 'Chest', image: 'url');

      final result = await useCase(muscles: [muscle]);

      expect(result, isA<Success<List<dynamic>>>());
      final trainings = (result as Success).data;
      expect(trainings, isEmpty);
    });

    test('returns error when difficulty levels request fails', () async {
      fakeRepo.nextLevelsResult = const Error(TimeoutFailure());

      const muscle = MuscleEntity(id: 'muscle-1', name: 'Chest', image: 'url');

      final result = await useCase(muscles: [muscle]);

      expect(result, isA<Error<dynamic>>());
      expect((result as Error).failure, isA<TimeoutFailure>());
    });

    test('returns error when total exercises request fails', () async {
      fakeRepo.nextLevelsResult = const Success([
        DifficultyLevelEntity(id: 'diff-1', name: 'Beginner'),
      ]);
      fakeRepo.nextTotalExercisesResult = const Error(ServerFailure());

      const muscle = MuscleEntity(id: 'muscle-1', name: 'Chest', image: 'url');

      final result = await useCase(muscles: [muscle]);

      expect(result, isA<Error<dynamic>>());
      expect((result as Error).failure, isA<ServerFailure>());
    });

    test('limits processed muscles to maximum 5', () async {
      fakeRepo.nextLevelsResult = const Success([
        DifficultyLevelEntity(id: 'diff-1', name: 'Beginner'),
      ]);
      fakeRepo.nextTotalExercisesResult = const Success(3);

      final muscles = List.generate(
        7,
        (i) => MuscleEntity(id: 'm-$i', name: 'Muscle $i', image: 'img_$i'),
      );

      final result = await useCase(muscles: muscles);

      expect(result, isA<Success<List<dynamic>>>());
      final trainings = (result as Success).data;
      expect(trainings.length, 5);
      expect(fakeRepo.levelsCallCount, 5);
    });
  });
}
