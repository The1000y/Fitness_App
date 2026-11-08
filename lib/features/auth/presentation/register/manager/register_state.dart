import 'package:equatable/equatable.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_option.dart';

typedef RegisterState = BaseState<RegisterFormData>;

// imake this data to avoid ! null data
extension RegisterStateX on RegisterState {
  RegisterFormData get form => data ?? RegisterFormData();
}

class RegisterFormData extends Equatable {
  static const int totalSteps = 6;

  final String firstName;
  final String lastName;
  final String email;
  final String password;

  final int step;
  final Gender? gender;
  final int age;
  final int weight;
  final int height;
  final Goal? goal;
  final ActivityLevel activityLevel;

  const RegisterFormData({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.password = '',
    this.step = 0,
    this.gender,
    this.age = 25,
    this.weight = 90,
    this.height = 167,
    this.goal,
    this.activityLevel = ActivityLevel.rookie,
  });
  bool get isLastStep => step == totalSteps - 1;
  bool get canProceed => switch (step) {
    0 => gender != null,
    4 => goal != null,
    _ => true,
  };

  RegisterFormData copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    int? step,
    Gender? gender,
    int? age,
    int? weight,
    int? height,
    Goal? goal,
    ActivityLevel? activityLevel,
  }) {
    return RegisterFormData(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      step: step ?? this.step,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      goal: goal ?? this.goal,
      activityLevel: activityLevel ?? this.activityLevel,
    );
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    password,
    step,
    gender,
    age,
    weight,
    height,
    goal,
    activityLevel,
  ];
}
