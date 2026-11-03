import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/utils/excecute_api_call.dart';
import 'package:fitness_app/features/meals/api/client/meals_api_client.dart';
import 'package:fitness_app/features/meals/data/data_source/remote/meals_remote_data_source.dart';
import 'package:fitness_app/features/meals/data/model/details_meal_dto.dart';

import 'package:injectable/injectable.dart';

@Injectable(as: MealsRemoteDataSource)
class MealsRemoteDataSourceImpl implements MealsRemoteDataSource {
  final MealsApiClient apiClient;
  const MealsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<BaseResponse<List<DetailsMealDto>>> getMealDetails(
    String mealId,
  ) async {
    return excecuteApiCall<List<DetailsMealDto>>(() async {
      final response = await apiClient.getMealDetails(mealId);
      return response.meals ?? const [];
    });
  }
}
