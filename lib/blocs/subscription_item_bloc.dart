import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:subsuke/db/db_provider.dart';
import 'package:subsuke/models/subsc.dart';

typedef ItemSinkAdd = Function(List<SubscriptionItem>);
typedef ItemStream = Stream<List<SubscriptionItem>>;
typedef ItemTransformer
    = StreamTransformer<List<SubscriptionItem>, List<SubscriptionItem>>;
typedef ItemSubscription = StreamSubscription<List<SubscriptionItem>>;
typedef ProratedPrice = Map<PaymentInterval, int>;

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

  final _actual = BehaviorSubject<int>();
  Stream<int> get actualPriceStream => _actual.stream;
  int get actualPrice => _actual.stream.value;

  final _total = BehaviorSubject<ProratedPrice>();
  Stream<ProratedPrice> get proratedPriceStream => _total.stream;
  ProratedPrice get proratedPrice => _total.stream.value;

  ItemSubscription actualMonthlyPriceListener() {
    return _items.stream.listen((value) {
      final n = DateTime.now();
      final days = new DateTime(n.year, n.month, 0).day;

      int actual = 0;
      value.forEach((v) {
        switch (v.interval) {
          case PaymentInterval.Daily:
            actual += v.price * days;
            break;
          case PaymentInterval.Weekly:
            actual += v.price * (days ~/ 7);
            break;
          case PaymentInterval.Fortnightly:
            actual += v.price * (days ~/ 14);
            break;
          case PaymentInterval.Monthly:
            actual += v.price;
            break;
          case PaymentInterval.Yearly:
            if (v.next.month == n.month) {
              actual += v.price;
            }
            break;
        }
      });
      _actual.sink.add(actual);
    });
  }

  ItemSubscription proratedPriceListener() {
    return _items.stream.listen((value) {
      int daily = 0;
      int weekly = 0;
      int monthly = 0;
      int yearly = 0;

      value.forEach(
        (data) {
          switch (data.interval) {
            case PaymentInterval.Daily:
              final y = data.price * 365;
              daily += data.price;
              weekly += data.price * 7;
              monthly += y ~/ 12;
              yearly += y;
              break;
            case PaymentInterval.Weekly:
              final y = data.price ~/ 7 * 365;
              daily += data.price ~/ 7;
              weekly += data.price;
              monthly += y ~/ 12;
              yearly += y;
              break;
            case PaymentInterval.Fortnightly:
              final y = data.price ~/ 14 * 365;
              daily += data.price ~/ 14;
              weekly += data.price ~/ 2;
              monthly += y ~/ 12;
              yearly += y;
              break;
            case PaymentInterval.Monthly:
              final d = data.price * 12 ~/ 365;
              daily += d;
              weekly += d * 7;
              monthly += data.price;
              yearly += data.price * 12;
              break;
            case PaymentInterval.Yearly:
              final d = data.price ~/ 365;
              daily += d;
              weekly += d * 7;
              monthly += data.price ~/ 12;
              yearly += data.price;
              break;
          }
        },
      );
      _total.sink.add({
        PaymentInterval.Daily: daily,
        PaymentInterval.Weekly: weekly,
        PaymentInterval.Monthly: monthly,
        PaymentInterval.Yearly: yearly
      });
    });
  }

  ItemTransformer itemFilter() {
    return ItemTransformer.fromHandlers(
      handleData: ((data, sink) {
        final selected = _selectedIntervals.value;
        final filtered = data.where((item) {
          if (selected.isEmpty) {
            return true;
          }
          return selected.contains(item.interval.intervalID);
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
    actualMonthlyPriceListener();
    proratedPriceListener();
  }

  void dispose() {
    _items.close();
    _selectedIntervals.close();
    _sortCondition.close();
    _total.close();
    _actual.close();
  }
}
