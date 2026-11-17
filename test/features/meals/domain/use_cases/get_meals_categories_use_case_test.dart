import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_category_entity.dart';
import 'package:fitness_app/features/meals/domain/use_cases/get_meals_categories_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/meals_fakes.dart';
import '../../../../helpers/meals_test_data.dart';

void main() {
  late FakeMealsRepo fakeRepo;
  late GetMealsCategoriesUseCase useCase;

  setUp(() {
    fakeRepo = FakeMealsRepo();
    useCase = GetMealsCategoriesUseCase(fakeRepo);
  });

  group('GetMealsCategoriesUseCase', () {
    test('forwards Success result from repository', () async {
      fakeRepo.nextCategoriesResult = Success(MealsTestData.categoryEntities);

      final result = await useCase();

      expect(fakeRepo.getCategoriesCallCount, 1);
      expect(result, isA<Success<List<MealCategoryEntity>>>());
      expect((result as Success).data, MealsTestData.categoryEntities);
    });

    test('forwards Error result from repository', () async {
      fakeRepo.nextCategoriesResult = const Error(InternetConnectionFailure());

      final result = await useCase();

      expect(fakeRepo.getCategoriesCallCount, 1);
      expect(result, isA<Error<List<MealCategoryEntity>>>());
      expect((result as Error).failure, isA<InternetConnectionFailure>());
    });
  });
}
