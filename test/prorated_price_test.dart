import 'package:flutter_test/flutter_test.dart';
import 'package:subsuke/models/prorated_price.dart';
import 'package:subsuke/models/subscription_item.dart';

import 'fixture.dart';

void main() {
  proratedPriceTest();
}

void proratedPriceTest() {
  final fixture = getSubscriptionItemsFixtures();
  final tt = fixture['tests'] as List<dynamic>;

  for (var t in tt) {
    group("Test prorated price calculate", () {
      test("> ${t['description']}", () async {
        final items = t['items'] as List<dynamic>;
        final i = items.map((e) => SubscriptionItem.fromJson(e)).toList();
        final prorated = ProratedPrice.fromItems(i);

        expect(prorated.daily, t['prorated']['0']);
        expect(prorated.weekly, t['prorated']['1']);
        expect(prorated.monthly, t['prorated']['3']);
        expect(prorated.yearly, t['prorated']['4']);
      });
    });
  }
}
