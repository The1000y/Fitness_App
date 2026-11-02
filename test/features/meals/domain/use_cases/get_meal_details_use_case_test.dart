import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/meals/domain/entities/details_meal_entity.dart';
import 'package:fitness_app/features/meals/domain/use_cases/get_meal_details_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../helpers/fakes.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late FakeMealsRepo fakeMealsRepo;
  late GetMealDetailsUseCase useCase;

  setUp(() {
    fakeMealsRepo = FakeMealsRepo();
    useCase = GetMealDetailsUseCase(fakeMealsRepo);
  });

  group('GetMealDetailsUseCase', () {
    test('calls MealsRepo.getMealDetails with provided mealId and returns Success', () async {
      fakeMealsRepo.nextResult = Success([TestData.detailsMealEntity]);

      final result = await useCase.call(TestData.mealId);

      expect(fakeMealsRepo.callCount, 1);
      expect(fakeMealsRepo.lastMealId, TestData.mealId);
      expect(result, isA<Success<List<DetailsMealEntity>>>());
      final success = result as Success<List<DetailsMealEntity>>;
      expect(success.data.first.idMeal, TestData.mealId);
    });

    test('forwards Error result unchanged from MealsRepo', () async {
      const failure = ServerFailure(statusCode: 500);
      fakeMealsRepo.nextResult = const Error<List<DetailsMealEntity>>(failure);

      final result = await useCase.call(TestData.mealId);

      expect(fakeMealsRepo.callCount, 1);
      expect(fakeMealsRepo.lastMealId, TestData.mealId);
      expect(result, isA<Error<List<DetailsMealEntity>>>());
      final error = result as Error<List<DetailsMealEntity>>;
      expect(error.failure, equals(failure));
    });
  });
}

