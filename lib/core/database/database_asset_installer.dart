import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseAssetInstaller {
  static const String _versionKey = 'local_db_manifest_version';
  static const String _manifestPath = 'assets/databases/manifest.json';

  final SharedPreferences _prefs;
  final AssetBundle _bundle;

  DatabaseAssetInstaller(this._prefs, {AssetBundle? bundle})
    : _bundle = bundle ?? rootBundle;

  Future<void> ensureDatabasesInstalled() async {
    final manifestStr = await _bundle.loadString(_manifestPath);
    final manifest = jsonDecode(manifestStr) as Map<String, dynamic>;

    final int manifestVersion = manifest['version'] is int
        ? manifest['version'] as int
        : int.parse(manifest['version'].toString());
    final files = manifest['files'] as Map<String, dynamic>;

    final dbDirPath = await getDatabasesPath();
    final savedVersion = _prefs.getInt(_versionKey);

    bool allFilesExist = true;
    for (final fileName in files.keys) {
      if (!await File(p.join(dbDirPath, fileName)).exists()) {
        allFilesExist = false;
        break;
      }
    }

    if (savedVersion == manifestVersion && allFilesExist) {
      if (kDebugMode) {
        debugPrint(
          '🔄 DatabaseAssetInstaller: Databases already up to date (version: $manifestVersion). Skipping install.',
        );
      }
      return;
    }

    await Directory(dbDirPath).create(recursive: true);

    for (final entry in files.entries) {
      final fileName = entry.key;
      final expectedHash = (entry.value as String).toLowerCase();

      final ByteData data = await _bundle.load('assets/databases/$fileName');
      final Uint8List bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      final actualHash = sha256.convert(bytes).toString().toLowerCase();
      if (actualHash != expectedHash) {
        throw StateError(
          '🚨 DatabaseAssetInstaller: SHA-256 mismatch for $fileName! Expected: $expectedHash, Actual: $actualHash',
        );
      }

      final targetPath = p.join(dbDirPath, fileName);
      final tmpFile = File('$targetPath.tmp');
      await tmpFile.writeAsBytes(bytes, flush: true);

      if (await File(targetPath).exists()) {
        await File(targetPath).delete();
      }

      await tmpFile.rename(targetPath);

      if (kDebugMode) {
        debugPrint(
          '✅ DatabaseAssetInstaller: Successfully verified and installed $fileName.',
        );
      }
    }

    await _prefs.setInt(_versionKey, manifestVersion);
  }
}
