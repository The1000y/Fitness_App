import 'package:dio/dio.dart';
import 'package:fitness_app/core/constants/api_strings.dart';
import 'package:fitness_app/features/profile/data/model/requests/change_password_request.dart';
import 'package:fitness_app/features/profile/data/model/responses/profile_response_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'profile_api_client.g.dart';

@singleton
@RestApi()
abstract class ProfileApiClient {
  @factoryMethod
  factory ProfileApiClient(
    @Named(ApiStrings.namedFitnessDio) Dio dio,
  ) = _ProfileApiClient;

  @PATCH(ApiStrings.changePassword)
  Future<void> changePassword(@Body() ChangePasswordRequest request);

  @GET(ApiStrings.profileData)
  Future<ProfileResponseDto> getProfile();

  @GET(ApiStrings.logout)
  Future<void> logout();
}
