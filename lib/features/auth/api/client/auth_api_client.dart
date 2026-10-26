
import 'package:dio/dio.dart';
import 'package:fitness_app/core/constants/api_strings.dart';
import 'package:fitness_app/features/auth/data/model/requests/register_request/register_request.dart';
import 'package:fitness_app/features/auth/data/model/responces/register_request/register_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'auth_api_client.g.dart';

@singleton
@RestApi()
abstract class AuthApiClient{
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST(ApiStrings.signup)
  Future<RegisterResponseDto> register(@Body() RegisterRequestDto request);

}