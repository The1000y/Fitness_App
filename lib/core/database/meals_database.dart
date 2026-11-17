import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'database_storage_service.dart';

@lazySingleton
class MealsDatabase {
  final DatabaseStorageService _storageService;

  Database? _db;
  Future<Database>? _databaseFuture;

  MealsDatabase(this._storageService);

  Future<Database> get database {
    if (_db?.isOpen == true) return Future.value(_db!);
    if (_db != null) {
      _db = null;
      _databaseFuture = null;
    }
    return _databaseFuture ??= _openDatabase();
  }

  Future<Database> _openDatabase() async {
    try {
      final dir = await _storageService.getDatabasesPath();
      final dbPath = p.join(dir, 'meals.db');
      if (kDebugMode) {
        debugPrint('MealsDatabase: Opening database at $dbPath');
      }
      final db = await openDatabase(dbPath, readOnly: true);
      _db = db;
      return db;
    } catch (_) {
      _databaseFuture = null;
      rethrow;
    }
  }
}
