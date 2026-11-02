import 'package:dio/dio.dart';
import 'package:fitness_app/core/constants/api_strings.dart';
import 'package:fitness_app/features/meals/api/client/meals_api_client.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/meals_test_data.dart';

void main() {
  late Dio dio;
  late FakeHttpClientAdapter adapter;
  late MealsApiClient client;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: ApiStrings.mealBaseUrl));
    adapter = FakeHttpClientAdapter();
    dio.httpClientAdapter = adapter;
    client = MealsApiClient(dio);
  });

  group('MealsApiClient', () {
    test(
      'getMealsCategories sends GET request to categories endpoint and parses response',
      () async {
        adapter.statusCode = 200;
        adapter.responseBody = MealsTestData.categoriesResponseJson;

        final response = await client.getMealsCategories();

        expect(adapter.lastRequestOptions?.path, contains('/categories.php'));
        expect(adapter.lastRequestOptions?.method, 'GET');
        expect(response.categories, isNotNull);
        expect(response.categories?.length, 3);
        expect(response.categories?.first.strCategory, 'Beef');
        expect(response.categories?[1].strCategory, 'Chicken');
      },
    );

    test(
      'getMealsByCategory sends GET request with c query parameter and parses meals',
      () async {
        adapter.statusCode = 200;
        adapter.responseBody = MealsTestData.mealsResponseJson;

        final response = await client.getMealsByCategory('Beef');

        expect(adapter.lastRequestOptions?.path, contains('/filter.php'));
        expect(adapter.lastRequestOptions?.method, 'GET');
        expect(adapter.lastRequestOptions?.queryParameters['c'], 'Beef');
        expect(response.meals, isNotNull);
        expect(response.meals?.length, 2);
        expect(response.meals?.first.strMeal, 'Beef Stew');
        expect(response.meals?.first.idMeal, '52874');
      },
    );

    test('throws DioException when server responds with 500 error', () async {
      adapter.statusCode = 500;
      adapter.responseBody = {'message': 'Internal Server Error'};

      await expectLater(
        client.getMealsCategories(),
        throwsA(
          isA<DioException>()
              .having((e) => e.response?.statusCode, 'statusCode', 500)
              .having((e) => e.type, 'type', DioExceptionType.badResponse),
        ),
      );
    });
  });
}
