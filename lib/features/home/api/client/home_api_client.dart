import 'package:dio/dio.dart';
import 'package:fitness_app/core/constants/api_strings.dart';
import 'package:fitness_app/features/exercise/data/model/responses/muscles_by_group_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'home_api_client.g.dart';

@singleton
@RestApi()
abstract class HomeApiClient {
  @factoryMethod
  factory HomeApiClient(@Named(ApiStrings.namedFitnessDio) Dio dio) =
  _HomeApiClient;

  @GET(ApiStrings.randomMuscles)
  Future<MusclesByGroupResponse> getRandomMuscles();
}