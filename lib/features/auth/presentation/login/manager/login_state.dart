import 'package:fitness_app/config/base/base_state.dart';

import '../../../domain/entities/login_entity/login_entity.dart';

class LoginState extends BaseState<LoginEntity> {
  const LoginState({super.isLoading, super.errorMessage, super.data});

  LoginState update({bool? isLoading}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      data: data,
    );
  }
}