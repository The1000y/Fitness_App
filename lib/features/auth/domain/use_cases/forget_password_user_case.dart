import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/auth/domain/entities/params/forget_password_param.dart';
import 'package:fitness_app/features/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ForgetPasswordUserCase {
  final AuthRepo authRepo;
  const ForgetPasswordUserCase({required this.authRepo});

  Future<BaseResponse<void>> call(ForgetPasswordParam param) async {
    return await authRepo.forgetPassword(param);
  }
}
