import 'package:fitness_app/core/constants/storage_keys.dart';
import 'package:fitness_app/features/app/presentation/cubit/locale/app_locale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/fakes.dart';

void main() {
  late InMemorySecureStorage storage;
  late AppLocaleCubit cubit;

  setUp(() {
    storage = InMemorySecureStorage();
    cubit = AppLocaleCubit(storage);
  });

  tearDown(() => cubit.close());

  group('AppLocaleCubit', () {
    test('starts with English locale', () {
      expect(cubit.state, const Locale('en'));
    });

    test('load keeps English when no locale is stored', () async {
      await cubit.load();

      expect(cubit.state, const Locale('en'));
    });

    test('load restores a supported stored locale', () async {
      await storage.write(key: StorageKeys.kLocale, value: 'ar');

      await cubit.load();

      expect(cubit.state, const Locale('ar'));
    });

    test('load ignores an unsupported stored locale', () async {
      await storage.write(key: StorageKeys.kLocale, value: 'fr');

      await cubit.load();

      expect(cubit.state, const Locale('en'));
    });

    test('toggle switches to Arabic and persists it', () async {
      await cubit.toggle();

      expect(cubit.state, const Locale('ar'));
      expect(await storage.read(key: StorageKeys.kLocale), 'ar');
    });

    test('toggle switches back to English and persists it', () async {
      await storage.write(key: StorageKeys.kLocale, value: 'ar');
      await cubit.load();

      await cubit.toggle();

      expect(cubit.state, const Locale('en'));
      expect(await storage.read(key: StorageKeys.kLocale), 'en');
    });
  });
}
