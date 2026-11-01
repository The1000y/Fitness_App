import 'package:dio/dio.dart';
import 'package:fitness_app/core/constants/api_strings.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'meals_api_client.g.dart';

@singleton
@RestApi()
abstract class MealsApiClient {
  @factoryMethod
  factory MealsApiClient(@Named(ApiStrings.namedMealDio) Dio dio) =
      _MealsApiClient;


}
