import 'package:injectable/injectable.dart';

import '../../../data/data_source/remote/auth_remote_data_source.dart';
import '../../../data/model/requests/login_request/login_request.dart';
import '../../../data/model/responses/login_response/login_response.dart';
import '../../client/auth_api_client.dart';

@Injectable(as: RemoteDataSource)
class RemoteDataSourceImpl implements RemoteDataSource {
  final AuthApiClient _authApiClient;

  RemoteDataSourceImpl(this._authApiClient);

  @override
  Future<LoginResponse> login(LoginRequest login) {
    return _authApiClient.login(login);
  }
}