import 'package:subsuke/db/db_provider.dart';
import 'package:subsuke/models/subsucription.dart';

class SubscriptionRepository {
  static String tableName = 'subscriptions';
  static DBProvider instance = DBProvider.instance;

  static Future<Subscription> create(
      String name, String billingAt, int price, String cycle) async {
    final Map<String, dynamic> row = {
      "name": name,
      "billingAt": billingAt,
      "price": price,
      "cycle": cycle,
    };

    final db = await instance.database;
    final id = await db.insert(tableName, row);

    return Subscription(
      id: id,
      name: name,
      billingAt: billingAt,
      price: price,
      cycle: cycle,
    );
  }

  static Future<List<Subscription>> getAll() async {
    final db = await instance.database;
    final rows = await db.rawQuery("SELECT * FROM $tableName");

    if (rows.isEmpty) return [];

    return rows.map((r) => Subscription.fromMap(r)).toList();
  }

  static Future<Subscription> get(int id) async {
    final db = await instance.database;
    final rows =
        await db.rawQuery("SELECT * FROM $tableName WHERE id = ?", [id]);

    if (rows.isEmpty) return null;

    return Subscription.fromMap(rows.first);
  }

  static Future<int> update(int id,
      [String name, int price, String cycle]) async {
    final db = await instance.database;
    final row = {
      'id': id,
      'name': name,
      'price': price,
      'cycle': cycle,
    };

    return await db.update(tableName, row, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> delete(int id) async {
    final db = await instance.database;
    return db.delete(tableName, where: "id = ?", whereArgs: [id]);
  }
}
