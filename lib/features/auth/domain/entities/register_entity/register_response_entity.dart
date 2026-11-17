import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/auth/domain/entities/register_entity/registered_user_entity.dart';

class RegisterResponeEntity extends Equatable {
  final String? message;
  final RegisteredUserEntity? user;
  final String? token;

  const RegisterResponeEntity({this.message, this.user, this.token});

  @override
  List<Object?> get props => [message, user, token];
}
