import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/user_entity.dart';

class LoginEntity extends Equatable {
  final String message;
  final UserEntity user;
  final String token;

  LoginEntity({required this.message, required this.user, required this.token});

  @override
  List<Object?> get props => [message, user, token];
}
