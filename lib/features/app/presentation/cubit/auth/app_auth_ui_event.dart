import 'package:fitness_app/config/base/base_ui_event.dart';

sealed class AppAuthUiEvent extends BaseUiEvent {
  const AppAuthUiEvent();
}

final class SessionExpiredUiEvent extends AppAuthUiEvent {
  const SessionExpiredUiEvent();
}
