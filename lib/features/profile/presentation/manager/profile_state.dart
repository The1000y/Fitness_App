import 'package:equatable/equatable.dart';

import '../../../../config/base/base_state.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileState extends Equatable {
  final BaseState<ProfileEntity> profileState;

  const ProfileState({
    this.profileState = const BaseState<ProfileEntity>(),
  });

  ProfileState copyWith({BaseState<ProfileEntity>? profileState}) {
    return ProfileState(
      profileState: profileState ?? this.profileState,
    );
  }

  @override
  List<Object?> get props => [profileState];
}

