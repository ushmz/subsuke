import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  final _name = 'subscriptions.db';
  final _version = 1;

  DBProvider._();
  static final DBProvider instance = DBProvider._();

  Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDB();
    return _database;
  }

  _initDB() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return await openDatabase(
      join(directory.path, _name),
      version: _version,
      onCreate: (db, version) async {
        var batch = db.batch();
        batch.execute('''
          CREATE TABLE subscriptions(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              billingAt TEXT NOT NULL,
              price INTEGER NOT NULL,
              cycle TEXT NOT NULL
          )
      ''');
        await batch.commit();
      },
      onDowngrade: onDatabaseDowngradeDelete,
    );
  }
}
