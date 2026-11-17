import 'package:injectable/injectable.dart';

import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:fitness_app/features/auth/domain/repo/auth_repo.dart';

@injectable
class LoginUseCase {
  final AuthRepo _repo;

  LoginUseCase(this._repo);

  Future<BaseResponse<LoginEntity>> call({
    required String email,
    required String password,
  }) {
    return _repo.login(email: email.trim(), password: password);
  }
}
