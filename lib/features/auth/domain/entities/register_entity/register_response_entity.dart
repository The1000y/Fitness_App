import 'package:fitness_app/features/auth/domain/entities/register_entity/user_enity.dart';

class RegisterResponeEntity {
  String? message;
  UserEntity? user;
  String? token;

  RegisterResponeEntity({this.message, this.user, this.token});
}
