import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/auth/domain/entities/params/register_params_entity.dart';
import 'package:fitness_app/features/auth/domain/entities/register_entity/register_response_entity.dart';

abstract interface class AuthRepo {
  Future<BaseResponse<RegisterResponeEntity>> register(RegisterParams params);
}
