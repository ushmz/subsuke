import 'package:flutter_test/flutter_test.dart';
import 'package:subsuke/models/actual_price.dart';
import 'package:subsuke/models/subscription_item.dart';
import 'package:subsuke/blocs/subscription_item_bloc.dart';

import 'fixture.dart';

void main() {
  final fixture = getSubscriptionItemsFixtures();
  final tt = fixture['tests'] as List<dynamic>;
  for (var t in tt) {
    group("Test edit item", () {
      test("> ${t['description']}", () async {
        final items = t['items'] as List<dynamic>;
        final i = items.map((e) => SubscriptionItem.fromJson(e)).toList();
        final bloc = SubscriptionItemBLoC();
        bloc.setSubscriptionItems(i);
        bloc.update(t['item']['id'], t['item']);
      });
    });
  }
}
