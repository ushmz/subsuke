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
    final items = await DBProvider.instance.getAllSubscriptions();
    _itemController.sink.add(items);
  }

  create(SubscriptionItem item) {
    DBProvider.instance.createSubscriptionItem(item);
    getItems();
  }

  update(SubscriptionItem item) {
    DBProvider.instance.updateSubscriptionItem(item);
    getItems();
  }

  delete(int id) {
    DBProvider.instance.deleteSubscriptionItem(id);
    getItems();
  }

  final _selectedIntervals = BehaviorSubject<List<int>>.seeded(<int>[]);
  Stream<List<int>> get selectedIntervalsStream => _selectedIntervals.stream;
  Function(List<int>) get setSelectedIntervals => _selectedIntervals.sink.add;

  toggleSelectedIntervals(int intervalID) {
    final ids = _selectedIntervals.value;
    if (intervalID == 0) {
      _selectedIntervals.sink.add(<int>[]);
      return;
    }

    if (ids.contains(intervalID)) {
      ids.remove(intervalID);
      _selectedIntervals.sink.add(ids);
    } else {
      ids.add(intervalID);
      _selectedIntervals.sink.add(ids);
    }
  }

  SubscriptionItemBloc() {
    getItems();
  }
  void dispose() {
    _itemController.close();
    _selectedIntervals.close();
  }
}
