import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';

sealed class EditProfileEvent {
  const EditProfileEvent();
}

final class InitEditProfileEvent extends EditProfileEvent {
  final ProfileEntity profile;
  const InitEditProfileEvent(this.profile);
}

final class EditWeightChangedEvent extends EditProfileEvent {
  final double weight;
  const EditWeightChangedEvent(this.weight);
}

final class GoalChangedEvent extends EditProfileEvent {
  final String goal;
  const GoalChangedEvent(this.goal);
}

final class ActivityLevelChangedEvent extends EditProfileEvent {
  final String activityLevel;
  const ActivityLevelChangedEvent(this.activityLevel);
}

final class PickPhotoEvent extends EditProfileEvent {
  const PickPhotoEvent();
}

final class SaveEditProfileEvent extends EditProfileEvent {
  final String firstName;
  final String lastName;
  const SaveEditProfileEvent({
    required this.firstName,
    required this.lastName,
  });
}