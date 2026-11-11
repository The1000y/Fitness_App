
import 'package:fitness_app/config/base/base_cubit.dart';
import 'package:fitness_app/features/app/presentation/cubit/auth/app_auth_state.dart';
import 'package:fitness_app/features/app/presentation/cubit/auth/app_auth_ui_event.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppAuthCubit extends BaseCubit<AppAuthState, AppAuthUiEvent> {
  AppAuthCubit() : super(const AppAuthState());

  void setUserId(String userId) {
    if (userId.trim().isEmpty) return;

    emit(AppAuthState(userId: userId.trim()));
  }

  void sessionExpired() {
    emitEvent(const SessionExpiredUiEvent());
  }
}
