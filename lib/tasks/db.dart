import 'dart:async';
import 'package:try2/tasks/task.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  Database? _db;
  final int _version = 1;
  final String _tableName = 'tasks';

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initDb();
    }
    return _db;
  }

  Future<Database?> initDb() async {
    try {
      String _path = '${await getDatabasesPath()}tasks.db';
      _db = await openDatabase(_path, version: _version, onCreate: _onCreate);
    } catch (e) {
      print('initDb Method Error! = $e');
    }
    return _db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY,title TEXT,note TEXT,date TEXT,startTime TEXT,endTime TEXT,remind INTEGER,repeat TEXT,color INTEGER,isCompleted INTEGER);');
  }

  Future<int> insert(Task task) async {
    Database? mydb = await db;
    return await mydb!.insert(_tableName, task.toMap());
  }

  Future<int> delete(int id) async {
    Database? mydb = await db;
    return await mydb!.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(int id) async {
    Database? mydb = await db;
    return await mydb!.rawUpdate(
        'UPDATE $_tableName SET isCompleted = ? WHERE id = ?', [1, id]);
  }

  Future<List<Map<String, Object?>>> query() async {
    Database? mydb = await db;
    return await mydb!.query(_tableName);
  }

  deleteAll() {}
}
