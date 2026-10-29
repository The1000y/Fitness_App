import 'package:fitness_app/config/base/base_cubit.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/config/localization/success_message_enum_mapper.dart';
import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/features/auth/domain/entities/params/register_params_entity.dart';
import 'package:fitness_app/features/auth/domain/use_cases/register_use_case.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_event.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_option.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_state.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_ui_event.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisterCubit extends BaseCubit<RegisterState, BaseUiEvent> {
  final RegisterUseCase ucase;

  RegisterCubit({required this.ucase})
    : super(const RegisterState(data: RegisterFormData()));

  Future<void> doEvent(RegisterEvent event) async {
    switch (event) {
      case SubmitEvent():
        _credentialsSubmitted(event);
      case GenderSelectedEvent(:final gender):
        _update((f) => f.copyWith(gender: gender));
      case AgeChangedEvent(:final age):
        _update((f) => f.copyWith(age: age));
      case WeightChangedEvent(:final weight):
        _update((f) => f.copyWith(weight: weight));
      case HeightChangedEvent(:final height):
        _update((f) => f.copyWith(height: height));
      case GoalSelectedEvent(:final goal):
        _update((f) => f.copyWith(goal: goal));
      case ActivityLevelSelectedEvent(:final level):
        _update((f) => f.copyWith(activityLevel: level));
      case NextStepEvent():
        await _next();
      case PreviousStepEvent():
        _previous();
    }
  }

  void _update(RegisterFormData Function(RegisterFormData f) change) {
    emit(state.copyWith(data: change(state.form)));
  }

  void _credentialsSubmitted(SubmitEvent e) {
    _update(
      (f) => f.copyWith(
        firstName: e.firstName,
        lastName: e.lastName,
        email: e.email,
        password: e.password,
      ),
    );
    emitEvent(const AcceptFirstUiEvent());
  }

  Future<void> _next() async {
    final form = state.form;
    if (state.isLoading || !form.canProceed) return;

    if (form.isLastStep) {
      await _submit();
    } else {
      final next = form.step + 1;
      _update((f) => f.copyWith(step: next));
      emitEvent(StepChangedUiEvent(next));
    }
  }

  void _previous() {
    if (state.isLoading) return;
    final step = state.form.step;

    if (step == 0) {
      emitEvent(const BackToCredentialsUiEvent());
    } else {
      final previous = step - 1;
      _update((f) => f.copyWith(step: previous));
      emitEvent(StepChangedUiEvent(previous));
    }
  }

  Future<void> _submit() async {
    final form = state.form;
    emit(RegisterState(isLoading: true, data: form));

    final result = await ucase(_buildRequest(form));

    switch (result) {
      case Success():
        emit(RegisterState(data: form));
        emitEvent(const ShowSuccessMessage(AppSuccessMessage.accountCreated));
        emitEvent(const NavigateReplaceTo(AppRoutes.login));
      case Error(:final failure):
        emit(RegisterState(errorMessage: failure, data: form));
        emitEvent(ShowFailureMessage(failure));
    }
  }

  RegisterParams _buildRequest(RegisterFormData f) {
    return RegisterParams(
      firstName: f.firstName.trim(),
      lastName: f.lastName.trim(),
      email: f.email.trim(),
      password: f.password,
      rePassword: f.password,
      gender: f.gender?.apiValue ?? '',
      age: f.age,
      weight: f.weight,
      height: f.height,
      goal: f.goal?.apiValue ?? '',
      activityLevel: f.activityLevel.apiValue,
    );
  }
}
