import 'package:dio/dio.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/meals/data/model/details_meal_dto.dart';
import 'package:fitness_app/features/meals/data/repo_impl/meals_repo_impl.dart';
import 'package:fitness_app/features/meals/domain/entities/details_meal_entity.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_category_entity.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/meals_test_data.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late FakeMealsRemoteDataSource fakeRemote;
  late MealsRepoImpl repo;

  setUp(() {
    fakeRemote = FakeMealsRemoteDataSource();
    repo = MealsRepoImpl(mealsRemoteDataSource: fakeRemote);
  });

  group('MealsRepoImpl', () {
    test(
      'getMealsCategories returns Success with mapped entities when remote succeeds',
      () async {
        fakeRemote.nextCategoriesResponse = MealsTestData.categoriesResponse;

        final result = await repo.getMealsCategories();

        expect(fakeRemote.getCategoriesCallCount, 1);
        expect(result, isA<Success<List<MealCategoryEntity>>>());
        final data = (result as Success<List<MealCategoryEntity>>).data;
        expect(data.length, 3);
        expect(data.first.id, '1');
        expect(data.first.name, 'Beef');
        expect(
          data.first.thumbnail,
          'https://www.themealdb.com/images/category/beef.png',
        );
      },
    );

    test(
      'getMealDetails delegates to data source with correct mealId and maps DTOs to entities',
      () async {
        fakeRemote.nextResult = Success([TestData.detailsMealDto]);

        final result = await repo.getMealDetails(TestData.mealId);

        expect(fakeRemote.callCount, 1);
        expect(fakeRemote.lastMealId, TestData.mealId);
        expect(result, isA<Success<List<DetailsMealEntity>>>());

        final success = result as Success<List<DetailsMealEntity>>;
        expect(success.data.length, 1);
        expect(success.data.first.idMeal, TestData.mealId);
        expect(success.data.first.strMeal, TestData.mealName);
        expect(success.data.first.ingredients.length, 3);
      },
    );

    test(
      'getMealsCategories returns Error with InternetConnectionFailure on connection error',
      () async {
        fakeRemote.nextCategoriesError = DioException(
          requestOptions: RequestOptions(path: '/categories.php'),
          type: DioExceptionType.connectionError,
        );

        final result = await repo.getMealsCategories();

        expect(result, isA<Error<List<MealCategoryEntity>>>());
        expect(
          (result as Error<List<MealCategoryEntity>>).failure,
          isA<InternetConnectionFailure>(),
        );
      },
    );

    test(
      'getMealDetails returns Success with empty list when data source returns empty list',
      () async {
        fakeRemote.nextResult = const Success(<DetailsMealDto>[]);

        final result = await repo.getMealDetails(TestData.mealId);

        expect(fakeRemote.callCount, 1);
        expect(result, isA<Success<List<DetailsMealEntity>>>());
        final success = result as Success<List<DetailsMealEntity>>;
        expect(success.data, isEmpty);
      },
    );

    test(
      'getMealsByCategory returns Success with mapped meal entities when remote succeeds',
      () async {
        fakeRemote.nextMealsResponse = MealsTestData.mealsResponse;

        final result = await repo.getMealsByCategory('Beef');

        expect(fakeRemote.getMealsCallCount, 1);
        expect(fakeRemote.lastCategory, 'Beef');
        expect(result, isA<Success<List<MealEntity>>>());
        final data = (result as Success<List<MealEntity>>).data;
        expect(data.length, 2);
        expect(data.first.id, '52874');
        expect(data.first.name, 'Beef Stew');
        expect(data.first.area, 'British');
        expect(data.first.country, 'United Kingdom');
      },
    );

    test('getMealsByCategory returns Error on server error', () async {
      fakeRemote.nextMealsError = DioException(
        requestOptions: RequestOptions(path: '/filter.php'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/filter.php'),
          statusCode: 500,
        ),
      );

      final result = await repo.getMealsByCategory('Beef');

      expect(result, isA<Error<List<MealEntity>>>());
    });

    test(
      'getMealDetails forwards Error when data source returns Error',
      () async {
        const failure = InternetConnectionFailure();
        fakeRemote.nextResult = const Error<List<DetailsMealDto>>(failure);

        final result = await repo.getMealDetails(TestData.mealId);

        expect(fakeRemote.callCount, 1);
        expect(result, isA<Error<List<DetailsMealEntity>>>());
        final error = result as Error<List<DetailsMealEntity>>;
        expect(error.failure, equals(failure));
      },
    );
  });
}
