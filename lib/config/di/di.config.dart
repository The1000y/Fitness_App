// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter/services.dart' as _i281;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../core/database/database_asset_installer.dart' as _i851;
import '../../core/database/database_storage_service.dart' as _i145;
import '../../core/database/database_storage_service_impl.dart' as _i8;
import '../../core/database/exercises_database.dart' as _i427;
import '../../core/database/meals_database.dart' as _i994;
import '../../features/app/presentation/cubit/auth/app_auth_cubit.dart'
    as _i760;
import '../../features/app/presentation/cubit/locale/app_locale_cubit.dart'
    as _i450;
import '../../features/auth/api/auth_data_source_impl.dart/remote/auth_remote_data_source_impl.dart'
    as _i192;
import '../../features/auth/api/client/auth_api_client.dart' as _i213;
import '../../features/auth/data/data_source/remote/auth_remote_data_source.dart'
    as _i548;
import '../../features/auth/data/repo_impl/auth_repo_impl.dart' as _i279;
import '../../features/auth/domain/repo/auth_repo.dart' as _i171;
import '../../features/auth/domain/use_cases/forget_password_user_case.dart'
    as _i839;
import '../../features/auth/domain/use_cases/login_use_case.dart' as _i1039;
import '../../features/auth/domain/use_cases/register_use_case.dart' as _i1010;
import '../../features/auth/domain/use_cases/reset_password_user_case.dart'
    as _i1012;
import '../../features/auth/domain/use_cases/verify_otp_user_case.dart'
    as _i397;
import '../../features/auth/presentation/forget_password/manager/forget_password_cubit.dart'
    as _i333;
import '../../features/auth/presentation/login/manager/login_cubit.dart'
    as _i889;
import '../../features/auth/presentation/register/manager/register_cubit.dart'
    as _i784;
<<<<<<< HEAD
import '../../features/chat/data/datasource/local/catalog_local_data_source.dart'
    as _i872;
import '../../features/chat/data/datasource/local/catalog_local_data_source_impl.dart'
    as _i157;
import '../../features/chat/data/repository/catalog_repository_impl.dart'
    as _i204;
import '../../features/chat/domain/repository/catalog_repository.dart' as _i139;
import '../../features/exercise/api/client/exercise_api_client.dart' as _i248;
import '../../features/exercise/api/remote/exercise_remote_data_source_impl.dart'
    as _i670;
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
=======
import '../../features/chat/api/chat_api_client.dart' as _i998;
import '../../features/chat/data/datasource/firestore/chat_firestore_data_source.dart'
    as _i1064;
import '../../features/chat/data/datasource/firestore/chat_firestore_data_source_impl.dart'
    as _i1038;
import '../../features/chat/data/datasource/remote/chat_remote_data_source.dart'
    as _i487;
import '../../features/chat/data/datasource/remote/chat_remote_data_source_impl.dart'
    as _i393;
import '../../features/chat/data/repository/chat_repository_impl.dart' as _i88;
import '../../features/chat/domain/repository/chat_repository.dart' as _i477;
>>>>>>> feature/chat-chatrepo
import '../../features/meals/api/client/meals_api_client.dart' as _i293;
import '../../features/meals/api/remote/meals_remote_data_source_impl.dart'
    as _i669;
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
import '../../features/profile/api/client/profile_api_client.dart' as _i418;
import '../../features/profile/api/data_source/remote/profile_remote_data_source_impl.dart'
    as _i924;
import '../../features/profile/data/data_source/remote/profile_remote_data_source.dart'
    as _i299;
import '../../features/profile/data/repo_impl/profile_repo_impl.dart' as _i481;
import '../../features/profile/domain/repo/profile_repo.dart' as _i364;
import '../../features/profile/domain/use_cases/profile_change_password_use_case.dart'
    as _i40;
import '../../features/profile/domain/use_cases/profile_get_use_case.dart'
    as _i424;
import '../../features/profile/domain/use_cases/profile_logout_use_case.dart'
    as _i170;
import '../../features/profile/domain/use_cases/profile_update_use_case.dart'
    as _i1027;
import '../../features/profile/presentation/change_password/manager/change_password_cubit.dart'
    as _i332;
import '../../features/profile/presentation/manager/profile_cubit.dart'
    as _i735;
import '../dio/app_interceptor.dart' as _i264;
import '../dio/dio_module.dart' as _i977;
import '../utils/secure_storage_module.dart' as _i327;
<<<<<<< HEAD
import 'app_module.dart' as _i461;
=======
import 'app_module.dart' as _i460;
import 'firebase_module.dart' as _i616;
>>>>>>> feature/chat-chatrepo

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    final firebaseModule = _$FirebaseModule();
    final secureStorageModule = _$SecureStorageModule();
    final dioModule = _$DioModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => appModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i281.AssetBundle>(() => appModule.assetBundle);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => firebaseModule.firestore);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => secureStorageModule.secureStorage,
    );
<<<<<<< HEAD
    gh.lazySingleton<_i760.AppAuthCubit>(() => _i760.AppAuthCubit());
    gh.lazySingleton<_i145.DatabaseStorageService>(
      () => _i8.DatabaseStorageServiceImpl(),
    );
    gh.lazySingleton<_i450.AppLocaleCubit>(
      () => _i450.AppLocaleCubit(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i427.ExercisesDatabase>(
      () => _i427.ExercisesDatabase(gh<_i145.DatabaseStorageService>()),
    );
    gh.lazySingleton<_i994.MealsDatabase>(
      () => _i994.MealsDatabase(gh<_i145.DatabaseStorageService>()),
=======
    gh.lazySingleton<_i760.AppAuthCubit>(
      () => _i760.AppAuthCubit(gh<_i558.FlutterSecureStorage>()),
>>>>>>> feature/chat-chatrepo
    );
    gh.lazySingleton<_i361.Dio>(
      () => dioModule.mealDio(),
      instanceName: 'mealDio',
    );
<<<<<<< HEAD
    gh.lazySingleton<_i872.CatalogLocalDataSource>(
      () => _i157.CatalogLocalDataSourceImpl(
        gh<_i427.ExercisesDatabase>(),
        gh<_i994.MealsDatabase>(),
      ),
    );
=======
    gh.lazySingleton<_i361.Dio>(
      () => dioModule.ollamaDio,
      instanceName: 'ollamaDio',
    );
    gh.singleton<_i998.ChatApiClient>(
      () => _i998.ChatApiClient(gh<_i361.Dio>(instanceName: 'ollamaDio')),
    );
    gh.factory<_i773.MealsCubit>(
      () => _i773.MealsCubit(
        gh<dynamic>(),
        gh<_i385.GetMealsByCategoryUseCase>(),
        gh<_i514.GetMealDetailsUseCase>(),
      ),
    );
    gh.factory<_i1064.ChatFirestoreDataSource>(
      () => _i1038.ChatFirestoreDataSourceImpl(gh<_i974.FirebaseFirestore>()),
    );
>>>>>>> feature/chat-chatrepo
    gh.lazySingleton<_i264.AppInterceptors>(
      () => _i264.AppInterceptors(
        gh<_i558.FlutterSecureStorage>(),
        gh<_i760.AppAuthCubit>(),
      ),
    );
    gh.factory<_i139.CatalogRepository>(
      () => _i204.CatalogRepositoryImpl(gh<_i872.CatalogLocalDataSource>()),
    );
    gh.factory<_i851.DatabaseAssetInstaller>(
      () => _i851.DatabaseAssetInstaller(
        gh<_i460.SharedPreferences>(),
        gh<_i281.AssetBundle>(),
        gh<_i145.DatabaseStorageService>(),
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
<<<<<<< HEAD
    gh.singleton<_i248.ExerciseApiClient>(
      () => _i248.ExerciseApiClient(gh<_i361.Dio>(instanceName: 'fitnessDio')),
    );
    gh.singleton<_i418.ProfileApiClient>(
      () => _i418.ProfileApiClient(gh<_i361.Dio>(instanceName: 'fitnessDio')),
    );
    gh.factory<_i299.ProfileRemoteDataSource>(
      () => _i924.ProfileRemoteDataSourceImpl(gh<_i418.ProfileApiClient>()),
    );
    gh.factory<_i364.ProfileRepo>(
      () => _i481.ProfileRepoImpl(
        gh<_i299.ProfileRemoteDataSource>(),
        gh<_i558.FlutterSecureStorage>(),
      ),
=======
    gh.factory<_i487.ChatRemoteDataSource>(
      () => _i393.ChatRemoteDataSourceImpl(gh<_i998.ChatApiClient>()),
>>>>>>> feature/chat-chatrepo
    );
    gh.factory<_i452.MealsRemoteDataSource>(
      () => _i669.MealsRemoteDataSourceImpl(
        apiClient: gh<_i293.MealsApiClient>(),
      ),
    );
    gh.factory<_i548.AuthRemoteDataSource>(
      () => _i192.AuthRemoteDataSourceImpl(
        authApiClient: gh<_i213.AuthApiClient>(),
      ),
    );
    gh.factory<_i27.ExerciseRemoteDataSource>(
      () => _i670.ExerciseRemoteDataSourceImpl(gh<_i248.ExerciseApiClient>()),
    );
    gh.factory<_i749.MealsRepo>(
      () => _i459.MealsRepoImpl(
        mealsRemoteDataSource: gh<_i452.MealsRemoteDataSource>(),
      ),
    );
    gh.factory<_i628.ExerciseRepo>(
      () => _i824.ExerciseRepoImpl(gh<_i27.ExerciseRemoteDataSource>()),
    );
    gh.factory<_i385.GetMealsByCategoryUseCase>(
      () => _i385.GetMealsByCategoryUseCase(gh<_i749.MealsRepo>()),
    );
    gh.factory<_i1032.GetMealsCategoriesUseCase>(
      () => _i1032.GetMealsCategoriesUseCase(gh<_i749.MealsRepo>()),
    );
<<<<<<< HEAD
    gh.factory<_i40.ProfileChangePasswordUseCase>(
      () => _i40.ProfileChangePasswordUseCase(gh<_i364.ProfileRepo>()),
    );
    gh.factory<_i424.ProfileGetUseCase>(
      () => _i424.ProfileGetUseCase(gh<_i364.ProfileRepo>()),
    );
    gh.factory<_i170.ProfileLogoutUseCase>(
      () => _i170.ProfileLogoutUseCase(gh<_i364.ProfileRepo>()),
    );
    gh.factory<_i1027.ProfileUpdateUseCase>(
      () => _i1027.ProfileUpdateUseCase(gh<_i364.ProfileRepo>()),
=======
    gh.factory<_i477.ChatRepository>(
      () => _i88.ChatRepositoryImpl(
        gh<_i1064.ChatFirestoreDataSource>(),
        gh<_i487.ChatRemoteDataSource>(),
      ),
>>>>>>> feature/chat-chatrepo
    );
    gh.factory<_i514.GetMealDetailsUseCase>(
      () => _i514.GetMealDetailsUseCase(gh<_i749.MealsRepo>()),
    );
<<<<<<< HEAD
    gh.factory<_i171.AuthRepo>(
      () => _i279.AuthRepoImpl(gh<_i548.AuthRemoteDataSource>()),
    );
    gh.lazySingleton<_i735.ProfileCubit>(
      () => _i735.ProfileCubit(
        gh<_i424.ProfileGetUseCase>(),
        gh<_i170.ProfileLogoutUseCase>(),
      ),
    );
    gh.factory<_i1012.ResetPasswordUserCase>(
      () => _i1012.ResetPasswordUserCase(gh<_i171.AuthRepo>()),
    );
    gh.factory<_i397.VerifyOtpUserCase>(
      () => _i397.VerifyOtpUserCase(gh<_i171.AuthRepo>()),
    );
    gh.factory<_i773.MealsCubit>(
      () => _i773.MealsCubit.create(
        gh<_i1032.GetMealsCategoriesUseCase>(),
        gh<_i385.GetMealsByCategoryUseCase>(),
        gh<_i514.GetMealDetailsUseCase>(),
      ),
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
=======
    gh.factory<_i548.AuthRemoteDataSource>(
      () => _i981.AuthDataSourceSwitcher(
        authRemoteDataSourceImpl: gh<_i192.AuthRemoteDataSourceImpl>(),
        authFackDataSourceImpl: gh<_i508.AuthFakeRemoteDataSourceImpl>(),
>>>>>>> feature/chat-chatrepo
      ),
    );
    gh.factory<_i332.ChangePasswordCubit>(
      () => _i332.ChangePasswordCubit(gh<_i40.ProfileChangePasswordUseCase>()),
    );
    gh.factory<_i944.ExerciseDetailsCubit>(
      () => _i944.ExerciseDetailsCubit(
        gh<_i615.GetDifficultyLevelsUseCase>(),
        gh<_i685.GetExercisesUseCase>(),
      ),
    );
<<<<<<< HEAD
    gh.factory<_i1038.LoginUseCase>(
      () => _i1038.LoginUseCase(gh<_i171.AuthRepo>()),
=======
    gh.factory<_i1039.LoginUseCase>(
      () => _i1039.LoginUseCase(gh<_i170.AuthRepo>()),
>>>>>>> feature/chat-chatrepo
    );
    gh.factory<_i839.ForgetPasswordUserCase>(
      () => _i839.ForgetPasswordUserCase(authRepo: gh<_i171.AuthRepo>()),
    );
    gh.factory<_i1010.RegisterUseCase>(
      () => _i1010.RegisterUseCase(repo: gh<_i171.AuthRepo>()),
    );
    gh.factory<_i333.ForgetPasswordCubit>(
      () => _i333.ForgetPasswordCubit(
        gh<_i839.ForgetPasswordUserCase>(),
        gh<_i397.VerifyOtpUserCase>(),
        gh<_i1012.ResetPasswordUserCase>(),
      ),
    );
    gh.factory<_i889.LoginCubit>(
      () =>
          _i889.LoginCubit(gh<_i1039.LoginUseCase>(), gh<_i760.AppAuthCubit>()),
    );
    gh.factory<_i784.RegisterCubit>(
      () => _i784.RegisterCubit(ucase: gh<_i1010.RegisterUseCase>()),
    );
    return this;
  }
}

class _$AppModule extends _i461.AppModule {}

class _$FirebaseModule extends _i616.FirebaseModule {}

class _$SecureStorageModule extends _i327.SecureStorageModule {}

class _$DioModule extends _i977.DioModule {}
