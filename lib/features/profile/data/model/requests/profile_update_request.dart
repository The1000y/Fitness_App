
import 'package:json_annotation/json_annotation.dart';


part 'profile_update_request.g.dart';

@JsonSerializable(includeIfNull: false)
class ProfileUpdateRequest {
  @JsonKey(name: 'firstName')
  final String? firstName;

  @JsonKey(name: 'lastName')
  final String? lastName;

  @JsonKey(name: 'gender')
  final String? gender;

  @JsonKey(name: 'age')
  final int? age;

  @JsonKey(name: 'weight')
  final double? weight;

  @JsonKey(name: 'height')
  final double? height;

  @JsonKey(name: 'activityLevel')
  final String? activityLevel;

  @JsonKey(name: 'goal')
  final String? goal;

  const ProfileUpdateRequest({
    this.firstName,
    this.lastName,
    this.gender,
    this.age,
    this.weight,
    this.height,
    this.activityLevel,
    this.goal,
  });

  factory ProfileUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$ProfileUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileUpdateRequestToJson(this);
}

// "message": "success",
//   "user": {
//     "_id": "6adc18e69d568ed58b0bc9a5",
//     "firstName": "ehab",
//     "lastName": "Tech2",
//     "email": "ehabragab@gmail.com",
//     "gender": "male",
//     "age": 70,
//     "weight": 70,
//     "height": 170,
//     "activityLevel": "level1",
//     "goal": "Gain weight",
//     "photo": "https://fitness.elevateegy.com/uploads/default-profile.png",
//     "createdAt": "2026-10-24T02:33:10.497Z"
//   }
// }
