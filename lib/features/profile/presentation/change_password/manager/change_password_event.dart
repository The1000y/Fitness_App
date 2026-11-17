sealed class ChangePasswordEvent {
  const ChangePasswordEvent();
}

final class SubmitChangePasswordEvent extends ChangePasswordEvent {
  final String oldPassword;
  final String newPassword;

  const SubmitChangePasswordEvent({
    required this.oldPassword,
    required this.newPassword,
  });
}
