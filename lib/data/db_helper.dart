import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;
  static const _dbName = 'fitness_app.db';
  static const workoutTable = 'workouts';
  static const mealTable = 'meals';

  static Future<Database> _open() async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), _dbName);
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE $workoutTable(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            exercise TEXT,
            duration TEXT,
            reps TEXT
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
    );
    return _db!;
  }

  static Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await _open();
    return db.insert(table, data);
  }

  static Future<List<Map<String, dynamic>>> all(String table) async {
    final db = await _open();
    return db.query(table, orderBy: 'id DESC');
  }

  static Future<int> delete(String table, int id) async {
    final db = await _open();
    return db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
