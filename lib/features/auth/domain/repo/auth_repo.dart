import '../../../../config/base/base_response.dart';
import '../entities/login_entity/login_entity.dart';

abstract interface class AuthRepo {
  Future<BaseResponse<LoginEntity>> login({
    required String email,
    required String password,
  });
}
