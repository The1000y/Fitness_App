
import 'package:fitness_app/config/base/base_cubit.dart';
import 'package:fitness_app/core/constants/storage_keys.dart';
import 'package:fitness_app/features/app/presentation/cubit/auth/app_auth_state.dart';
import 'package:fitness_app/features/app/presentation/cubit/auth/app_auth_ui_event.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppAuthCubit extends BaseCubit<AppAuthState, AppAuthUiEvent> {
  final FlutterSecureStorage _storage;

  AppAuthCubit(this._storage) : super(const AppAuthState());

  Future<void> setUserId(String userId) async {
    if (userId.trim().isEmpty) return;

    final normalizedUserId = userId.trim();
    await _storage.write(key: StorageKeys.kUserId, value: normalizedUserId);
    emit(AppAuthState(userId: normalizedUserId));
  }

  Future<void> restoreUserId() async {
    final userId = await _storage.read(key: StorageKeys.kUserId);

    if (userId != null && userId.trim().isNotEmpty) {
      emit(AppAuthState(userId: userId.trim()));
    }
  }

  Future<void> clearUserId() async {
    await _storage.delete(key: StorageKeys.kUserId);
    emit(const AppAuthState());
  }

  Future<void> sessionExpired() async {
    await clearUserId();
    emitEvent(const SessionExpiredUiEvent());
  }
}
