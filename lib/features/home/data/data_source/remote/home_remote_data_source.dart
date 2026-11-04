import 'package:fitness_app/features/exercise/data/model/responses/muscles_by_group_response.dart';

abstract interface class HomeRemoteDataSource {
  Future<MusclesByGroupResponse> getRandomMuscles();
}