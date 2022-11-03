import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:subsuke/models/notification.dart';
import 'package:subsuke/db/consts.dart';
import 'package:subsuke/models/payment_method.dart';
import 'package:subsuke/models/subscription_item.dart';

class DBProvider {
  static final DBProvider instance = DBProvider._();
  factory DBProvider() {
    return instance;
  }
  DBProvider._();

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
    return join(dbDirPath, DBConsts.filename);
  }

  _initDB() async {
    final path = await getDBPath();
    return await openDatabase(
      path,
      version: DBConsts.version,
      onCreate: (db, version) async {
        var batch = db.batch();
        batch.execute('''
            CREATE TABLE ${DBConsts.subscriptionsTablename}(
                ${DBConsts.subscriptionsIDColumnName} INTEGER PRIMARY KEY AUTOINCREMENT,
                ${DBConsts.subscriptionsNameColumnName} TEXT NOT NULL,
                ${DBConsts.subscriptionsPriceColumnName} INTEGER NOT NULL,
                ${DBConsts.subscriptionsPaymentColumnName} TEXT,
                ${DBConsts.subscriptionsIntervalColumnName} INTEGER NOT NULL,
                ${DBConsts.subscriptionsNextColumnName} TEXT NOT NULL,
                ${DBConsts.subscriptionsRemindBeforeColumnName} INTEGER,
                ${DBConsts.subscriptionsNoteColumnName} TEXT
            )
        ''');
        batch.execute('''
            CREATE TABLE ${DBConsts.notificationsTableName}(
                ${DBConsts.notificationsIDColumnName} INTEGER PRIMARY KEY AUTOINCREMENT,
                ${DBConsts.notificationsTitleColumnName} TEXT NOT NULL,
                ${DBConsts.notificationsBodyColumnName} TEXT NOT NULL,
                ${DBConsts.notificationsReceivedAtColumnName} TEXT NOT NULL,
                ${DBConsts.notificationsIsUnreadColumnName} INTEGER NOT NULL
            )
        ''');
        batch.execute('''
            CREATE TABLE ${DBConsts.paymentMethodTableName}(
                ${DBConsts.paymentMethodIDColumnName} INTEGER PRIMARY KEY AUTOINCREMENT,
                ${DBConsts.paymentMethodNameColumnName} TEXT NOT NULL
            );
        ''');
        await batch.commit();

        batch = db.batch();
        // Test data
        batch.insert(DBConsts.paymentMethodTableName,
            {DBConsts.paymentMethodNameColumnName: "Visa *1234"});
        batch.insert(DBConsts.paymentMethodTableName,
            {DBConsts.paymentMethodNameColumnName: "MasterCard *1234"});
        await batch.commit();
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        for (var i = oldVersion + 1; i <= newVersion; i++) {
          var queries = DBConsts.scripts[i.toString()];
          if (queries == null) {
            print("No query specified. Skip.");
            continue;
          }
          print("$oldVersion => $newVersion");
          for (String query in queries) {
            await db.execute(query);
          }
        }
      },
      onDowngrade: onDatabaseDowngradeDelete,
      singleInstance: true,
    );
  }

  Future<void> dropSubscriptionTable() async {
    final db = await database;
    await db?.execute("DROP TABLE ${DBConsts.subscriptionsTablename}");
  }

  Future<void> dropNotificationTable() async {
    final db = await database;
    await db?.execute("DROP TABLE ${DBConsts.notificationsTableName}");
  }

  Future<void> deleteDatabaseFile() async {
    final path = await getDBPath();
    await deleteDatabase(path);
  }

  Future<void> createSubscriptionItem(SubscriptionItem item) async {
    final db = await database;
    await db?.insert(DBConsts.subscriptionsTablename, item.toInsertMap());
  }

  Future<List<SubscriptionItem>> getAllSubscriptions() async {
    final db = await database;
    final res = await db?.query(DBConsts.subscriptionsTablename);
    // final res = await db ?.rawQuery(""" SELECT * FROM ${DBConsts.subscriptionsTablename} """);
    if (res == null) {
      return [];
    }
    List<SubscriptionItem> list = res.isNotEmpty
        ? res.map((e) => SubscriptionItem.fromSQLResultRow(e)).toList()
        : [];
    return list;
  }

  Future<int> updateSubscriptionItem(int id, SubscriptionItem item) async {
    final db = await database;
    final rowAffected = await db?.update(
      DBConsts.subscriptionsTablename,
      item.toInsertMap(),
      where: "${DBConsts.subscriptionsIDColumnName} = ?",
      whereArgs: [id],
    );
    return rowAffected ?? 0;
  }

  Future<void> upsertSubscriptionItem(int id, SubscriptionItem item) async {
    final ra = await updateSubscriptionItem(id, item);
    if (ra == 0) {
      await createSubscriptionItem(item);
    }
  }

  Future<void> deleteSubscriptionItem(int id) async {
    final db = await database;
    final _ = await db?.delete(
      DBConsts.subscriptionsTablename,
      where: "${DBConsts.subscriptionsIDColumnName} = ?",
      whereArgs: [id],
    );
  }

  Future<void> insertNewNotification(NotificationMessage item) async {
    final db = await database;
    final _ =
        await db?.insert(DBConsts.notificationsTableName, item.toInsertMap());
  }

  Future<List<NotificationMessage>> getAllNotifications() async {
    final db = await database;
    final res = await db?.query(DBConsts.notificationsTableName, limit: 10);
    if (res == null) {
      return [];
    }
    List<NotificationMessage> list = res.isNotEmpty
        ? res.map((e) => NotificationMessage.fromJson(e)).toList()
        : [];
    return list;
  }

  Future<void> readAllNotification() async {
    final db = await database;
    if (db == null) {
      return;
    }

    await db.execute('''
            UPDATE
                ${DBConsts.notificationsTableName}
            SET
                ${DBConsts.notificationsIsUnreadColumnName} = false
        ''');
  }

  Future<void> readNotifications(List<int> ids) async {
    final db = await database;
    final batch = db?.batch();
    if (batch == null) {
      return;
    }

    ids.forEach((id) {
      batch.execute('''
        UPDATE
            ${DBConsts.notificationsTableName}
        SET
            ${DBConsts.notificationsIsUnreadColumnName} = false
        WHERE
            id = $id
        ''');
    });
    await batch.commit();
  }

  Future<void> deleteNotification(int id) async {
    final db = await database;
    final _ = await db?.delete(
      DBConsts.notificationsTableName,
      where: "${DBConsts.notificationsIDColumnName} = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteAllNotification() async {
    final db = await database;
    final _ = await db?.delete(DBConsts.notificationsTableName);
  }

  Future<PaymentMethod?> getPaymentMethodByID(int id) async {
    final db = await database;
    final res = await db?.query(
      DBConsts.paymentMethodTableName,
      where: "${DBConsts.paymentMethodIDColumnName} = ?",
      whereArgs: [id],
    );

    if (res == null) {
      return null;
    }

    if (res.isEmpty) {
      return null;
    }

    return PaymentMethod.fromMap(res[0]);
  }

  Future<PaymentMethod?> getPaymentMethodByName(String name) async {
    final db = await database;
    final res = await db?.query(
      DBConsts.paymentMethodTableName,
      where: "${DBConsts.paymentMethodNameColumnName} = ?",
      whereArgs: [name],
    );

    if (res == null) {
      return null;
    }

    if (res.isEmpty) {
      return null;
    }

    return PaymentMethod.fromMap(res[0]);
  }

  Future<List<PaymentMethod>> getAllPaymentMethods() async {
    final db = await database;
    final res = await db?.query(DBConsts.paymentMethodTableName);
    if (res == null) {
      return [];
    }
    List<PaymentMethod> list =
        res.isNotEmpty ? res.map((e) => PaymentMethod.fromMap(e)).toList() : [];
    return list;
  }
}
