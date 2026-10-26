import 'package:fitness_app/config/base/base_state.dart';

import '../../../domain/entities/login_entity/login_entity.dart';

class LoginState extends BaseState<LoginEntity> {
  final bool obscurePassword;

  const LoginState({
    this.obscurePassword = true,
    super.isLoading,
    super.errorMessage,
    super.data,
  });

  LoginState update({bool? obscurePassword, bool? isLoading}) {
    return LoginState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      data: data,
    );
  }

  @override
  List<Object?> get props => [...super.props, obscurePassword];
}
