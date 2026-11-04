import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/home/domain/repo/home_repo.dart';
import 'package:injectable/injectable.dart';

import '../../../exercise/domain/entities/muscles_entity.dart';

@injectable
class GetRandomMusclesUseCase {
  final HomeRepo _repo;

  GetRandomMusclesUseCase(this._repo);

  Future<BaseResponse<MusclesEntity>> call() {
    return _repo.getRandomMuscles();
  }
}