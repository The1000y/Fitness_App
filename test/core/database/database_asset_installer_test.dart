import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:fitness_app/core/database/database_asset_installer.dart';
import 'package:fitness_app/core/database/database_storage_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockAssetBundle extends Mock implements AssetBundle {}

class MockDatabaseStorageService extends Mock
    implements DatabaseStorageService {}

void main() {
  late MockSharedPreferences mockPrefs;
  late MockAssetBundle mockBundle;
  late MockDatabaseStorageService mockStorage;
  late DatabaseAssetInstaller installer;

  const manifestPath = 'assets/databases/manifest.json';
  const dbDirPath = '/mock/databases';

  final db1Bytes = Uint8List.fromList([1, 2, 3, 4]);
  final db2Bytes = Uint8List.fromList([5, 6, 7, 8]);
  final db1Hash = sha256.convert(db1Bytes).toString().toLowerCase();
  final db2Hash = sha256.convert(db2Bytes).toString().toLowerCase();

  final validManifestJson = jsonEncode({
    'version': 1,
    'files': {'db1.db': db1Hash, 'db2.db': db2Hash},
  });

  ByteData createByteData(Uint8List bytes) {
    return ByteData.sublistView(bytes);
  }

  setUpAll(() {
    registerFallbackValue(Uint8List(0));
  });

  setUp(() {
    mockPrefs = MockSharedPreferences();
    mockBundle = MockAssetBundle();
    mockStorage = MockDatabaseStorageService();

    installer = DatabaseAssetInstaller(mockPrefs, mockBundle, mockStorage);

    when(
      () => mockStorage.getDatabasesPath(),
    ).thenAnswer((_) async => dbDirPath);
    when(() => mockStorage.fileExists(any())).thenAnswer((_) async => false);
    when(
      () => mockBundle.loadString(manifestPath),
    ).thenAnswer((_) async => validManifestJson);
  });

  group('DatabaseAssetInstaller', () {
    test(
      'skips installation when saved version matches and all files exist',
      () async {
        when(() => mockPrefs.getInt('local_db_manifest_version')).thenReturn(1);
        when(
          () => mockStorage.fileExists(p.join(dbDirPath, 'db1.db')),
        ).thenAnswer((_) async => true);
        when(
          () => mockStorage.fileExists(p.join(dbDirPath, 'db2.db')),
        ).thenAnswer((_) async => true);

        await installer.ensureDatabasesInstalled();

        verify(() => mockBundle.loadString(manifestPath)).called(1);
        verify(() => mockStorage.getDatabasesPath()).called(1);
        verify(
          () => mockStorage.fileExists(p.join(dbDirPath, 'db1.db')),
        ).called(1);
        verify(
          () => mockStorage.fileExists(p.join(dbDirPath, 'db2.db')),
        ).called(1);

        verifyNever(
          () => mockStorage.createDirectory(
            any(),
            recursive: any(named: 'recursive'),
          ),
        );
        verifyNever(() => mockBundle.load(any()));
        verifyNever(
          () =>
              mockStorage.writeBytes(any(), any(), flush: any(named: 'flush')),
        );
        verifyNever(() => mockStorage.renameFile(any(), any()));
        verifyNever(() => mockPrefs.setInt(any(), any()));
      },
    );

    test(
      'installs databases successfully on fresh install (saved version is null)',
      () async {
        when(
          () => mockPrefs.getInt('local_db_manifest_version'),
        ).thenReturn(null);
        when(
          () => mockStorage.createDirectory(dbDirPath, recursive: true),
        ).thenAnswer((_) async {});

        when(
          () => mockBundle.load('assets/databases/db1.db'),
        ).thenAnswer((_) async => createByteData(db1Bytes));
        when(
          () => mockBundle.load('assets/databases/db2.db'),
        ).thenAnswer((_) async => createByteData(db2Bytes));

        when(
          () => mockStorage.writeBytes(any(), any(), flush: true),
        ).thenAnswer((_) async {});
        when(() => mockStorage.deleteFile(any())).thenAnswer((_) async {});
        when(
          () => mockStorage.renameFile(any(), any()),
        ).thenAnswer((_) async {});
        when(
          () => mockPrefs.setInt('local_db_manifest_version', 1),
        ).thenAnswer((_) async => true);

        await installer.ensureDatabasesInstalled();

        verify(
          () => mockStorage.createDirectory(dbDirPath, recursive: true),
        ).called(1);

        verify(() => mockBundle.load('assets/databases/db1.db')).called(1);
        verify(
          () => mockStorage.writeBytes(
            p.join(dbDirPath, 'db1.db.tmp'),
            db1Bytes,
            flush: true,
          ),
        ).called(1);
        verify(
          () => mockStorage.renameFile(
            p.join(dbDirPath, 'db1.db.tmp'),
            p.join(dbDirPath, 'db1.db'),
          ),
        ).called(1);

        verify(() => mockBundle.load('assets/databases/db2.db')).called(1);
        verify(
          () => mockStorage.writeBytes(
            p.join(dbDirPath, 'db2.db.tmp'),
            db2Bytes,
            flush: true,
          ),
        ).called(1);
        verify(
          () => mockStorage.renameFile(
            p.join(dbDirPath, 'db2.db.tmp'),
            p.join(dbDirPath, 'db2.db'),
          ),
        ).called(1);

        verifyNever(() => mockStorage.deleteFile(any()));
        verify(
          () => mockPrefs.setInt('local_db_manifest_version', 1),
        ).called(1);
      },
    );

    test(
      'deletes existing target file before renaming if target file already exists',
      () async {
        when(
          () => mockPrefs.getInt('local_db_manifest_version'),
        ).thenReturn(null);
        when(() => mockStorage.fileExists(any())).thenAnswer((_) async => true);
        when(
          () => mockStorage.createDirectory(dbDirPath, recursive: true),
        ).thenAnswer((_) async {});

        when(
          () => mockBundle.load('assets/databases/db1.db'),
        ).thenAnswer((_) async => createByteData(db1Bytes));
        when(
          () => mockBundle.load('assets/databases/db2.db'),
        ).thenAnswer((_) async => createByteData(db2Bytes));

        when(
          () => mockStorage.writeBytes(any(), any(), flush: true),
        ).thenAnswer((_) async {});
        when(() => mockStorage.deleteFile(any())).thenAnswer((_) async {});
        when(
          () => mockStorage.renameFile(any(), any()),
        ).thenAnswer((_) async {});
        when(
          () => mockPrefs.setInt('local_db_manifest_version', 1),
        ).thenAnswer((_) async => true);

        await installer.ensureDatabasesInstalled();

        verify(
          () => mockStorage.deleteFile(p.join(dbDirPath, 'db1.db')),
        ).called(1);
        verify(
          () => mockStorage.deleteFile(p.join(dbDirPath, 'db2.db')),
        ).called(1);
      },
    );

    test(
      'installs databases when version matches but one file is missing on disk',
      () async {
        when(() => mockPrefs.getInt('local_db_manifest_version')).thenReturn(1);
        when(
          () => mockStorage.fileExists(p.join(dbDirPath, 'db1.db')),
        ).thenAnswer((_) async => true);
        // db2.db is missing:
        when(
          () => mockStorage.fileExists(p.join(dbDirPath, 'db2.db')),
        ).thenAnswer((_) async => false);
        when(
          () => mockStorage.createDirectory(dbDirPath, recursive: true),
        ).thenAnswer((_) async {});

        when(
          () => mockBundle.load('assets/databases/db1.db'),
        ).thenAnswer((_) async => createByteData(db1Bytes));
        when(
          () => mockBundle.load('assets/databases/db2.db'),
        ).thenAnswer((_) async => createByteData(db2Bytes));

        when(
          () => mockStorage.writeBytes(any(), any(), flush: true),
        ).thenAnswer((_) async {});
        when(() => mockStorage.deleteFile(any())).thenAnswer((_) async {});
        when(
          () => mockStorage.renameFile(any(), any()),
        ).thenAnswer((_) async {});
        when(
          () => mockPrefs.setInt('local_db_manifest_version', 1),
        ).thenAnswer((_) async => true);

        await installer.ensureDatabasesInstalled();

        verify(
          () => mockStorage.createDirectory(dbDirPath, recursive: true),
        ).called(1);
        verify(
          () => mockPrefs.setInt('local_db_manifest_version', 1),
        ).called(1);
      },
    );

    test('parses string version correctly from manifest', () async {
      final stringVersionManifest = jsonEncode({
        'version': '2',
        'files': {'db1.db': db1Hash},
      });

      when(
        () => mockBundle.loadString(manifestPath),
      ).thenAnswer((_) async => stringVersionManifest);
      when(
        () => mockPrefs.getInt('local_db_manifest_version'),
      ).thenReturn(1); // older version
      when(
        () => mockStorage.fileExists(p.join(dbDirPath, 'db1.db')),
      ).thenAnswer((_) async => true);
      when(
        () => mockStorage.createDirectory(dbDirPath, recursive: true),
      ).thenAnswer((_) async {});
      when(
        () => mockBundle.load('assets/databases/db1.db'),
      ).thenAnswer((_) async => createByteData(db1Bytes));
      when(
        () => mockStorage.writeBytes(any(), any(), flush: true),
      ).thenAnswer((_) async {});
      when(() => mockStorage.deleteFile(any())).thenAnswer((_) async {});
      when(() => mockStorage.renameFile(any(), any())).thenAnswer((_) async {});
      when(
        () => mockPrefs.setInt('local_db_manifest_version', 2),
      ).thenAnswer((_) async => true);

      await installer.ensureDatabasesInstalled();

      verify(() => mockPrefs.setInt('local_db_manifest_version', 2)).called(1);
    });

    test(
      'throws StateError and aborts when SHA-256 hash does not match',
      () async {
        final corruptedBytes = Uint8List.fromList([99, 99, 99]);

        when(
          () => mockPrefs.getInt('local_db_manifest_version'),
        ).thenReturn(null);
        when(
          () => mockStorage.createDirectory(dbDirPath, recursive: true),
        ).thenAnswer((_) async {});
        when(
          () => mockBundle.load('assets/databases/db1.db'),
        ).thenAnswer((_) async => createByteData(corruptedBytes));

        expect(
          () => installer.ensureDatabasesInstalled(),
          throwsA(
            isA<StateError>().having(
              (e) => e.message,
              'message',
              contains('SHA-256 mismatch for db1.db'),
            ),
          ),
        );

        verifyNever(
          () =>
              mockStorage.writeBytes(any(), any(), flush: any(named: 'flush')),
        );
        verifyNever(() => mockStorage.renameFile(any(), any()));
        verifyNever(() => mockPrefs.setInt(any(), any()));
      },
    );
  });
}
