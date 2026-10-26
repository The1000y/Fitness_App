import 'package:injectable/injectable.dart';

import '../../../../../config/base/base_cubit.dart';
import '../../../../../config/base/base_response.dart';
import '../../../../../config/base/base_ui_event.dart';
import '../../../../../config/routing/app_routes.dart';
import '../../../domain/use_cases/login_use_case.dart';
import 'login_event.dart';
import 'login_state.dart';



@injectable
class LoginCubit extends BaseCubit<LoginState, CommonUiEvent> {
  final LoginUseCase _loginUseCase;

  LoginCubit(this._loginUseCase) : super(const LoginState());

  void onEvent(LoginEvent event) {
    switch (event) {
      case LoginSubmitted():
        _login(event);
      case PasswordVisibilityToggled():
        emit(state.update(obscurePassword: !state.obscurePassword));
    }
  }

  Future<void> _login(LoginSubmitted event) async {
    if (state.isLoading) return;

    emit(state.update(isLoading: true));

    final result = await _loginUseCase(
      email: event.email,
      password: event.password,
    );

    emit(state.update(isLoading: false));

    switch (result) {
      case Success():
        emitEvent(const NavigateReplaceTo(AppRoutes.home));
      case Error(:final failure):
        emitEvent(ShowFailureMessage(failure));
    }
  }
}
