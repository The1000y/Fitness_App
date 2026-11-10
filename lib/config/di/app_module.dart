import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class AppModule {
  @lazySingleton
  AssetBundle get assetBundle => rootBundle;

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
