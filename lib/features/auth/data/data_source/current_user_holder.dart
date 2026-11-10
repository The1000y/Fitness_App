import 'package:fitness_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:injectable/injectable.dart';

@singleton
class CurrentUserHolder {
  UserEntity? user;
}