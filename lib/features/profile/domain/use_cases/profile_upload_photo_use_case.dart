import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_app/features/profile/domain/repo/profile_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileUploadPhotoUseCase {
  final ProfileRepo _profileRepo;

  const ProfileUploadPhotoUseCase(this._profileRepo);

  Future<BaseResponse<ProfileEntity>> call(String photoPath) {
    return _profileRepo.uploadPhoto(photoPath);
  }
}