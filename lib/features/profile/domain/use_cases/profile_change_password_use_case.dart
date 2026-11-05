import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/profile/domain/entities/params/change_password_param.dart';
import 'package:fitness_app/features/profile/domain/repo/profile_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileChangePasswordUseCase {
  final ProfileRepo _profileRepo;

  const ProfileChangePasswordUseCase(this._profileRepo);

  Future<BaseResponse<void>> call(ChangePasswordParam param) {
    return _profileRepo.changePassword(param);
  }
}
