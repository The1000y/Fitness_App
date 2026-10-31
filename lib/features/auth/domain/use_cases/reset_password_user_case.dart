import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/auth/domain/entities/params/reset_password_param.dart';
import 'package:fitness_app/features/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ResetPasswordUserCase {
 final AuthRepo authRepo;

 const ResetPasswordUserCase(this.authRepo);

  Future<BaseResponse<void>> call(ResetPasswordParam param) async {
    return await authRepo.resetPassword(param);
  }
}
