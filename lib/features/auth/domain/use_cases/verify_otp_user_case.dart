import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/auth/domain/entities/params/verify_otp_param.dart';
import 'package:fitness_app/features/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class VerifyOtpUserCase {
  AuthRepo authRepo;
  VerifyOtpUserCase(this.authRepo);

  Future<BaseResponse<void>> call(VerifyOtpParam param) async {
    return await authRepo.verifyOtp(param);
  }
}
