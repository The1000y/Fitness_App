import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/utils/excecute_api_call.dart';
import '../../domain/entities/login_entity/login_entity.dart';
import '../../domain/repo/auth_repo.dart';
import '../data_source/remote/auth_remote_data_source.dart';
import '../model/requests/login_request/login_request.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final RemoteDataSource _remote;

  AuthRepoImpl(this._remote);

  @override
  Future<BaseResponse<LoginEntity>> login({
    required String email,
    required String password,
  }) async {
    final result = await excecuteApiCall(() async {
      final response = await _remote.login(
        LoginRequest(email: email, password: password),
      );
      return response.toEntity();
    });

    return switch (result) {
      Success(:final data) when data.token.isEmpty => const Error<LoginEntity>(
        ServerFailure(),
      ),
      _ => result,
    };
  }
}
