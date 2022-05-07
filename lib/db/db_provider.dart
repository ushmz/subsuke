import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:subsuke/models/notification.dart';
import 'package:subsuke/models/subsc.dart';

class DBProvider {
  final _filename = 'subscriptions.db';
  final _version = 1;

  final _subscriptionsTablename = 'subscriptions';
  final _subscriptionsIDColumnName = 'id';
  final _subscriptionsNameColumnName = 'name';
  final _subscriptionsPriceColumnName = 'price';
  final _subscriptionsNextColumnName = 'next';
  final _subscriptionsIntervalColumnName = 'interval';
  final _subscriptionsPaymentColumnName = 'payment_method';
  final _subscriptionsNoteColumnName = 'note';

  final _notificationsTableName = 'notifications';
  final _notificationsIDColumnName = 'id';
  final _notificationsTitleColumnName = 'title';
  final _notificationsBodyColumnName = 'body';
  final _notificationsReceivedAtColumnName = 'received_at';
  final _notificationsIsUnreadColumnName = 'unread';

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
    return join(dbDirPath, _filename);
  }

  _initDB() async {
    final path = await getDBPath();
    return await openDatabase(
      path,
      version: _version,
      onCreate: (db, version) async {
        var batch = db.batch();
        batch.execute('''
            CREATE TABLE $_subscriptionsTablename(
                $_subscriptionsIDColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
                $_subscriptionsNameColumnName TEXT NOT NULL,
                $_subscriptionsPriceColumnName INTEGER NOT NULL,
                $_subscriptionsNextColumnName TEXT NOT NULL,
                $_subscriptionsIntervalColumnName INTEGER NOT NULL,
                $_subscriptionsPaymentColumnName TEXT,
                $_subscriptionsNoteColumnName TEXT
          )
        ''');
        batch.execute('''
            CREATE TABLE $_notificationsTableName(
                $_notificationsIDColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
                $_notificationsTitleColumnName TEXT NOT NULL,
                $_notificationsBodyColumnName TEXT NOT NULL,
                $_notificationsReceivedAtColumnName TEXT NOT NULL,
                $_notificationsIsUnreadColumnName INTEGER NOT NULL
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
    final _ = await db?.execute("DROP TABLE $_subscriptionsTablename");
  }

  Future<void> deleteDatabaseFile() async {
    final path = await getDBPath();
    await deleteDatabase(path);
  }

  Future<void> createSubscriptionItem(SubscriptionItem item) async {
    final db = await database;
    final _ = await db?.insert(_subscriptionsTablename, item.toInsertMap());
    return;
  }

  Future<List<SubscriptionItem>> getAllSubscriptions() async {
    final db = await database;
    final res = await db?.query(_subscriptionsTablename);
    if (res == null) {
      return [];
    }
    List<SubscriptionItem> list = res.isNotEmpty
        ? res.map((e) => SubscriptionItem.fromMap(e)).toList()
        : [];
    return list;
  }

  Future<int> updateSubscriptionItem(SubscriptionItem item) async { final db = await database;
    final rowAffected = await db?.update(
      _subscriptionsTablename,
      item.toInsertMap(),
      where: "$_subscriptionsIDColumnName = ?",
      whereArgs: [item.id],
    );
    return rowAffected ?? 0;
  }

  Future<void> upsertSubscriptionItem(SubscriptionItem item) async {
    final ra = await updateSubscriptionItem(item);
    if (ra == 0) {
      await createSubscriptionItem(item);
    }
    return;
  }

  Future<void> deleteSubscriptionItem(int id) async {
    final db = await database;
    final _ = await db?.delete(
      _subscriptionsTablename,
      where: "$_subscriptionsIDColumnName = ?",
      whereArgs: [id],
    );
    return;
  }

  Future<void> insertNewNotification(Notification item) async {
    final db = await database;
    final _ = await db?.insert(_notificationsTableName, item.toInsertMap());
    return;
  }

  Future<List<Notification>> getAllNotifications() async {
    final db = await database;
    final res = await db?.query(_notificationsTableName);
    if (res == null) {
      return [];
    }
    List<Notification> list = res.isNotEmpty
        ? res.map((e) => Notification.fromMap(e)).toList()
        : [];
    return list;
  }
}
