import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:fitness_app/features/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCurrentUserUseCase {
  final AuthRepo _repo;

  GetCurrentUserUseCase(this._repo);

  Future<BaseResponse<UserEntity>> call() {
    return _repo.getCurrentUser();
  }
}