
import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:fitness_app/features/app/presentation/cubit/auth/app_auth_cubit.dart';

import '../../../../../config/base/base_cubit.dart';
import '../../../../../config/base/base_response.dart';
import '../../../../../config/base/base_state.dart';
import '../../../../../config/base/base_ui_event.dart';
import '../../../../../config/routing/app_routes.dart';
import '../../../domain/use_cases/login_use_case.dart';
import 'login_event.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends BaseCubit<LoginState, CommonUiEvent> {
  final LoginUseCase _loginUseCase;
  final AppAuthCubit _appAuthCubit;

  LoginCubit(this._loginUseCase, this._appAuthCubit)
      : super(const LoginState());

  void onEvent(LoginEvent event) {
    switch (event) {
      case LoginSubmitted():
        unawaited(_login(event));
    }
  }

  Future<void> _login(LoginSubmitted event) async {
    if (state.loginState.isLoading) return;

    emit(state.copyWith(loginState: BaseState(isLoading: true)));

    final result = await _loginUseCase(
      email: event.email,
      password: event.password,
    );

    if (isClosed) return;

    switch (result) {
      case Success():
        final userId = result.data.user.id;

        if (userId != null && userId.trim().isNotEmpty) {
          _appAuthCubit.setUserId(userId);
        }

        emit(
          state.copyWith(
            loginState: BaseState(data: result.data, isLoading: false),
          ),
        );

        emitEvent(const NavigateReplaceTo(AppRoutes.main));

      case Error():
        emit(
          state.copyWith(
            loginState: BaseState(
              isLoading: false,
              errorMessage: result.failure,
            ),
          ),
        );

        emitEvent(ShowFailureMessage(result.failure));
    }
  }
}
