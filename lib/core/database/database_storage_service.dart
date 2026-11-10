import 'dart:typed_data';

abstract class DatabaseStorageService {
  Future<String> getDatabasesPath();

  Future<bool> fileExists(String path);

  Future<bool> directoryExists(String path);

  Future<void> createDirectory(String path, {bool recursive = false});

  Future<void> writeBytes(String path, Uint8List bytes, {bool flush = false});

  Future<void> deleteFile(String path);

  Future<void> renameFile(String sourcePath, String targetPath);
}
