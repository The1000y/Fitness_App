import 'package:equatable/equatable.dart';
import 'package:fitness_app/config/base/base_state.dart';

import '../../../domain/entities/login_entity/login_entity.dart';

class LoginState extends Equatable {
  final BaseState<LoginEntity> loginState;

  const LoginState({this.loginState = const BaseState<LoginEntity>()});

  LoginState copyWith({BaseState<LoginEntity>? loginState}) {
    return LoginState(loginState: loginState ?? this.loginState);
  }

  @override
  List<Object?> get props => [loginState];
}
