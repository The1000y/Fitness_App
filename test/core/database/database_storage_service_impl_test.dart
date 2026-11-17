import 'dart:io';
import 'dart:typed_data';

import 'package:fitness_app/core/database/database_storage_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory tempDir;
  late DatabaseStorageServiceImpl storageService;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('db_storage_test_');
    storageService = DatabaseStorageServiceImpl();
  });

  tearDown(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('DatabaseStorageServiceImpl (File and Directory operations)', () {
    test('creates directory recursively and checks directoryExists', () async {
      final targetDir = p.join(tempDir.path, 'sub', 'folder');
      expect(await storageService.directoryExists(targetDir), isFalse);

      await storageService.createDirectory(targetDir, recursive: true);

      expect(await storageService.directoryExists(targetDir), isTrue);
      expect(Directory(targetDir).existsSync(), isTrue);
    });

    test('writes bytes, checks fileExists, and verifies content', () async {
      final filePath = p.join(tempDir.path, 'test_file.bin');
      final bytes = Uint8List.fromList([10, 20, 30, 40]);

      expect(await storageService.fileExists(filePath), isFalse);

      await storageService.writeBytes(filePath, bytes, flush: true);

      expect(await storageService.fileExists(filePath), isTrue);
      final readBytes = await File(filePath).readAsBytes();
      expect(readBytes, equals(bytes));
    });

    test('renames file from source to target path', () async {
      final sourcePath = p.join(tempDir.path, 'source.bin');
      final targetPath = p.join(tempDir.path, 'renamed.bin');
      final bytes = Uint8List.fromList([1, 2, 3]);

      await File(sourcePath).writeAsBytes(bytes);
      expect(await storageService.fileExists(sourcePath), isTrue);
      expect(await storageService.fileExists(targetPath), isFalse);

      await storageService.renameFile(sourcePath, targetPath);

      expect(await storageService.fileExists(sourcePath), isFalse);
      expect(await storageService.fileExists(targetPath), isTrue);
      expect(await File(targetPath).readAsBytes(), equals(bytes));
    });

    test(
      'deletes file safely if it exists, does not throw if file does not exist',
      () async {
        final filePath = p.join(tempDir.path, 'to_delete.bin');
        await File(filePath).writeAsBytes([5, 6, 7]);
        expect(await storageService.fileExists(filePath), isTrue);

        await storageService.deleteFile(filePath);
        expect(await storageService.fileExists(filePath), isFalse);

        // Deleting again should not throw an exception
        await storageService.deleteFile(filePath);
        expect(await storageService.fileExists(filePath), isFalse);
      },
    );
  });
}
