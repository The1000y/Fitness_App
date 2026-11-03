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
import 'package:fitness_app/features/meals/api/client/meals_api_client.dart';
import 'package:fitness_app/features/meals/data/data_source/remote/meals_remote_data_source.dart';
import 'package:fitness_app/features/meals/data/model/details_meal_dto.dart';
import 'package:fitness_app/features/meals/data/model/details_meal_response.dart';
import 'package:fitness_app/features/meals/data/model/responses/meals_by_category_response/meals_by_category_response.dart';
import 'package:fitness_app/features/meals/data/model/responses/meals_categories_response/meals_categories_response.dart';
import 'package:fitness_app/features/meals/domain/entities/details_meal_entity.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_category_entity.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_entity.dart';
import 'package:fitness_app/features/meals/domain/repo/meals_repo.dart';
import 'meals_test_data.dart';
import 'test_data.dart';

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
}

class FakeMealsRepo implements MealsRepo {
  int callCount = 0;
  String? lastMealId;
  BaseResponse<List<DetailsMealEntity>>? nextResult;
  Completer<BaseResponse<List<DetailsMealEntity>>>? completer;

  int getCategoriesCallCount = 0;
  int getMealsCallCount = 0;
  String? lastCategory;

  BaseResponse<List<MealCategoryEntity>>? nextCategoriesResult;
  BaseResponse<List<MealEntity>>? nextMealsResult;

  Completer<BaseResponse<List<MealCategoryEntity>>>? categoriesCompleter;
  Completer<BaseResponse<List<MealEntity>>>? mealsCompleter;

  @override
  Future<BaseResponse<List<MealCategoryEntity>>> getMealsCategories() async {
    getCategoriesCallCount++;
    if (categoriesCompleter != null) {
      return categoriesCompleter!.future;
    }
    return nextCategoriesResult ?? Success(MealsTestData.categoryEntities);
  }

  @override
  Future<BaseResponse<List<MealEntity>>> getMealsByCategory(
    String category,
  ) async {
    getMealsCallCount++;
    lastCategory = category;
    if (mealsCompleter != null) {
      return mealsCompleter!.future;
    }
    return nextMealsResult ?? Success(MealsTestData.mealEntities);
  }

  @override
  Future<BaseResponse<List<DetailsMealEntity>>> getMealDetails(
    String mealId,
  ) async {
    callCount++;
    lastMealId = mealId;
    if (completer != null) {
      return completer!.future;
    }
    return nextResult ?? Success([TestData.detailsMealEntity]);
  }
}

class FakeMealsRemoteDataSource implements MealsRemoteDataSource {
  int callCount = 0;
  String? lastMealId;
  BaseResponse<List<DetailsMealDto>>? nextResult;
  Object? nextError;

  int getCategoriesCallCount = 0;
  int getMealsCallCount = 0;
  String? lastCategory;

  MealsCategoriesResponse? nextCategoriesResponse;
  MealsByCategoryResponse? nextMealsResponse;

  Object? nextCategoriesError;
  Object? nextMealsError;

  @override
  Future<MealsCategoriesResponse> getMealsCategories() async {
    getCategoriesCallCount++;
    if (nextCategoriesError != null) throw nextCategoriesError!;
    return nextCategoriesResponse ?? MealsTestData.categoriesResponse;
  }

  @override
  Future<MealsByCategoryResponse> getMealsByCategory(String category) async {
    getMealsCallCount++;
    lastCategory = category;
    if (nextMealsError != null) throw nextMealsError!;
    return nextMealsResponse ?? MealsTestData.mealsResponse;
  }

  @override
  Future<BaseResponse<List<DetailsMealDto>>> getMealDetails(
    String mealId,
  ) async {
    callCount++;
    lastMealId = mealId;
    if (nextError != null) throw nextError!;
    return nextResult ?? Success([TestData.detailsMealDto]);
  }
}

class FakeMealsApiClient implements MealsApiClient {
  int callCount = 0;
  String? lastMealId;
  DetailsMealResponse? nextResponse;
  Object? nextError;

  int getCategoriesCallCount = 0;
  int getMealsCallCount = 0;
  String? lastCategory;

  MealsCategoriesResponse? nextCategoriesResponse;
  MealsByCategoryResponse? nextMealsResponse;

  @override
  Future<MealsCategoriesResponse> getMealsCategories() async {
    getCategoriesCallCount++;
    if (nextError != null) throw nextError!;
    return nextCategoriesResponse ?? MealsTestData.categoriesResponse;
  }

  @override
  Future<MealsByCategoryResponse> getMealsByCategory(String category) async {
    getMealsCallCount++;
    lastCategory = category;
    if (nextError != null) throw nextError!;
    return nextMealsResponse ?? MealsTestData.mealsResponse;
  }

  @override
  Future<DetailsMealResponse> getMealDetails(String mealId) async {
    callCount++;
    lastMealId = mealId;
    if (nextError != null) throw nextError!;
    return nextResponse ?? TestData.detailsMealResponse;
  }
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
