import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../data/model/requests/login_request/login_request.dart';
import '../../data/model/responces/login_response/login_response.dart';

part 'auth_api_client.g.dart';

@singleton
@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST('https://fitness.elevateegy.com/api/v1/auth/signin')
  Future<LoginResponse> login(@Body() LoginRequest request);
}
