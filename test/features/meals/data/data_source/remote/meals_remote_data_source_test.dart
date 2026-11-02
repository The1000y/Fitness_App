import 'package:dio/dio.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/meals/api/meals_remote_data_source_impl.dart/meals_remote_data_source_impl.dart';
import 'package:fitness_app/features/meals/data/model/details_meal_dto.dart';
import 'package:fitness_app/features/meals/data/model/details_meal_response.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../../helpers/fakes.dart';
import '../../../../../helpers/test_data.dart';

void main() {
  late FakeMealsApiClient fakeApiClient;
  late MealsRemoteDataSourceImpl dataSource;

  setUp(() {
    fakeApiClient = FakeMealsApiClient();
    dataSource = MealsRemoteDataSourceImpl(apiClient: fakeApiClient);
  });

  group('MealsRemoteDataSourceImpl', () {
    test('getMealDetails delegates to MealsApiClient and returns Success on valid response', () async {
      fakeApiClient.nextResponse = TestData.detailsMealResponse;

      final result = await dataSource.getMealDetails(TestData.mealId);

      expect(fakeApiClient.callCount, 1);
      expect(fakeApiClient.lastMealId, TestData.mealId);
      expect(result, isA<Success<List<DetailsMealDto>>>());
      final success = result as Success<List<DetailsMealDto>>;
      expect(success.data.length, 1);
      expect(success.data.first.idMeal, TestData.mealId);
    });

    test('getMealDetails returns Success with empty list when response.meals is null', () async {
      fakeApiClient.nextResponse = DetailsMealResponse(meals: null);

      final result = await dataSource.getMealDetails(TestData.mealId);

      expect(fakeApiClient.callCount, 1);
      expect(result, isA<Success<List<DetailsMealDto>>>());
      final success = result as Success<List<DetailsMealDto>>;
      expect(success.data, isEmpty);
    });

    test('getMealDetails propagates DioException when apiClient throws', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/lookup.php'),
        response: Response(
          requestOptions: RequestOptions(path: '/lookup.php'),
          statusCode: 500,
        ),
        type: DioExceptionType.badResponse,
      );
      fakeApiClient.nextError = dioException;

      // Note: Because apiClient.getMealDetails is called outside excecuteApiCall in production,
      // the exception bubbles up directly rather than returning Error<List<DetailsMealDto>>.
      await expectLater(
        dataSource.getMealDetails(TestData.mealId),
        throwsA(isA<DioException>()),
      );
      expect(fakeApiClient.callCount, 1);
    });
  });
}
