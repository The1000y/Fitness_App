import 'package:equatable/equatable.dart';
import 'package:fitness_app/config/base/base_state.dart';

class ChangePasswordState extends Equatable {
  final BaseState<void> changePasswordState;

  const ChangePasswordState({
    this.changePasswordState = const BaseState<void>(),
  });

  bool get isLoading => changePasswordState.isLoading;

  ChangePasswordState copyWith({BaseState<void>? changePasswordState}) {
    return ChangePasswordState(
      changePasswordState: changePasswordState ?? this.changePasswordState,
    );
  }

  @override
  List<Object?> get props => [changePasswordState];
}
