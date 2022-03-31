import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:subsuke/models/subsc.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider instance = DBProvider._();

  Isar _isar;

  Future<Isar> get database async {
    if (_isar != null) return _isar;
    _isar = await _initDB();
    return _isar;
  }

  Future<Isar> _initDB() async {
    final dir = await getApplicationSupportDirectory();
    return await Isar.open(
      schemas: [SubscriptionItemSchema],
      directory: dir.path,
      // [TODO] Depends on environment var
      inspector: true,
    );
  }
}
