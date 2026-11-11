import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final int age;
  final double weight;
  final double height;
  final String activityLevel;
  final String goal;
  final String photo;

  const ProfileEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.age,
    required this.weight,
    required this.height,
    required this.activityLevel,
    required this.goal,
    required this.photo,
  });

  static const ProfileEntity empty = ProfileEntity(
    id: '',
    firstName: '',
    lastName: '',
    email: '',
    gender: '',
    age: 0,
    weight: 0,
    height: 0,
    activityLevel: '',
    goal: '',
    photo: '',
  );

  String get fullName => '$firstName $lastName'.trim();

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    gender,
    age,
    weight,
    height,
    activityLevel,
    goal,
    photo,
  ];
}
