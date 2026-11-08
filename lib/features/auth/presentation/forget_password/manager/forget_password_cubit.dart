import 'dart:async';

import 'package:fitness_app/config/base/base_cubit.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/config/localization/success_message_enum_mapper.dart';
import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/features/auth/domain/entities/params/forget_password_param.dart';
import 'package:fitness_app/features/auth/domain/entities/params/reset_password_param.dart';
import 'package:fitness_app/features/auth/domain/entities/params/verify_otp_param.dart';
import 'package:fitness_app/features/auth/domain/use_cases/forget_password_user_case.dart';
import 'package:fitness_app/features/auth/domain/use_cases/reset_password_user_case.dart';
import 'package:fitness_app/features/auth/domain/use_cases/verify_otp_user_case.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/manager/forget_password_event.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/manager/forget_password_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class ForgetPasswordCubit extends BaseCubit<ForgetPasswordState, BaseUiEvent> {
  final ForgetPasswordUserCase _forgetPasswordUserCase;
  final VerifyOtpUserCase _verifyOtpUserCase;
  final ResetPasswordUserCase _resetPasswordUserCase;
  String? _email;
  Timer? _timer;
  static const int _resendDuration = 12;
  ForgetPasswordCubit(
    this._forgetPasswordUserCase,
    this._verifyOtpUserCase,
    this._resetPasswordUserCase,
  ) : super(ForgetPasswordState());

  Future<void> doEvent(ForgetPasswordEvent event) async {
    switch (event) {
      case SendCodeEvent():
        await _forgetPassword(event.email);
      case VerifyOtpEvent():
        await _verifyOtp(event.code);
      case ResetPasswordEvent():
        await _resetPassword(event.newPassword);
      case ResendCodeEvent():
        await _resendOtp();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    emit(
      state.copyWith(
        timerCount: _resendDuration,
        canResend: false,
        isTimerExpired: false,
      ),
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }

      if (state.timerCount > 1) {
        emit(state.copyWith(timerCount: state.timerCount - 1));
      } else {
        timer.cancel();
        emit(
          state.copyWith(
            timerCount: 0,
            canResend: true,
            isTimerExpired: true, // هنا الثواني خلصت -> الـ UI هيشغل الـ shake
          ),
        );
      }
    });
  }

  Future<void> _forgetPassword(String email) async {
    if (state.forgetPasswordState.isLoading) return;
    emit(
      state.copyWith(
        forgetPasswordState: state.forgetPasswordState.copyWith(
          isLoading: true,
        ),
      ),
    );
    final result = await _forgetPasswordUserCase.call(
      ForgetPasswordParam(email: email),
    );
    if (isClosed) return;
    switch (result) {
      case Success<void>():
        _email = email;
        emit(
          state.copyWith(
            forgetPasswordState: state.forgetPasswordState.copyWith(
              isLoading: false,
              data: result.data,
            ),
          ),
        );
        emitEvent(ShowSuccessMessage(AppSuccessMessage.otpSentSuccessfully));
        _startTimer();
        emitEvent(NavigateTo(AppRoutes.otpVerification));
      case Error<void>():
        emit(
          state.copyWith(
            forgetPasswordState: state.forgetPasswordState.copyWith(
              isLoading: false,
              errorMessage: result.failure,
              data: null,
            ),
          ),
        );
        emitEvent(ShowFailureMessage(result.failure));
    }
  }

  Future<void> _verifyOtp(String code) async {
    if (state.verifyOtpState.isLoading) return;
    emit(
      state.copyWith(
        verifyOtpState: state.verifyOtpState.copyWith(isLoading: true),
      ),
    );
    var result = await _verifyOtpUserCase.call(VerifyOtpParam(code));
    if (isClosed) return;
    switch (result) {
      case Success<void>():
        _timer?.cancel();
        emit(
          state.copyWith(
            verifyOtpState: state.verifyOtpState.copyWith(
              isLoading: false,
              data: result.data,
            ),
          ),
        );
        emitEvent(NavigateTo(AppRoutes.createPassword));
      case Error<void>():
        emit(
          state.copyWith(
            verifyOtpState: state.verifyOtpState.copyWith(
              isLoading: false,
              errorMessage: result.failure,
              data: null,
            ),
          ),
        );
        emitEvent(ShowFailureMessage(result.failure));
    }
  }

  Future<void> _resetPassword(String newPassword) async {
    final email = _email;
    if (state.resetPasswordState.isLoading || email == null) return;
    emit(
      state.copyWith(
        resetPasswordState: state.resetPasswordState.copyWith(isLoading: true),
      ),
    );
    var result = await _resetPasswordUserCase.call(
      ResetPasswordParam(password: newPassword, email: email),
    );
    if (isClosed) return;
    switch (result) {
      case Success<void>():
        emit(
          state.copyWith(
            resetPasswordState: state.resetPasswordState.copyWith(
              isLoading: false,
              data: result.data,
            ),
          ),
        );
        emitEvent(ShowSuccessMessage(AppSuccessMessage.passwordChanged));
        // emitEvent(NavigateReplaceTo(AppRoutes.login));
        emitEvent(NavigateAndRemoveUntil(AppRoutes.login));
      case Error<void>():
        emit(
          state.copyWith(
            resetPasswordState: state.resetPasswordState.copyWith(
              isLoading: false,
              errorMessage: result.failure,
              data: null,
            ),
          ),
        );
        emitEvent(ShowFailureMessage(result.failure));
    }
  }

  Future<void> _resendOtp() async {
    final email = _email;

    if (!state.canResend || email == null) return;

    emit(
      state.copyWith(
        isTimerExpired: false,
        canResend: false,
        forgetPasswordState: state.forgetPasswordState.copyWith(
          isLoading: true,
        ),
      ),
    );

    final result = await _forgetPasswordUserCase.call(
      ForgetPasswordParam(email: email),
    );

    if (isClosed) return;
    switch (result) {
      case Success<void>():
        emit(
          state.copyWith(
            forgetPasswordState: state.forgetPasswordState.copyWith(
              isLoading: false,
              data: result.data,
            ),
          ),
        );

        emitEvent(ShowSuccessMessage(AppSuccessMessage.otpSentSuccessfully));

        _startTimer(); // بنصفر العداد ونبدأ 60 ثانية من جديد بدون أي Navigate
      case Error<void>():
        emit(
          state.copyWith(
            canResend: true,
            forgetPasswordState: state.forgetPasswordState.copyWith(
              isLoading: false,
              errorMessage: result.failure,
            ),
          ),
        );
        emitEvent(ShowFailureMessage(result.failure));
    }
  }
}
