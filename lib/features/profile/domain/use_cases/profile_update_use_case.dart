import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/profile/domain/entities/params/update_profile_param.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_app/features/profile/domain/repo/profile_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileUpdateUseCase {
  final ProfileRepo _profileRepo;

  const ProfileUpdateUseCase(this._profileRepo);

  Future<BaseResponse<ProfileEntity>> call(UpdateProfileParam param) {
    return _profileRepo.updateProfile(param);
  }
}