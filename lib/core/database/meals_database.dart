import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'database_storage_service.dart';

@lazySingleton
class MealsDatabase {
  final DatabaseStorageService _storageService;
  Database? _db;

  MealsDatabase(this._storageService);

  Future<Database> get database async {
    if (_db != null && _db!.isOpen) return _db!;
    return _db = await _openDatabase();
  }

  Future<Database> _openDatabase() async {
    final dir = await _storageService.getDatabasesPath();
    final dbPath = p.join(dir, 'meals.db');
    if (kDebugMode) {
      debugPrint('MealsDatabase: Opening database at $dbPath');
    }
    return openDatabase(dbPath, readOnly: true);
  }
}
