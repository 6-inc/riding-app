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
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
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

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE journal_entries (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          content TEXT,
          style TEXT,
          startTime TEXT,
          endTime TEXT,
          location TEXT,
          horse TEXT
        )
      ''');
    }
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

  Future<int> insertJournalEntry(Map<String, dynamic> entry) async {
    final db = await database;
    return await db.insert('journal_entries', entry);
  }

  Future<List<Map<String, dynamic>>> getJournalEntries() async {
    final db = await database;
    return await db.query('journal_entries');
  }

  Future<int> updateJournalEntry(Map<String, dynamic> entry) async {
    final db = await database;
    return await db.update(
      'journal_entries',
      entry,
      where: 'id = ?',
      whereArgs: [entry['id']],
    );
  }

  Future<int> deleteJournalEntry(int id) async {
    final db = await database;
    return await db.delete(
      'journal_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Similar methods for riding_records
}
