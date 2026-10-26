import 'package:fitness_app/config/base/base_ui_event.dart';

sealed class RegisterUiEvent extends BaseUiEvent {
  const RegisterUiEvent();
}

final class AcceptFirstUiEvent extends RegisterUiEvent {
  const AcceptFirstUiEvent();
}

final class StepChangedUiEvent extends RegisterUiEvent {
  final int step;
  const StepChangedUiEvent(this.step);
}

final class BackToCredentialsUiEvent extends RegisterUiEvent {
  const BackToCredentialsUiEvent();
}
