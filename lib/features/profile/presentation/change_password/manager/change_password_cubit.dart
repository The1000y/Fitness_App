import 'package:fitness_app/config/base/base_cubit.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/config/localization/success_message_enum_mapper.dart';
import 'package:fitness_app/features/profile/domain/entities/params/change_password_param.dart';
import 'package:fitness_app/features/profile/domain/use_cases/profile_change_password_use_case.dart';
import 'package:fitness_app/features/profile/presentation/change_password/manager/change_password_event.dart';
import 'package:fitness_app/features/profile/presentation/change_password/manager/change_password_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangePasswordCubit
    extends BaseCubit<ChangePasswordState, BaseUiEvent> {
  final ProfileChangePasswordUseCase _changePasswordUseCase;

  ChangePasswordCubit(this._changePasswordUseCase)
    : super(const ChangePasswordState());

  Future<void> doEvent(ChangePasswordEvent event) async {
    switch (event) {
      case SubmitChangePasswordEvent():
        await _changePassword(event);
    }
  }

  Future<void> _changePassword(SubmitChangePasswordEvent event) async {
    if (state.isLoading) return;
    emit(
      state.copyWith(
        changePasswordState: const BaseState<void>(isLoading: true),
      ),
    );

    final result = await _changePasswordUseCase(
      ChangePasswordParam(
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
      ),
    );

    switch (result) {
      case Success<void>():
        emit(
          state.copyWith(
            changePasswordState: const BaseState<void>(isLoading: false),
          ),
        );
        emitEvent(const ShowSuccessMessage(AppSuccessMessage.passwordChanged));
        emitEvent(const PopRoute());
      case Error<void>():
        emit(
          state.copyWith(
            changePasswordState: BaseState<void>(
              isLoading: false,
              errorMessage: result.failure,
            ),
          ),
        );
        emitEvent(ShowFailureMessage(result.failure));
    }
  }
}
