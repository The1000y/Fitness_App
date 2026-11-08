import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/auth/api/client/auth_api_client.dart';
import 'package:fitness_app/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:fitness_app/features/auth/data/model/requests/login_request/login_request.dart';
import 'package:fitness_app/features/auth/data/model/responses/login_response/login_response.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:fitness_app/features/auth/domain/repo/auth_repo.dart';
import 'package:fitness_app/features/exercise/api/client/exercise_api_client.dart';
import 'package:fitness_app/features/exercise/data/data_source/remote/exercise_remote_data_source.dart';
import 'package:fitness_app/features/exercise/data/model/responses/difficulty_levels_dto.dart';
import 'package:fitness_app/features/exercise/data/model/responses/exercises_list_dto.dart';
import 'package:fitness_app/features/exercise/data/model/responses/muscle_groups_response.dart';
import 'package:fitness_app/features/exercise/data/model/responses/muscles_by_group_response.dart';
import 'package:fitness_app/features/exercise/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercises_list_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_groups_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_by_group_entity.dart';
import 'package:fitness_app/features/exercise/domain/repo/exercise_repo.dart';

class FakeAuthRepo implements AuthRepo {
  int callCount = 0;
  String? lastEmail;
  String? lastPassword;
  BaseResponse<LoginEntity>? nextResult;
  Completer<BaseResponse<LoginEntity>>? completer;

  @override
  Future<BaseResponse<LoginEntity>> login({
    required String email,
    required String password,
  }) async {
    callCount++;
    lastEmail = email;
    lastPassword = password;
    if (completer != null) {
      return completer!.future;
    }
    return nextResult ??
        Success(
          LoginEntity(
            message: 'Success',
            user: UserEntity(),
            token: 'fake.jwt.token',
          ),
        );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeRemoteDataSource implements RemoteDataSource {
  int callCount = 0;
  LoginRequest? lastRequest;
  LoginResponse? nextResponse;
  Object? nextError;

  @override
  Future<LoginResponse> login(LoginRequest login) async {
    callCount++;
    lastRequest = login;
    if (nextError != null) throw nextError!;
    return nextResponse ??
        LoginResponse(message: 'Success', token: 'fake.jwt.token');
  }
}

class FakeAuthApiClient implements AuthApiClient {
  int callCount = 0;
  LoginRequest? lastRequest;
  LoginResponse? nextResponse;
  Object? nextError;

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    callCount++;
    lastRequest = request;
    if (nextError != null) throw nextError!;
    return nextResponse ??
        LoginResponse(message: 'Success', token: 'fake.jwt.token');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class InMemorySecureStorage implements FlutterSecureStorage {
  final Map<String, String> _store = {};

  @override
  Future<void> write({
    required String key,
    required String? value,
    Object? iOptions,
    Object? aOptions,
    Object? lOptions,
    Object? wOptions,
    Object? webOptions,
    Object? mOptions,
    Object? appleOptions,
  }) async {
    if (value != null) {
      _store[key] = value;
    } else {
      _store.remove(key);
    }
  }

  @override
  Future<String?> read({
    required String key,
    Object? iOptions,
    Object? aOptions,
    Object? lOptions,
    Object? wOptions,
    Object? webOptions,
    Object? mOptions,
    Object? appleOptions,
  }) async {
    return _store[key];
  }

  @override
  Future<void> delete({
    required String key,
    Object? iOptions,
    Object? aOptions,
    Object? lOptions,
    Object? wOptions,
    Object? webOptions,
    Object? mOptions,
    Object? appleOptions,
  }) async {
    _store.remove(key);
  }

  @override
  Future<bool> containsKey({
    required String key,
    Object? iOptions,
    Object? aOptions,
    Object? lOptions,
    Object? wOptions,
    Object? webOptions,
    Object? mOptions,
    Object? appleOptions,
  }) async {
    return _store.containsKey(key);
  }

  @override
  Future<void> deleteAll({
    Object? iOptions,
    Object? aOptions,
    Object? lOptions,
    Object? wOptions,
    Object? webOptions,
    Object? mOptions,
    Object? appleOptions,
  }) async {
    _store.clear();
  }

  @override
  Future<Map<String, String>> readAll({
    Object? iOptions,
    Object? aOptions,
    Object? lOptions,
    Object? wOptions,
    Object? webOptions,
    Object? mOptions,
    Object? appleOptions,
  }) async {
    return Map.from(_store);
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeExerciseApiClient implements ExerciseApiClient {
  int callCount = 0;
  String? lastPrimeMoverMuscleId;
  String? lastDifficultyLevelId;
  int? lastPage;
  int? lastLimit;
  ExercisesListDto? nextResponse;
  DifficultyLevelsDto? nextLevelsResponse;
  MuscleGroupsResponse? nextMuscleGroupsResponse;
  MusclesByGroupResponse? nextMusclesByGroupResponse;
  String? lastMuscleGroupId;
  Object? nextError;

  @override
  Future<ExercisesListDto> getExercisesByMuscleDifficulty(
    String primeMoverMuscleId,
    String difficultyLevelId,
    int page,
    int limit,
  ) async {
    callCount++;
    lastPrimeMoverMuscleId = primeMoverMuscleId;
    lastDifficultyLevelId = difficultyLevelId;
    lastPage = page;
    lastLimit = limit;
    if (nextError != null) throw nextError!;
    return nextResponse ?? ExercisesListDto();
  }

  @override
  Future<DifficultyLevelsDto> getDifficultyLevelsByPrimeMover(
    String primeMoverMuscleId,
  ) async {
    lastPrimeMoverMuscleId = primeMoverMuscleId;
    if (nextError != null) throw nextError!;
    return nextLevelsResponse ?? DifficultyLevelsDto();
  }

  @override
  Future<MuscleGroupsResponse> getMuscleGroups() async {
    callCount++;
    if (nextError != null) throw nextError!;
    return nextMuscleGroupsResponse ??
        MuscleGroupsResponse(musclesGroup: const []);
  }

  @override
  Future<MusclesByGroupResponse> getMusclesByGroup(String muscleGroupId) async {
    callCount++;
    lastMuscleGroupId = muscleGroupId;
    if (nextError != null) throw nextError!;
    return nextMusclesByGroupResponse ??
        MusclesByGroupResponse(totalMuscles: 0, muscles: const []);
  }
}

class FakeExerciseRemoteDataSource implements ExerciseRemoteDataSource {
  int callCount = 0;
  String? lastPrimeMoverMuscleId;
  String? lastDifficultyLevelId;
  int? lastPage;
  int? lastLimit;
  ExercisesListDto? nextResponse;
  DifficultyLevelsDto? nextLevelsResponse;
  MuscleGroupsResponse? nextMuscleGroupsResponse;
  MusclesByGroupResponse? nextMusclesByGroupResponse;
  String? lastMuscleGroupId;
  Object? nextError;

  @override
  Future<ExercisesListDto> getExercisesByMuscleDifficulty({
    required String primeMoverMuscleId,
    required String difficultyLevelId,
    required int page,
    required int limit,
  }) async {
    callCount++;
    lastPrimeMoverMuscleId = primeMoverMuscleId;
    lastDifficultyLevelId = difficultyLevelId;
    lastPage = page;
    lastLimit = limit;
    if (nextError != null) throw nextError!;
    return nextResponse ?? ExercisesListDto();
  }

  @override
  Future<DifficultyLevelsDto> getDifficultyLevelsByPrimeMover({
    required String primeMoverMuscleId,
  }) async {
    lastPrimeMoverMuscleId = primeMoverMuscleId;
    if (nextError != null) throw nextError!;
    return nextLevelsResponse ?? DifficultyLevelsDto();
  }

  @override
  Future<MuscleGroupsResponse> getMusclesGroups() async {
    if (nextError != null) throw nextError!;
    return nextMuscleGroupsResponse ??
        MuscleGroupsResponse(musclesGroup: const []);
  }

  @override
  Future<MusclesByGroupResponse> getMusclesByGroup(String id) async {
    lastMuscleGroupId = id;
    if (nextError != null) throw nextError!;
    return nextMusclesByGroupResponse ??
        MusclesByGroupResponse(totalMuscles: 0, muscles: const []);
  }
}

class FakeExerciseRepo implements ExerciseRepo {
  int callCount = 0;
  int levelsCallCount = 0;
  String? lastPrimeMoverMuscleId;
  String? lastDifficultyLevelId;
  int? lastPage;
  int? lastLimit;
  BaseResponse<ExercisesListEntity>? nextResult;
  BaseResponse<List<DifficultyLevelEntity>>? nextLevelsResult;
  BaseResponse<MuscleGroupsEntity>? nextMuscleGroupsResult;
  BaseResponse<MusclesByGroupEntity>? nextMusclesByGroupResult;
  String? lastMuscleGroupId;
  Completer<BaseResponse<ExercisesListEntity>>? completer;

  @override
  Future<BaseResponse<ExercisesListEntity>> getExercisesByMuscleDifficulty({
    required String primeMoverMuscleId,
    required String difficultyLevelId,
    required int page,
    required int limit,
  }) async {
    callCount++;
    lastPrimeMoverMuscleId = primeMoverMuscleId;
    lastDifficultyLevelId = difficultyLevelId;
    lastPage = page;
    lastLimit = limit;
    if (completer != null) {
      return completer!.future;
    }
    return nextResult ??
        const Success(
          ExercisesListEntity(
            message: '',
            totalExercises: 0,
            totalPages: 0,
            currentPage: 0,
            exercises: [],
          ),
        );
  }

  @override
  Future<BaseResponse<List<DifficultyLevelEntity>>> getDifficultyLevels({
    required String primeMoverMuscleId,
  }) async {
    levelsCallCount++;
    lastPrimeMoverMuscleId = primeMoverMuscleId;
    return nextLevelsResult ??
        const Success([
          DifficultyLevelEntity(
            id: 'difficulty_intermediate',
            name: 'Intermediate',
          ),
        ]);
  }

  @override
  Future<BaseResponse<MuscleGroupsEntity>> getMusclesGroups() async {
    return nextMuscleGroupsResult ??
        const Success(MuscleGroupsEntity(message: '', musclesGroup: []));
  }

  @override
  Future<BaseResponse<MusclesByGroupEntity>> getMusclesByGroup({
    required String id,
  }) async {
    lastMuscleGroupId = id;
    return nextMusclesByGroupResult ??
        const Success(
          MusclesByGroupEntity(message: '', totalMuscles: 0, muscles: []),
        );
  }
}

class FakeHttpClientAdapter implements HttpClientAdapter {
  int callCount = 0;
  RequestOptions? lastRequestOptions;
  int statusCode = 200;
  dynamic responseBody = {'message': 'Success', 'token': 'fake.jwt.token'};
  DioException? exceptionToThrow;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    callCount++;
    lastRequestOptions = options;
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    final bodyBytes = Uint8List.fromList(
      utf8.encode(
        options.responseType == ResponseType.bytes
            ? responseBody.toString()
            : responseBody is String
            ? responseBody
            : jsonEncode(responseBody),
      ),
    );
    return ResponseBox.fromBytes(
      bodyBytes,
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}

typedef ResponseBox = ResponseBody;
