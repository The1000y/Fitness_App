import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/auth/domain/entities/register_entity/user_enity.dart';

class RegisterResponeEntity extends Equatable {
  final String? message;
  final UserEntity? user;
  final String? token;

  const RegisterResponeEntity({this.message, this.user, this.token});

  @override
  List<Object?> get props => [message, user, token];
}
