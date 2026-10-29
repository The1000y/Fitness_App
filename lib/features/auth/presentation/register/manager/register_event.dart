import 'package:fitness_app/features/auth/presentation/register/manager/register_option.dart';

sealed class RegisterEvent {
  const RegisterEvent();
}

final class SubmitEvent extends RegisterEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  SubmitEvent({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });
}

final class GenderSelectedEvent extends RegisterEvent {
  final Gender gender;
  const GenderSelectedEvent(this.gender);
}

final class AgeChangedEvent extends RegisterEvent {
  final int age;
  const AgeChangedEvent(this.age);
}

final class WeightChangedEvent extends RegisterEvent {
  final int weight;
  const WeightChangedEvent(this.weight);
}

final class HeightChangedEvent extends RegisterEvent {
  final int height;
  const HeightChangedEvent(this.height);
}

final class GoalSelectedEvent extends RegisterEvent {
  final Goal goal;
  const GoalSelectedEvent(this.goal);
}

final class ActivityLevelSelectedEvent extends RegisterEvent {
  final ActivityLevel level;
  const ActivityLevelSelectedEvent(this.level);
}

final class NextStepEvent extends RegisterEvent {
  const NextStepEvent();
}

final class PreviousStepEvent extends RegisterEvent {
  const PreviousStepEvent();
}
