import 'package:fitness_app/core/constants/storage_keys.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppLocaleCubit extends Cubit<Locale> {
  final FlutterSecureStorage _storage;

  AppLocaleCubit(this._storage) : super(const Locale('en'));

  Future<void> load() async {
    final code = await _storage.read(key: StorageKeys.kLocale);
    if (code == null) return;
    final locale = Locale(code);
    if (AppLocalizations.supportedLocales.contains(locale)) {
      emit(locale);
    }
  }

  Future<void> toggle() async {
    final code = state.languageCode == 'en' ? 'ar' : 'en';
    emit(Locale(code));
    await _storage.write(key: StorageKeys.kLocale, value: code);
  }
}
