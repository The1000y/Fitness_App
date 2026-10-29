import 'package:fitness_app/features/auth/data/model/requests/register_request/register_request.dart';
import 'package:fitness_app/features/auth/domain/entities/params/register_params_entity.dart';

extension RegisterParamsMapper on RegisterParams {
  RegisterRequestDto toDto() {
    return RegisterRequestDto(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      rePassword: rePassword,
      gender: gender,
      height: height,
      weight: weight,
      age: age,
      goal: goal,
      activityLevel: activityLevel,
    );
  }
}
