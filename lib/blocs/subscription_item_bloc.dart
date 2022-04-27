import 'package:rxdart/rxdart.dart';
import 'package:subsuke/db/db_provider.dart';
import 'package:subsuke/models/subsc.dart';

class SubscriptionItemBloc {
  final _itemController = BehaviorSubject<List<SubscriptionItem>>();
  Stream<List<SubscriptionItem>> get itemStream => _itemController.stream;

  Function(List<SubscriptionItem>) get setSubscriptionItems =>
      _itemController.sink.add;
  Stream<List<SubscriptionItem>> get onChangeSubscriptionItems =>
      _itemController.stream;

  getItems() async {
    final items = await DBProvider.instance?.getAllSubscriptions();
    _itemController.sink.add(items != null ? items : []);
  }

  SubscriptionItemBloc() {
    getItems();
  }

  create(SubscriptionItem item) {
    DBProvider.instance?.createSubscriptionItem(item);
    getItems();
  }

  update(SubscriptionItem item) {
    DBProvider.instance?.updateSubscriptionItem(item);
    getItems();
  }

  delete(int id) {
    DBProvider.instance?.deleteSubscriptionItem(id);
    getItems();
  }

  void dispose() {
    _itemController.close();
  }
}
