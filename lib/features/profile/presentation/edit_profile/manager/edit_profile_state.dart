import 'package:equatable/equatable.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';

const Object _unset = Object();

class EditProfileState extends Equatable {
  final ProfileEntity? initialProfile;
  final double? weight;
  final String? goal;
  final String? activityLevel;
  final String? pickedPhotoPath;
  final BaseState<ProfileEntity> saveState;

  const EditProfileState({
    this.initialProfile,
    this.weight,
    this.goal,
    this.activityLevel,
    this.pickedPhotoPath,
    this.saveState = const BaseState<ProfileEntity>(),
  });

  bool get isSaving => saveState.isLoading;

  EditProfileState copyWith({
    Object? initialProfile = _unset,
    Object? weight = _unset,
    Object? goal = _unset,
    Object? activityLevel = _unset,
    Object? pickedPhotoPath = _unset,
    BaseState<ProfileEntity>? saveState,
  }) {
    return EditProfileState(
      initialProfile: identical(initialProfile, _unset)
          ? this.initialProfile
          : initialProfile as ProfileEntity?,
      weight: identical(weight, _unset) ? this.weight : weight as double?,
      goal: identical(goal, _unset) ? this.goal : goal as String?,
      activityLevel: identical(activityLevel, _unset)
          ? this.activityLevel
          : activityLevel as String?,
      pickedPhotoPath: identical(pickedPhotoPath, _unset)
          ? this.pickedPhotoPath
          : pickedPhotoPath as String?,
      saveState: saveState ?? this.saveState,
    );
  }

  @override
  List<Object?> get props => [
    initialProfile,
    weight,
    goal,
    activityLevel,
    pickedPhotoPath,
    saveState,
  ];
}