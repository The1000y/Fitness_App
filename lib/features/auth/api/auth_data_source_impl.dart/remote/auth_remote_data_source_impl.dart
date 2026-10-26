import 'package:dio/dio.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/auth/api/client/auth_api_client.dart';
import 'package:fitness_app/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:fitness_app/features/auth/data/model/requests/register_request/register_request.dart';
import 'package:fitness_app/features/auth/data/model/responces/register_request/register_response.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiClient _api;

  AuthRemoteDataSourceImpl({required this._api});
  @override
  Future<BaseResponse<RegisterResponseDto>> register(
    RegisterRequestDto req,
  ) async {
    try {
      final response = await _api.register(req);
      return Success(response);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 409) {
        return const Error(ConflictFailure());
      }
      return const Error(UnknownFailure());
    }
  }
}
