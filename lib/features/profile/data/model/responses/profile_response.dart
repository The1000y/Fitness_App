import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';

class ProfileResponse {
  final String? message;
  final ProfileEntity? user;

  const ProfileResponse({this.message, this.user});
}
