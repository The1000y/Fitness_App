// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dio/dio.dart' as _i361;
import 'package:flutter/services.dart' as _i281;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/app/presentation/cubit/auth/app_auth_cubit.dart'
    as _i760;
import '../../features/auth/api/auth_data_source_impl.dart/auth_data_source_switcher.dart'
    as _i981;
import '../../features/auth/api/auth_data_source_impl.dart/remote/auth_fake_remote_data_source_impl.dart'
    as _i508;
import '../../features/auth/api/auth_data_source_impl.dart/remote/auth_remote_data_source_impl.dart'
    as _i192;
import '../../features/auth/api/client/auth_api_client.dart' as _i213;
import '../../features/auth/data/data_source/remote/auth_remote_data_source.dart'
    as _i548;
import '../../features/auth/data/repo_impl/auth_repo_impl.dart' as _i279;
import '../../features/auth/domain/repo/auth_repo.dart' as _i170;
import '../../features/auth/domain/use_cases/forget_password_user_case.dart'
    as _i839;
import '../../features/auth/domain/use_cases/login_use_case.dart' as _i1038;
import '../../features/auth/domain/use_cases/register_use_case.dart' as _i1010;
import '../../features/auth/domain/use_cases/reset_password_user_case.dart'
    as _i1012;
import '../../features/auth/domain/use_cases/verify_otp_user_case.dart'
    as _i397;
import '../../features/auth/presentation/forget_password/manager/forget_password_cubit.dart'
    as _i332;
import '../../features/auth/presentation/login/manager/login_cubit.dart'
    as _i889;
import '../../features/exercise/api/client/exercise_api_client.dart' as _i248;
import '../../features/exercise/api/remote/exercise_remote_data_source_impl.dart'
    as _i669;
import '../../features/exercise/data/data_source/remote/exercise_remote_data_source.dart'
    as _i27;
import '../../features/exercise/data/repo_impl/exercise_repo_impl.dart'
    as _i824;
import '../../features/exercise/domain/repo/exercise_repo.dart' as _i628;
import '../../features/exercise/domain/use_cases/get_difficulty_levels_use_case.dart'
    as _i615;
import '../../features/exercise/domain/use_cases/get_exercises_use_case.dart'
    as _i685;
import '../../features/exercise/domain/use_cases/get_muscle_groups_use_case.dart'
    as _i593;
import '../../features/exercise/domain/use_cases/get_muscles_by_group_use_case.dart'
    as _i559;
import '../../features/exercise/presentation/exercise_details/manager/exercise_details_cubit.dart'
    as _i944;
import '../../features/exercise/presentation/workout_categories/manager/workout_categories_cubit.dart'
    as _i355;
import '../../features/auth/presentation/register/manager/register_cubit.dart'
    as _i784;
import '../../features/meals/api/client/meals_api_client.dart' as _i293;
import '../../features/meals/api/meals_remote_data_source_impl.dart/meals_remote_data_source_impl.dart'
    as _i396;
import '../../features/meals/data/data_source/remote/meals_remote_data_source.dart'
    as _i452;
import '../../features/meals/data/repo_impl/meals_repo_impl.dart' as _i459;
import '../../features/meals/domain/repo/meals_repo.dart' as _i749;
import '../../features/meals/domain/use_cases/get_meal_details_use_case.dart'
    as _i514;
import '../../features/meals/domain/use_cases/get_meals_by_category_use_case.dart'
    as _i385;
import '../../features/meals/domain/use_cases/get_meals_categories_use_case.dart'
    as _i1032;
import '../../features/meals/presentation/manager/meals_cubit.dart' as _i773;
import '../dio/app_interceptor.dart' as _i264;
import '../dio/dio_module.dart' as _i977;
import '../utils/secure_storage_module.dart' as _i327;
import 'app_module.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    final secureStorageModule = _$SecureStorageModule();
    final dioModule = _$DioModule();
    gh.factory<_i508.AuthFakeRemoteDataSourceImpl>(
      () => _i508.AuthFakeRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i281.AssetBundle>(() => appModule.assetBundle);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => secureStorageModule.secureStorage,
    );
    gh.lazySingleton<_i760.AppAuthCubit>(() => _i760.AppAuthCubit());
    gh.lazySingleton<_i361.Dio>(
      () => dioModule.mealDio(),
      instanceName: 'mealDio',
    );
    gh.factory<_i773.MealsCubit>(
      () => _i773.MealsCubit(
        gh<_i1032.GetMealsCategoriesUseCase>(),
        gh<_i385.GetMealsByCategoryUseCase>(),
        gh<_i514.GetMealDetailsUseCase>(),
      ),
    );
    gh.lazySingleton<_i264.AppInterceptors>(
      () => _i264.AppInterceptors(
        gh<_i558.FlutterSecureStorage>(),
        gh<_i760.AppAuthCubit>(),
      ),
    );
    gh.singleton<_i293.MealsApiClient>(
      () => _i293.MealsApiClient(gh<_i361.Dio>(instanceName: 'mealDio')),
    );
    gh.lazySingleton<_i361.Dio>(
      () => dioModule.fitnessDio(gh<_i264.AppInterceptors>()),
      instanceName: 'fitnessDio',
    );
    gh.singleton<_i213.AuthApiClient>(
      () => _i213.AuthApiClient(gh<_i361.Dio>(instanceName: 'fitnessDio')),
    );
    gh.factory<_i452.MealsRemoteDataSource>(
      () => _i396.MealsRemoteDataSourceImpl(
        apiClient: gh<_i293.MealsApiClient>(),
      ),
    );
    gh.factory<_i749.MealsRepo>(
      () => _i459.MealsRepoImpl(
        mealsRemoteDataSource: gh<_i452.MealsRemoteDataSource>(),
      ),
    );
    gh.singleton<_i248.ExerciseApiClient>(
      () => _i248.ExerciseApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i27.ExerciseRemoteDataSource>(
      () => _i669.ExerciseRemoteDataSourceImpl(gh<_i248.ExerciseApiClient>()),
    );
    gh.factory<_i548.RemoteDataSource>(
      () => _i192.RemoteDataSourceImpl(gh<_i213.AuthApiClient>()),
    );
    gh.factory<_i628.ExerciseRepo>(
      () => _i824.ExerciseRepoImpl(gh<_i27.ExerciseRemoteDataSource>()),
    );
    gh.factory<_i192.AuthRemoteDataSourceImpl>(
      () => _i192.AuthRemoteDataSourceImpl(
        authApiClient: gh<_i213.AuthApiClient>(),
      ),
    );
    gh.factory<_i385.GetMealsByCategoryUseCase>(
      () => _i385.GetMealsByCategoryUseCase(gh<_i749.MealsRepo>()),
    );
    gh.factory<_i1032.GetMealsCategoriesUseCase>(
      () => _i1032.GetMealsCategoriesUseCase(gh<_i749.MealsRepo>()),
    );
    gh.factory<_i514.GetMealDetailsUseCase>(
      () => _i514.GetMealDetailsUseCase(gh<_i749.MealsRepo>()),
    );
    gh.factory<_i548.AuthRemoteDataSource>(
      () => _i981.AuthDataSourceSwitcher(
        authRemoteDataSourceImpl: gh<_i192.AuthRemoteDataSourceImpl>(),
        authFackDataSourceImpl: gh<_i508.AuthFakeRemoteDataSourceImpl>(),
      ),
    );
    gh.factory<_i170.AuthRepo>(
      () => _i279.AuthRepoImpl(
        gh<_i548.RemoteDataSource>(),
        gh<_i548.AuthRemoteDataSource>(),
      ),
    );
    gh.factory<_i1038.LoginUseCase>(
      () => _i1038.LoginUseCase(gh<_i170.AuthRepo>()),
    );
    gh.factory<_i615.GetDifficultyLevelsUseCase>(
      () => _i615.GetDifficultyLevelsUseCase(gh<_i628.ExerciseRepo>()),
    );
    gh.factory<_i685.GetExercisesUseCase>(
      () => _i685.GetExercisesUseCase(gh<_i628.ExerciseRepo>()),
    );
    gh.factory<_i593.GetMuscleGroupsUseCase>(
      () => _i593.GetMuscleGroupsUseCase(gh<_i628.ExerciseRepo>()),
    );
    gh.factory<_i559.GetMusclesByGroupUseCase>(
      () => _i559.GetMusclesByGroupUseCase(gh<_i628.ExerciseRepo>()),
    );
    gh.factory<_i355.WorkoutCategoriesCubit>(
      () => _i355.WorkoutCategoriesCubit(
        gh<_i593.GetMuscleGroupsUseCase>(),
        gh<_i559.GetMusclesByGroupUseCase>(),
      ),
    );
    gh.factory<_i944.ExerciseDetailsCubit>(
      () => _i944.ExerciseDetailsCubit(
        gh<_i615.GetDifficultyLevelsUseCase>(),
        gh<_i685.GetExercisesUseCase>(),
      ),
    );
    gh.factory<_i839.ForgetPasswordUserCase>(
      () => _i839.ForgetPasswordUserCase(authRepo: gh<_i170.AuthRepo>()),
    );
    gh.factory<_i1010.RegisterUseCase>(
      () => _i1010.RegisterUseCase(repo: gh<_i170.AuthRepo>()),
    );
    gh.factory<_i1012.ResetPasswordUserCase>(
      () => _i1012.ResetPasswordUserCase(gh<_i170.AuthRepo>()),
    );
    gh.factory<_i397.VerifyOtpUserCase>(
      () => _i397.VerifyOtpUserCase(gh<_i170.AuthRepo>()),
    );
    gh.factory<_i889.LoginCubit>(
      () => _i889.LoginCubit(gh<_i1038.LoginUseCase>()),
    );
    gh.factory<_i784.RegisterCubit>(
      () => _i784.RegisterCubit(ucase: gh<_i1010.RegisterUseCase>()),
    );
    gh.factory<_i332.ForgetPasswordCubit>(
      () => _i332.ForgetPasswordCubit(
        gh<_i839.ForgetPasswordUserCase>(),
        gh<_i397.VerifyOtpUserCase>(),
        gh<_i1012.ResetPasswordUserCase>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}

class _$SecureStorageModule extends _i327.SecureStorageModule {}

class _$DioModule extends _i977.DioModule {}
