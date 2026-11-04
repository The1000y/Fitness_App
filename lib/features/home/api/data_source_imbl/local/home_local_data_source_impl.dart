import 'dart:convert';

import 'package:fitness_app/core/constants/storage_keys.dart';
import 'package:fitness_app/features/auth/data/model/responses/login_response/user_response.dart';
import 'package:fitness_app/features/home/data/data_source/local/home_local_data_source.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: HomeLocalDataSource)
class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final FlutterSecureStorage _storage;

  HomeLocalDataSourceImpl(this._storage);

  @override
  Future<UserResponse?> getCachedUser() async {
    final raw = await _storage.read(key: StorageKeys.kUserData);
    if (raw == null || raw.isEmpty) return null;
    return UserResponse.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}