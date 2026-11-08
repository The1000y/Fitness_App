import 'package:equatable/equatable.dart';
import 'package:fitness_app/config/base/base_state.dart';

class ForgetPasswordState extends Equatable {
  final BaseState<void> forgetPasswordState;
  final BaseState<void> resetPasswordState;
  final BaseState<void> verifyOtpState;
  final int timerCount;
  final bool canResend;
  final bool isTimerExpired;

  const ForgetPasswordState({
    this.forgetPasswordState = const BaseState<void>(),
    this.resetPasswordState = const BaseState<void>(),
    this.verifyOtpState = const BaseState<void>(),
    this.timerCount = 12,
    this.canResend = false,
    this.isTimerExpired = false,
  });

  ForgetPasswordState copyWith({
    BaseState<void>? forgetPasswordState,
    BaseState<void>? resetPasswordState,
    BaseState<void>? verifyOtpState,
    bool? canResend,
    int? timerCount,
    bool? isTimerExpired,
  }) {
    return ForgetPasswordState(
      forgetPasswordState: forgetPasswordState ?? this.forgetPasswordState,
      resetPasswordState: resetPasswordState ?? this.resetPasswordState,
      verifyOtpState: verifyOtpState ?? this.verifyOtpState,
      canResend: canResend ?? this.canResend,
      timerCount: timerCount ?? this.timerCount,
      isTimerExpired: isTimerExpired ?? this.isTimerExpired,
    );
  }

  @override
  List<Object?> get props => [
    forgetPasswordState,
    resetPasswordState,
    verifyOtpState,
    timerCount,
    canResend,
    isTimerExpired,
  ];
}
