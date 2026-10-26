import 'package:injectable/injectable.dart';

import 'package:fitness_app/config/base/base_response.dart';

import '../../../../config/utils/excecute_api_call.dart';
import '../../domain/entities/login_entity/login_entity.dart';
import '../../domain/repo/auth_repo.dart';
import '../data_source/remote/auth_remote_data_source.dart';
import '../model/requests/login_request/login_request.dart';

@LazySingleton(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final RemoteDataSource _remote;

  AuthRepoImpl(this._remote);

  @override
  Future<BaseResponse<LoginEntity>> login({
    required String email,
    required String password,
  }) {
    return excecuteApiCall(() async {
      final response = await _remote.login(
        LoginRequest(email: email, password: password),
      );
      return response.toEntity();
    });
  }
}