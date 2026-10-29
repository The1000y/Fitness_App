import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/auth/domain/entities/params/register_params_entity.dart';
import 'package:fitness_app/features/auth/domain/entities/register_entity/register_response_entity.dart';
import 'package:fitness_app/features/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisterUseCase {
  final AuthRepo _repo;

  RegisterUseCase({required this._repo});

  Future<BaseResponse<RegisterResponeEntity>> call(
    RegisterParams params,
  ) async {
    return await _repo.register(params);
  }
}
