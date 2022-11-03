import 'package:flutter_test/flutter_test.dart';
import 'package:subsuke/blocs/subscription_item_bloc.dart';
import 'package:subsuke/models/subsc.dart';

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

        await expectLater(
          bloc.actualPriceStream,
          emits(t['actual']['${DateTime.now().month}']),
        );
      });
    });
  }

  for (var t in tt) {
    group("Test prorated price calculate", () {
      test("> ${t['description']}", () async {
        final bloc = SubscriptionItemBLoC();
        final items = t['items'] as List<dynamic>;
        final i = items.map((e) => SubscriptionItem.fromJson(e)).toList();
        bloc.setSubscriptionItems(i);

        await expectLater(
          bloc.proratedPriceStream,
          emits({
            PaymentInterval.Daily: t['prorated']['0'],
            PaymentInterval.Weekly: t['prorated']['1'],
            PaymentInterval.Monthly: t['prorated']['3'],
            PaymentInterval.Yearly: t['prorated']['4'],
          }),
        );
      });
    });
  }
}
