import 'package:equatable/equatable.dart';
import 'package:fitness_app/config/base/base_state.dart';

class ForgetPasswordState extends Equatable {
  final BaseState<void> forgetPasswordState;
  final BaseState<void> resetPasswordState;
  final BaseState<void> verifyOtpState;

  const ForgetPasswordState({
    this.forgetPasswordState = const BaseState<void>(),
    this.resetPasswordState = const BaseState<void>(),
    this.verifyOtpState = const BaseState<void>(),
  });

  ForgetPasswordState copyWith({
    BaseState<void>? forgetPasswordState,
    BaseState<void>? resetPasswordState,
    BaseState<void>? verifyOtpState,
  }) {
    return ForgetPasswordState(
      forgetPasswordState: forgetPasswordState ?? this.forgetPasswordState,
      resetPasswordState: resetPasswordState ?? this.resetPasswordState,
      verifyOtpState: verifyOtpState ?? this.verifyOtpState,
    );
  }

  @override
  List<Object?> get props => [
    forgetPasswordState,
    resetPasswordState,
    verifyOtpState,
  ];
}
