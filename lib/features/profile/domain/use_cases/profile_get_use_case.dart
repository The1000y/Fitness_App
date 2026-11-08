import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_app/features/profile/domain/repo/profile_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileGetUseCase {
  final ProfileRepo _profileRepo;

  const ProfileGetUseCase(this._profileRepo);

  Future<BaseResponse<ProfileEntity>> call() {
    return _profileRepo.getProfile();
  }
}
