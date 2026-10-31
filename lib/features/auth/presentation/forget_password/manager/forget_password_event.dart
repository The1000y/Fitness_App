
sealed class ForgetPasswordEvent {
  const ForgetPasswordEvent();
}

final class SendCodeEvent extends ForgetPasswordEvent {
  final String email;
  const SendCodeEvent(this.email);
}

final class VerifyOtpEvent extends ForgetPasswordEvent {
  final String code;
  const VerifyOtpEvent(this.code);
}

final class ResetPasswordEvent extends ForgetPasswordEvent {
  final String newPassword;
  const ResetPasswordEvent(this.newPassword);
}
final class ResendCodeEvent extends ForgetPasswordEvent {
  const ResendCodeEvent();
}