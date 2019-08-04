import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

///@author longshaohua

class DbHelper {
  final String _tableName = "Bookshelf";

  Database _db = null;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await _initDb();
    return _db;
  }

  //初始化数据库
  _initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "books.db");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  // When creating the db, create the table
  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $_tableName("
        "id INTEGER PRIMARY KEY,"
        "title TEXT,"
        "image TEXT,"
        "readProgress TEXT,"
        "bookUrl TEXT,"
        "bookId TEXT,"
        "offset DOUBLE,"
        "isReversed INTEGER,"
        "chaptersIndex INTEGER)");
    print("Created tables");
  }

  /// 添加书籍到书架
  Future<int> addBookshelfItem(BookshelfBean item) async {
    print("addBookshelfItem = ${item.bookId}");
    var dbClient = await db;
    int res = await dbClient.insert("$_tableName", item.toMap());
    return res;
  }

  /// 根据 id 查询判断书籍是否存在书架
  Future<BookshelfBean> queryBooks(String bookId) async {
    var dbClient = await db;
    var result = await dbClient
        .query(_tableName, where: "bookId = ?", whereArgs: [bookId]);
    if (result != null && result.length > 0) {
     return BookshelfBean.fromMap(result[0]);
    }
    return null;
  }

  /// 书架根据 id 移除书籍
  Future<int> deleteBooks(String id) async {
    var dbClient = await db;
    int res =
        await dbClient.delete(_tableName, where: "bookId = ?", whereArgs: [id]);
    print("deleteItem = $res");
    return res;
  }

  /// 查询加入书架的所有书籍
  Future<List> getTotalList() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $_tableName");
    return result.toList();
  }

  /// 更新书籍进度
  Future<int> updateBooks(BookshelfBean user) async {
    var dbClient = await db;
    return await dbClient.update(_tableName, user.toMap(),
        where: "bookId = ?", whereArgs: [user.bookId]);
  }


  /// 关闭
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}

class BookshelfBean {
  BookshelfBean(this.title, this.image, this.readProgress, this.bookUrl,
      this.bookId, this.offset, this.isReversed, this.chaptersIndex);
  /// 书名
  String title;
  String image;
  String readProgress;
  String bookUrl;
  String bookId;
  double offset;

  /// 1是倒序
  int isReversed;
  int chaptersIndex;

  BookshelfBean.fromMap(Map<String, dynamic> map) {
    title = map["title"] as String;
    image = map["image"] as String;
    readProgress = map["readProgress"] as String;
    bookUrl = map["bookUrl"] as String;
    bookId = map["bookId"] as String;
    offset = map["offset"] as double;
    isReversed = map["isReversed"] as int;
    chaptersIndex = map["chaptersIndex"] as int;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "title": title,
      "image": image,
      "readProgress": readProgress,
      "bookUrl": bookUrl,
      "bookId": bookId,
      "offset": offset,
      "isReversed": isReversed,
      "chaptersIndex": chaptersIndex,
    };
    return map;
  }
}
