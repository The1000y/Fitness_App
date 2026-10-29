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
import '../../features/exercise/api/client/exercise_api_client.dart' as _i248;
import '../../features/exercise/api/remote/exercise_remote_data_source_impl.dart'
    as _i669;
import '../../features/exercise/data/data_source/remote/exercise_remote_data_source.dart'
    as _i27;
import '../../features/exercise/data/repo_impl/exercise_repo_impl.dart'
    as _i824;
import '../../features/exercise/domain/repo/exercise_repo.dart' as _i628;
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
    gh.lazySingleton<_i281.AssetBundle>(() => appModule.assetBundle);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => secureStorageModule.secureStorage,
    );
    gh.lazySingleton<_i760.AppAuthCubit>(() => _i760.AppAuthCubit());
    gh.factory<_i27.ExerciseRemoteDataSource>(
      () => _i669.ExerciseRemoteDataSourceImpl(),
    );
    gh.factory<_i628.ExerciseRepo>(() => _i824.ExerciseRepoImpl());
    gh.lazySingleton<_i264.AppInterceptors>(
      () => _i264.AppInterceptors(
        gh<_i558.FlutterSecureStorage>(),
        gh<_i760.AppAuthCubit>(),
      ),
    );
    gh.lazySingleton<_i361.Dio>(
      () => dioModule.dioMethod(gh<_i264.AppInterceptors>()),
    );
    gh.singleton<_i248.ExerciseApiClient>(
      () => _i248.ExerciseApiClient(gh<_i361.Dio>()),
    );
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}

class _$SecureStorageModule extends _i327.SecureStorageModule {}

class _$DioModule extends _i977.DioModule {}
