import 'package:flutter_test/flutter_test.dart';
import 'package:subsuke/blocs/subscription_item_bloc.dart';
import 'package:subsuke/models/subsc.dart';
import 'package:fake_async/fake_async.dart';

import 'fixture.dart';

void main() {
  sortItemsTest();
}

List<int> _getItemIDs(List<SubscriptionItem> items) {
  return items.map((i) => i.id).toList();
}

void sortItemsTest() {
  final fixture = getSubscriptionItemsSortFixtures();
  final tt = fixture['tests'] as List<dynamic>;

  for (var t in tt) {
    group('Sort test (${t['description']})', () {
      final items = t['items'] as List<dynamic>;
      final i = items.map((e) => SubscriptionItem.fromJson(e)).toList();
      final orders = t['order'] as Map<String, dynamic>;

      List<int> outputIDs = [];
      final bloc = SubscriptionItemBLoC();
      bloc.itemStream.listen((items) {
        outputIDs = _getItemIDs(items);
      });

      for (var cond in orders.keys) {
        final sc = getSortCondition(int.parse(cond));
        test("> ${sc.toString()}", () {
          FakeAsync().run((self) {
            final o = orders[cond] as List<dynamic>;
            final ids = o.map((e) => e as int).toList();
            bloc.setSortCondition(sc);
            bloc.setSubscriptionItems(i);
            // TODO : WHY???
            self.elapse(Duration(seconds: 0));
            expect(outputIDs, ids);
          });
        });
      }
    });
  }
}
