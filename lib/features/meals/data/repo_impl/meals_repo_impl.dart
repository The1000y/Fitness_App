import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/meals/data/data_source/remote/meals_remote_data_source.dart';
import 'package:fitness_app/features/meals/data/model/details_meal_dto.dart';
import 'package:fitness_app/features/meals/domain/entities/details_meal_entity.dart';
import 'package:fitness_app/features/meals/domain/repo/meals_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: MealsRepo)
class MealsRepoImpl implements MealsRepo {
  final MealsRemoteDataSource mealsRemoteDataSource;
  const MealsRepoImpl({required this.mealsRemoteDataSource});
  @override
  Future<BaseResponse<List<DetailsMealEntity>>> getMealDetails(
    String mealId,
  ) async {
    final result = await mealsRemoteDataSource.getMealDetails(mealId);

    switch (result) {
      case Success<List<DetailsMealDto>>():
        {
          final mealsEntity = result.data.map((e) {
            return e.toEntity();
          }).toList();
          return Success<List<DetailsMealEntity>>(mealsEntity);
        }

      case Error<List<DetailsMealDto>>():
        {
          return Error<List<DetailsMealEntity>>(result.failure);
        }
    }
  }
}
