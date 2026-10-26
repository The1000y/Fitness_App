import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/auth/data/model/requests/register_request/register_request.dart';
import 'package:fitness_app/features/auth/data/model/responces/register_request/register_response.dart';

abstract class AuthRemoteDataSource {
  Future<BaseResponse<RegisterResponseDto>> register(RegisterRequestDto req );
}
