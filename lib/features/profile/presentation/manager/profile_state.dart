import 'package:equatable/equatable.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';

class ProfileState extends Equatable {
  final BaseState<ProfileEntity> profileState;
  final bool isLoggingOut;

  const ProfileState({
    this.profileState = const BaseState<ProfileEntity>(),
    this.isLoggingOut = false,
  });

  ProfileState copyWith({
    BaseState<ProfileEntity>? profileState,
    bool? isLoggingOut,
  }) {
    return ProfileState(
      profileState: profileState ?? this.profileState,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
    );
  }

  @override
  List<Object?> get props => [profileState, isLoggingOut];
}
