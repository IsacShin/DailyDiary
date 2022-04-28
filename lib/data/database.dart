
import 'package:dailyapp/data/data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "dailyapp.db";
  static final int _databaseVersion = 1;
  static final feedTable = "feed";

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if(_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);
    return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute("""
    CREATE TABLE IF NOT EXISTS $feedTable (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date INTEGER DEFAULT 0,
    title String,
    comment String,
    image String,
    status INTEGER DEFAULT 0
    )
    """);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {

  }

  // 데이터 추가, 변경,  검색, 삭제
  Future<int> insertFeed(Feed feed) async {
    Database? db = await instance.database;

    if(feed.id == null) {
      //생성
      final _map = feed.toMap();

      return await db!.insert(feedTable, _map);
    }else {
      // 변경
      final _map = feed.toMap();
      return await db!.update(feedTable, _map, where: "id = ?", whereArgs: [feed.id]);
    }
  }

  Future<int> deleteFeed(Feed feed) async {
    Database? db = await instance.database;

    // 삭제
    final _map = feed.toMap();
    return await db!.delete(feedTable, where: "id = ?", whereArgs: [feed.id]);
  }

  Future<List<Feed>> queryFeedByDate(int date) async {
    Database? db = await instance.database;

    List<Feed> feeds = [];

    final query = await db!.query(feedTable, where: "date = ?", whereArgs: [date]);
    for(final q in query) {
      feeds.add(Feed.fromDB(q));
    }

    return feeds;
  }

  Future<List<Feed>> queryAllFeed() async {
    Database? db = await instance.database;

    List<Feed> feeds = [];

    final query = await db!.query(feedTable);
    for(final q in query) {
      feeds.add(Feed.fromDB(q));
    }

    return feeds;
  }
}