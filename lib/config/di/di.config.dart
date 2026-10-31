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
import '../../features/auth/domain/use_cases/reset_password_user_case.dart'
    as _i1012;
import '../../features/auth/domain/use_cases/verify_otp_user_case.dart'
    as _i397;
import '../../features/auth/presentation/forget_password/manager/forget_password_cubit.dart'
    as _i332;
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
    gh.lazySingleton<_i264.AppInterceptors>(
      () => _i264.AppInterceptors(
        gh<_i558.FlutterSecureStorage>(),
        gh<_i760.AppAuthCubit>(),
      ),
    );
    gh.lazySingleton<_i361.Dio>(
      () => dioModule.dioMethod(gh<_i264.AppInterceptors>()),
    );
    gh.lazySingleton<_i213.AuthApiClient>(
      () => _i213.AuthApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i192.AuthRemoteDataSourceImpl>(
      () => _i192.AuthRemoteDataSourceImpl(
        authApiClient: gh<_i213.AuthApiClient>(),
      ),
    );
    gh.factory<_i548.AuthRemoteDataSource>(
      () => _i981.AuthDataSourceSwitcher(
        authRemoteDataSourceImpl: gh<_i192.AuthRemoteDataSourceImpl>(),
        authFackDataSourceImpl: gh<_i508.AuthFakeRemoteDataSourceImpl>(),
      ),
    );
    gh.lazySingleton<_i170.AuthRepo>(
      () => _i279.AuthRepositoryImpl(gh<_i548.AuthRemoteDataSource>()),
    );
    gh.factory<_i839.ForgetPasswordUserCase>(
      () => _i839.ForgetPasswordUserCase(authRepo: gh<_i170.AuthRepo>()),
    );
    gh.factory<_i1012.ResetPasswordUserCase>(
      () => _i1012.ResetPasswordUserCase(gh<_i170.AuthRepo>()),
    );
    gh.factory<_i397.VerifyOtpUserCase>(
      () => _i397.VerifyOtpUserCase(gh<_i170.AuthRepo>()),
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
