import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

///@author longshaohua

class DbHelper {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await _initDb();
    return _db;
  }

  _initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "books.db");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Employee("
            "id INTEGER PRIMARY KEY,"
            "title TEXT,"
            "image TEXT,"
            "readProgress TEXT,"
            "bookUrl TEXT,"
            "bookId TEXT,"
            "index INTEGER)");
    print("Created tables");
  }


}
