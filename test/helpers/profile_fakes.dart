import 'package:fitness_app/features/app/presentation/cubit/locale/app_locale_cubit.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_app/features/profile/domain/use_cases/profile_get_use_case.dart';
import 'package:fitness_app/features/profile/domain/use_cases/profile_logout_use_case.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_cubit.dart';
import 'package:mocktail/mocktail.dart';

const ProfileEntity testProfile = ProfileEntity(
  id: 'user-1',
  firstName: 'Ada',
  lastName: 'Lovelace',
  email: 'ada@example.com',
  gender: 'female',
  age: 30,
  weight: 60.5,
  height: 170,
  activityLevel: 'active',
  goal: 'fitness',
  photo: '',
);

const Map<String, dynamic> testProfileJson = {
  'message': 'Profile fetched successfully',
  'user': {
    '_id': 'user-1',
    'firstName': 'Ada',
    'lastName': 'Lovelace',
    'email': 'ada@example.com',
    'gender': 'female',
    'age': 30,
    'weight': 60.5,
    'height': 170,
    'activityLevel': 'active',
    'goal': 'fitness',
    'photo': '',
  },
};

class MockProfileGetUseCase extends Mock implements ProfileGetUseCase {}

class MockProfileLogoutUseCase extends Mock implements ProfileLogoutUseCase {}

class MockProfileCubit extends Mock implements ProfileCubit {}

class MockAppLocaleCubit extends Mock implements AppLocaleCubit {}
