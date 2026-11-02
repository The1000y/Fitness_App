import 'package:dio/dio.dart';
import 'package:fitness_app/features/meals/api/client/meals_api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../helpers/fakes.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late Dio dio;
  late FakeHttpClientAdapter adapter;
  late MealsApiClient client;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://www.themealdb.com/api/json/v1/1'));
    adapter = FakeHttpClientAdapter();
    dio.httpClientAdapter = adapter;
    client = MealsApiClient(dio);
  });

  group('MealsApiClient', () {
    test(
      'getMealDetails sends GET request with mealId query param and parses response',
      () async {
        adapter.statusCode = 200;
        adapter.responseBody = TestData.detailsMealResponseJson;

        final response = await client.getMealDetails(TestData.mealId);

        expect(adapter.lastRequestOptions?.method, 'GET');
        expect(adapter.lastRequestOptions?.path, contains('/lookup.php'));
        expect(adapter.lastRequestOptions?.queryParameters, {
          'i': TestData.mealId,
        });
        expect(response.meals, isNotNull);
        expect(response.meals!.length, 1);
        expect(response.meals!.first.idMeal, TestData.mealId);
        expect(response.meals!.first.strMeal, TestData.mealName);
      },
    );

    test('getMealDetails throws DioException on error status code', () async {
      adapter.statusCode = 404;
      adapter.responseBody = {'message': 'Not Found'};

      await expectLater(
        client.getMealDetails('99999'),
        throwsA(
          isA<DioException>()
              .having((e) => e.response?.statusCode, 'statusCode', 404)
              .having((e) => e.type, 'type', DioExceptionType.badResponse),
        ),
      );
    });
  });
}
