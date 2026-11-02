import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/meals/data/model/details_meal_dto.dart';
import 'package:fitness_app/features/meals/data/repo_impl/meals_repo_impl.dart';
import 'package:fitness_app/features/meals/domain/entities/details_meal_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../helpers/fakes.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late FakeMealsRemoteDataSource fakeDataSource;
  late MealsRepoImpl repo;

  setUp(() {
    fakeDataSource = FakeMealsRemoteDataSource();
    repo = MealsRepoImpl(mealsRemoteDataSource: fakeDataSource);
  });

  group('MealsRepoImpl', () {
    test(
      'getMealDetails delegates to data source with correct mealId and maps DTOs to entities',
      () async {
        fakeDataSource.nextResult = Success([TestData.detailsMealDto]);

        final result = await repo.getMealDetails(TestData.mealId);

        expect(fakeDataSource.callCount, 1);
        expect(fakeDataSource.lastMealId, TestData.mealId);
        expect(result, isA<Success<List<DetailsMealEntity>>>());

        final success = result as Success<List<DetailsMealEntity>>;
        expect(success.data.length, 1);
        expect(success.data.first.idMeal, TestData.mealId);
        expect(success.data.first.strMeal, TestData.mealName);
        expect(success.data.first.ingredients.length, 3);
      },
    );

    test(
      'getMealDetails returns Success with empty list when data source returns empty list',
      () async {
        fakeDataSource.nextResult = const Success(<DetailsMealDto>[]);

        final result = await repo.getMealDetails(TestData.mealId);

        expect(fakeDataSource.callCount, 1);
        expect(result, isA<Success<List<DetailsMealEntity>>>());
        final success = result as Success<List<DetailsMealEntity>>;
        expect(success.data, isEmpty);
      },
    );

    test(
      'getMealDetails forwards Error when data source returns Error',
      () async {
        const failure = InternetConnectionFailure();
        fakeDataSource.nextResult = const Error<List<DetailsMealDto>>(failure);

        final result = await repo.getMealDetails(TestData.mealId);

        expect(fakeDataSource.callCount, 1);
        expect(result, isA<Error<List<DetailsMealEntity>>>());
        final error = result as Error<List<DetailsMealEntity>>;
        expect(error.failure, equals(failure));
      },
    );
  });
}
