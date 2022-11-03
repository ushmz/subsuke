import 'package:flutter_test/flutter_test.dart';
import 'package:subsuke/models/actual_price.dart';
import 'package:subsuke/models/subscription_item.dart';

import 'fixture.dart';

void main() {
  actualPriceTest();
}

void actualPriceTest() {
  final fixture = getSubscriptionItemsFixtures();
  final tt = fixture['tests'] as List<dynamic>;

  for (var t in tt) {
    group("Test actual price calculate", () {
      test("> ${t['description']}", () async {
        final items = t['items'] as List<dynamic>;
        final i = items.map((e) => SubscriptionItem.fromJson(e)).toList();
        final actual = ActualPrice.fromItems(i);

        // expect(actual, ActualPrice.fromJson({ }));
        expect(actual.monthly, t['actual']['${DateTime.now().month}']);
      });
    });
  }
}
