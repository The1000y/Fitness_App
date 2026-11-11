import 'dart:async';

import 'package:fitness_app/config/base/base_cubit.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_app/features/profile/domain/use_cases/profile_get_use_case.dart';
import 'package:fitness_app/features/profile/domain/use_cases/profile_logout_use_case.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_event.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_state.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ProfileCubit extends BaseCubit<ProfileState, CommonUiEvent> {
  final ProfileGetUseCase _getProfileUseCase;
  final ProfileLogoutUseCase _logoutUseCase;

  ProfileCubit(this._getProfileUseCase, this._logoutUseCase)
    : super(const ProfileState());

  void onEvent(ProfileEvent event) {
    switch (event) {
      case LoadProfile():
        unawaited(_loadProfile());
      case LogoutRequested():
        unawaited(_logout());
    }
  }

  Future<void> _loadProfile() async {
    if (state.profileState.isLoading) return;
    emit(
      state.copyWith(
        profileState: const BaseState<ProfileEntity>(isLoading: true),
      ),
    );

    final result = await _getProfileUseCase();
    if (isClosed) return;

    switch (result) {
      case Success<ProfileEntity>():
        emit(
          state.copyWith(
            profileState: BaseState<ProfileEntity>(data: result.data),
          ),
        );
      case Error<ProfileEntity>():
        emit(
          state.copyWith(
            profileState: BaseState<ProfileEntity>(
              errorMessage: result.failure,
            ),
          ),
        );
        emitEvent(ShowFailureMessage(result.failure));
    }
  }

  Future<void> _logout() async {
    if (state.isLoggingOut) return;
    emit(state.copyWith(isLoggingOut: true));

    await _logoutUseCase();
    if (isClosed) return;

    emit(state.copyWith(isLoggingOut: false));
    emitEvent(const NavigateAndRemoveUntil(AppRoutes.login));
  }
}
