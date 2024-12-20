import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'riding_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE horses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        breed TEXT,
        age INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE riding_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        horseId INTEGER,
        date TEXT,
        duration INTEGER,
        FOREIGN KEY (horseId) REFERENCES horses (id)
      )
    ''');
  }

  Future<int> insertHorse(Map<String, dynamic> horse) async {
    final db = await database;
    return await db.insert('horses', horse);
  }

  Future<List<Map<String, dynamic>>> getHorses() async {
    final db = await database;
    return await db.query('horses');
  }

  Future<int> updateHorse(Map<String, dynamic> horse) async {
    final db = await database;
    return await db.update(
      'horses',
      horse,
      where: 'id = ?',
      whereArgs: [horse['id']],
    );
  }

  Future<int> deleteHorse(int id) async {
    final db = await database;
    return await db.delete(
      'horses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Similar methods for riding_records
}
