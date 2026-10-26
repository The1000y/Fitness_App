import '../../model/requests/login_request/login_request.dart';
import '../../model/responces/login_response/login_response.dart';

abstract interface class RemoteDataSource {
  Future<LoginResponse> login(LoginRequest login);

}
