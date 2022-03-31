import 'package:subsuke/db/db.dart';
import 'package:subsuke/models/subsc.dart';

class SubscRepository {
  static DBProvider _instance = DBProvider.instance;

  static Future<SubscriptionItem> get(int id) async {
    final db = await _instance.database;
    final item = await db.subscriptionItems.get(id);
    return item;
  }

  static Future<List<SubscriptionItem>> getAll() async {
    final db = await _instance.database;
    final items = db.subscriptionItems.filter().findAll();
    return items;
  }

  static Future<int> create(SubscriptionItem item) async {
    final db = await _instance.database;
    final insertedID = await db.writeTxn<int>((isar) async {
      return await isar.subscriptionItems.put(item);
    });
    return insertedID;
  }

  static Future<void> update(SubscriptionItem item) async {
    final db = await _instance.database;
    await db.subscriptionItems.put(item);
  }

  static Future<void> delete(int id) async {
    final db = await _instance.database;
    await db.subscriptionItems.delete(id);
  }
}
