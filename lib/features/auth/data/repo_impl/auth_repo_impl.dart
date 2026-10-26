import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:fitness_app/features/auth/data/model/requests/register_request/register_request_mapper.dart';
import 'package:fitness_app/features/auth/domain/entities/register_entity/register_request_entity.dart';
import 'package:fitness_app/features/auth/domain/entities/register_entity/register_response_entity.dart';
import 'package:fitness_app/features/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _dataSource;

  AuthRepoImpl({required this._dataSource});
  @override
  Future<BaseResponse<RegisterResponeEntity>> register(
    RegisterRequestEntity req,
  ) async {
    final response = await _dataSource.register(req.toDto());
    return switch (response) {
      Success(:final data) => Success(data.toEntity()),
      Error(:final failure) => Error(failure),
    };
  }
}
