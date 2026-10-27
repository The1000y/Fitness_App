import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/auth/api/client/auth_api_client.dart';
import 'package:fitness_app/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:fitness_app/features/auth/data/model/requests/login_request/login_request.dart';
import 'package:fitness_app/features/auth/data/model/responces/login_response/login_response.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:fitness_app/features/auth/domain/repo/auth_repo.dart';

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
