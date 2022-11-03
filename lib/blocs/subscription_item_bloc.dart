import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:subsuke/db/db_provider.dart';
import 'package:subsuke/models/subsc.dart';

typedef ItemSinkAdd = Function(List<SubscriptionItem>);
typedef ItemStream = Stream<List<SubscriptionItem>>;
typedef ItemTransformer
    = StreamTransformer<List<SubscriptionItem>, List<SubscriptionItem>>;
typedef ItemSubscription = StreamSubscription<List<SubscriptionItem>>;

class SubscriptionItemBLoC {
  final _selectedIntervals = BehaviorSubject<List<int>>.seeded(<int>[]);
  Stream<List<int>> get selectedIntervalsStream => _selectedIntervals.stream;
  Function(List<int>) get setSelectedIntervals => _selectedIntervals.sink.add;

  toggleSelectedIntervals(int intervalID) {
    final ids = _selectedIntervals.value;
    if (intervalID == 0) {
      _selectedIntervals.sink.add(<int>[]);
      getItems();
      return;
    }

    if (ids.contains(intervalID)) {
      ids.remove(intervalID);
      _selectedIntervals.sink.add(ids);
    } else {
      ids.add(intervalID);
      _selectedIntervals.sink.add(ids);
    }
    getItems();
  }

  final _sortCondition = BehaviorSubject.seeded(ItemSortCondition.None);
  Stream<ItemSortCondition> get sortConditionStream => _sortCondition.stream;
  Function(ItemSortCondition) get setSortCondition => _sortCondition.sink.add;

  ItemSortCondition getSortCondition() {
    return _sortCondition.stream.value;
  }

  final _items = BehaviorSubject<List<SubscriptionItem>>();

  Stream<int> get actualPriceStream =>
      _items.stream.map<int>((event) => calcActualMonthlyPrice(event));

  Stream<ProratedPrice> get proratedPriceStream =>
      _items.stream.map<ProratedPrice>((event) => calcProratedPrice(event));

  ItemTransformer itemFilter() {
    return ItemTransformer.fromHandlers(
      handleData: ((data, sink) {
        final selected = _selectedIntervals.value;
        final filtered = data.where((item) {
          if (selected.isEmpty) {
            return true;
          }
          return selected.contains(item.interval.getID);
        });
        sink.add(filtered.toList());
      }),
    );
  }

  ItemTransformer itemSort() {
    return StreamTransformer.fromHandlers(
      handleData: ((data, sink) {
        final sortCondition = _sortCondition.value;
        data.sort(((a, b) {
          switch (sortCondition) {
            case ItemSortCondition.None:
              return 1;
            case ItemSortCondition.PriceASC:
              return a.price.compareTo(b.price);
            case ItemSortCondition.PriceDESC:
              return a.price.compareTo(b.price) * -1;
            case ItemSortCondition.NextASC:
              return a.next.compareTo(b.next);
            case ItemSortCondition.NextDESC:
              return a.next.compareTo(b.next) * -1;
          }
        }));
        sink.add(data);
      }),
    );
  }

  ItemSinkAdd get setSubscriptionItems => _items.sink.add;
  // ItemStream get onChangeSubscriptionItems => _items.stream;
  ItemStream get itemStream {
    return _items.stream.transform(itemFilter()).transform(itemSort());
  }

  getItems() async {
    final items = await DBProvider.instance.getAllSubscriptions();
    _items.sink.add(items.toList());
  }

  create(SubscriptionItem item) {
    DBProvider.instance.createSubscriptionItem(item);
    getItems();
  }

  update(int id, SubscriptionItem item) {
    DBProvider.instance.updateSubscriptionItem(id, item);
    getItems();
  }

  delete(int id) {
    DBProvider.instance.deleteSubscriptionItem(id);
    getItems();
  }

  SubscriptionItemBLoC() {
    getItems();
  }

  void dispose() {
    _items.close();
    _selectedIntervals.close();
    _sortCondition.close();
  }
}
