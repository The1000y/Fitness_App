import 'package:dio/dio.dart';
import 'package:fitness_app/core/constants/api_strings.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../data/model/requests/login_request/login_request.dart';
import '../../data/model/responses/login_response/login_response.dart';

part 'auth_api_client.g.dart';

@singleton
@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(@Named(ApiStrings.namedFitnessDio) Dio dio) = _AuthApiClient;

  @POST(ApiStrings.signin)
  Future<LoginResponse> login(@Body() LoginRequest request);
}
