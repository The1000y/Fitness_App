import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_entity.dart';

abstract interface class HomeRepo {
  Future<BaseResponse<MusclesEntity>> getRandomMuscles();

  Future<BaseResponse<UserEntity>> getCurrentUser();
}