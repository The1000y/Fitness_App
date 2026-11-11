import 'dart:io';
import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'database_storage_service.dart';

@LazySingleton(as: DatabaseStorageService)
class DatabaseStorageServiceImpl implements DatabaseStorageService {
  @override
  Future<String> getDatabasesPath() => sqflite.getDatabasesPath();

  @override
  Future<bool> fileExists(String path) => File(path).exists();

  @override
  Future<bool> directoryExists(String path) => Directory(path).exists();

  @override
  Future<void> createDirectory(String path, {bool recursive = false}) async {
    await Directory(path).create(recursive: recursive);
  }

  @override
  Future<void> writeBytes(
    String path,
    Uint8List bytes, {
    bool flush = false,
  }) async {
    await File(path).writeAsBytes(bytes, flush: flush);
  }

  @override
  Future<void> deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Future<void> renameFile(String sourcePath, String targetPath) async {
    await File(sourcePath).rename(targetPath);
  }
}
