import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/model/tasks.dart';

class DBHelper {
  static Database? _database;
  static const int db_version = 1;
  static const String _tableName = "taskTable";

  static Future<void> initDb() async {
    if (_database != null) {
      return;
    }
    try {
      String path = '${await getDatabasesPath()}taskTable.db';
      _database = await openDatabase(
        path,
        version: db_version,
        onCreate: (db, version) {
          print("creating new db $version");
          return db.execute("CREATE TABLE $_tableName("
              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "title STRING, note TEXT, date STRING, "
              "startDate STRING, endDate STRING,"
              "remind INTEGER, repeat STRING, color INTEGER, isCompleted INTEGER)");
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<int> inserttoDB(Task? task) async {
    return await _database?.insert(_tableName, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return await _database!.query(_tableName);
  }

  static delete(Task task) async {
    return await _database!
        .delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static Future<int> taskUpdate(int id) async {
    return await _database!.rawUpdate(
        '''UPDATE taskTable SET isCompleted=? where id=?''', [1, id]);
  }
}
