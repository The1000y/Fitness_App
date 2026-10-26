import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/user_entity.dart';

class LoginEntity extends Equatable {
  final String message;
  final UserEntity user;
  final String token;

  LoginEntity({required this.message, required this.user, required this.token});

  @override
  List<Object?> get props => [message, user, token];
}
//https://fitness.elevateegy.com/api/v1/auth/signin
// request
// {
//     "email":"ehabragab@gmail.com",
//     "password":"Qwert@123"
// }
// response
// {
//     "message": "success",
//     "user": {
//         "_id": "6adc18e69d568ed58b0bc9a5",
//         "firstName": "ehab",
//         "lastName": "ragab",
//         "email": "ehabragab@gmail.com",
//         "gender": "male",
//         "age": 70,
//         "weight": 70,
//         "height": 170,
//         "activityLevel": "level1",
//         "goal": "Gain weight",
//         "photo": "https://fitness.elevateegy.com/uploads/default-profile.png",
//         "createdAt": "2026-10-24T02:33:10.497Z"
//     },
//     "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiNmFkYzE4ZTY5ZDU2OGVkNThiMGJjOWE1IiwiaWF0IjoxNzkyODA5MjM0fQ._Ub8_FCFRYMA1ujj_kUoRJeiQQWLxyo09mhbHI9zJeA"
// }
