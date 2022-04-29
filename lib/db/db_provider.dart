import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:subsuke/models/subsc.dart';

class DBProvider {
  final _name = 'subscriptions.db';
  final _version = 1;
  final _tablename = 'subscriptions';

  DBProvider._();
  static final DBProvider? instance = DBProvider._();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDB();
    return _database;
  }

  Future<String> getDBPath() async {
    var dbDirPath = "";
    // See https://zenn.dev/beeeyan/articles/b9f1b42de9cb67
    if (Platform.isAndroid) {
      dbDirPath = await getDatabasesPath();
    } else if (Platform.isIOS) {
      final dbDirectory = await getLibraryDirectory();
      dbDirPath = dbDirectory.path;
    } else {
      throw Exception("Unknown platform");
    }
    return join(dbDirPath, _name);
  }

  _initDB() async {
    final path = await getDBPath();
    return await openDatabase(
      path,
      version: _version,
      onCreate: (db, version) async {
        var batch = db.batch();
        // [TODO] Add note
        batch.execute('''
            CREATE TABLE subscriptions(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                price INTEGER NOT NULL,
                next TEXT NOT NULL,
                interval INTEGER NOT NULL
          )
        ''');
        await batch.commit();
      },
      onDowngrade: onDatabaseDowngradeDelete,
      singleInstance: true,
    );
  }

  Future<void> dropTable() async {
    final db = await database;
    final _ = await db?.execute("DROP TABLE $_tablename");
    return;
  }

  Future<void> createSubscriptionItem(SubscriptionItem item) async {
    final db = await database;
    final _ = await db?.insert(_tablename, item.toInsertMap());
    return;
  }

  Future<List<SubscriptionItem>> getAllSubscriptions() async {
    final db = await database;
    final res = await db?.query(_tablename);
    if (res == null) {
      return [];
    }
    List<SubscriptionItem> list = res.isNotEmpty
        ? res.map((e) => SubscriptionItem.fromMap(e)).toList()
        : [];
    return list;
  }

  Future<void> updateSubscriptionItem(SubscriptionItem item) async {
    final db = await database;
    final _ = await db?.update(
      _tablename,
      item.toInsertMap(),
      where: "id = ?",
      whereArgs: [item.id],
    );
    return;
  }

  Future<void> deleteSubscriptionItem(int id) async {
    final db = await database;
    final _ = await db?.delete(
      _tablename,
      where: "id = ?",
      whereArgs: [id],
    );
    return;
  }
}
