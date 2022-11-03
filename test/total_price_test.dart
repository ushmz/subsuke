import 'package:flutter_test/flutter_test.dart';
import 'package:subsuke/blocs/subscription_item_bloc.dart';
import 'package:subsuke/models/subscription_item.dart';

import 'fixture.dart';

void main() {
  totalPriceTest();
}

void totalPriceTest() {
  final fixture = getSubscriptionItemsFixtures();
  final tt = fixture['tests'] as List<dynamic>;

  for (var t in tt) {
    group("Test actual price calculate", () {
      test("> ${t['description']}", () async {
        final bloc = SubscriptionItemBLoC();
        final items = t['items'] as List<dynamic>;
        final i = items.map((e) => SubscriptionItem.fromJson(e)).toList();
        bloc.setSubscriptionItems(i);

        bloc.actualPriceStream.listen((event) {
          expect(event.monthly, t['actual']['${DateTime.now().month}']);
        });
      });
    });
  }

  for (var t in tt) {
    group("Test prorated price calculate", () {
      test("> ${t['description']}", () {
        final bloc = SubscriptionItemBLoC();
        final items = t['items'] as List<dynamic>;
        final i = items.map((e) => SubscriptionItem.fromJson(e)).toList();
        bloc.setSubscriptionItems(i);

        bloc.proratedPriceStream.listen((event) {
          expect(event.daily, t['prorated']['0']);
          expect(event.weekly, t['prorated']['1']);
          expect(event.monthly, t['prorated']['3']);
          expect(event.yearly, t['prorated']['4']);
        });
      });
    });
  }
}
