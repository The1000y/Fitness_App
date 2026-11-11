import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/profile/domain/repo/profile_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileUpdateUseCase {
  final ProfileRepo _profileRepo;

  const ProfileUpdateUseCase(this._profileRepo);

  Future<BaseResponse<void>> call() {
    return _profileRepo.logout();
  }
}
