import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_entity.dart';
import 'package:fitness_app/features/meals/domain/use_cases/get_meals_by_category_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/meals_fakes.dart';
import '../../../../helpers/meals_test_data.dart';

void main() {
  late FakeMealsRepo fakeRepo;
  late GetMealsByCategoryUseCase useCase;

  setUp(() {
    fakeRepo = FakeMealsRepo();
    useCase = GetMealsByCategoryUseCase(fakeRepo);
  });

  group('GetMealsByCategoryUseCase', () {
    test('forwards category to repo and returns Success result', () async {
      fakeRepo.nextMealsResult = Success(MealsTestData.mealEntities);

      final result = await useCase('Beef');

      expect(fakeRepo.getMealsCallCount, 1);
      expect(fakeRepo.lastCategory, 'Beef');
      expect(result, isA<Success<List<MealEntity>>>());
      expect((result as Success).data, MealsTestData.mealEntities);
    });

    test('forwards Error result from repo', () async {
      fakeRepo.nextMealsResult = const Error(ServerFailure());

      final result = await useCase('Beef');

      expect(result, isA<Error<List<MealEntity>>>());
      expect((result as Error).failure, isA<ServerFailure>());
    });
  });
}
