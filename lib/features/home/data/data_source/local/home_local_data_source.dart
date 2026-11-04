import 'package:fitness_app/features/auth/data/model/responses/login_response/user_response.dart';

abstract interface class HomeLocalDataSource {
  Future<UserResponse?> getCachedUser();
}