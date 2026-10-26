sealed class LoginEvent {
  const LoginEvent();
}

final class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  const LoginSubmitted({required this.email, required this.password});
}

final class PasswordVisibilityToggled extends LoginEvent {
  const PasswordVisibilityToggled();
}