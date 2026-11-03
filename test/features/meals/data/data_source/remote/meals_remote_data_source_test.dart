import 'package:fitness_app/features/meals/api/meals_remote_data_source_impl.dart/meals_remote_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/meals_fakes.dart';
import '../../../../../helpers/meals_test_data.dart';

void main() {
  late FakeMealsApiClient fakeApiClient;
  late MealsRemoteDataSourceImpl dataSource;

  setUp(() {
    fakeApiClient = FakeMealsApiClient();
    dataSource = MealsRemoteDataSourceImpl(fakeApiClient);
  });

  group('MealsRemoteDataSourceImpl', () {
    test(
      'getMealsCategories delegates call to MealsApiClient and returns response',
      () async {
        fakeApiClient.nextCategoriesResponse = MealsTestData.categoriesResponse;

        final result = await dataSource.getMealsCategories();

        expect(fakeApiClient.getCategoriesCallCount, 1);
        expect(result.categories?.length, 3);
        expect(result.categories?.first.strCategory, 'Beef');
      },
    );

    test(
      'getMealsByCategory delegates call to MealsApiClient with category and returns response',
      () async {
        fakeApiClient.nextMealsResponse = MealsTestData.mealsResponse;

        final result = await dataSource.getMealsByCategory('Beef');

        expect(fakeApiClient.getMealsCallCount, 1);
        expect(fakeApiClient.lastCategory, 'Beef');
        expect(result.meals?.length, 2);
        expect(result.meals?.first.strMeal, 'Beef Stew');
      },
    );
  });
}
