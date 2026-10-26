import 'package:fitness_app/features/auth/data/model/requests/register_request/register_request.dart';
import 'package:fitness_app/features/auth/domain/entities/register_entity/register_request_entity.dart';

extension RegisterRequestEntityMapper on RegisterRequestEntity {
  RegisterRequestDto toDto() {
    return RegisterRequestDto(
      lastName: lastName ?? '',
      email: email ?? '',
      gender: gender ?? '',
      age: age ?? 0,
      weight: weight ?? 0,
      height: height ?? 0,
      activityLevel: activityLevel ?? '',
      goal: goal ?? '',
      password: password ?? '',
      firstName: firstName ?? '',
      rePassword: rePassword ?? '',
    );
  }
}
