import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DBHelper {
  static Database? _db;
  static const _dbName = 'fitness_app.db';
  static const _dbVersion = 2;
  static const workoutTable = 'workouts';
  static const mealTable = 'meals';

  static Future<Database> _open() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    if (_db != null) return _db!;

    final path = join(await getDatabasesPath(), _dbName);
    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE $workoutTable(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            exercise TEXT,
            duration TEXT,
            reps TEXT,
            date TEXT
          );
        ''');
        await db.execute('''
          CREATE TABLE $mealTable(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            food TEXT,
            calories TEXT
          );
        ''');
      },
      onUpgrade: (db, oldV, newV) async {
        if (oldV < 2) {
          await db.execute('ALTER TABLE $workoutTable ADD COLUMN date TEXT;');
        }
      },
    );
    return _db!;
  }

  static Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await _open();
    return await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> all(String table) async {
    final db = await _open();
    return await db.query(table, orderBy: 'id DESC');
  }

  static Future<int> delete(String table, int id) async {
    final db = await _open();
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
