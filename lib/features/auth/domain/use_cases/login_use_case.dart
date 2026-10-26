import 'package:injectable/injectable.dart';

import '../../../../config/base/base_response.dart';
import '../entities/login_entity/login_entity.dart';
import '../repo/auth_repo.dart';

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
