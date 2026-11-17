import 'package:equatable/equatable.dart';

class UpdateProfileParam extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? gender;
  final int? age;
  final double? weight;
  final double? height;
  final String? activityLevel;
  final String? goal;

  const UpdateProfileParam({
    this.firstName,
    this.lastName,
    this.gender,
    this.age,
    this.weight,
    this.height,
    this.activityLevel,
    this.goal,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    gender,
    age,
    weight,
    height,
    activityLevel,
    goal,
  ];
}