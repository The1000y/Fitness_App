import 'package:fitness_app/features/exercise/data/model/responses/muscles_by_group_response.dart';
import 'package:fitness_app/features/home/api/client/home_api_client.dart';
import 'package:fitness_app/features/home/data/data_source/remote/home_remote_data_source.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final HomeApiClient _homeApiClient;

  HomeRemoteDataSourceImpl(this._homeApiClient);

  @override
  Future<MusclesByGroupResponse> getRandomMuscles() {
    return _homeApiClient.getRandomMuscles();
  }
}