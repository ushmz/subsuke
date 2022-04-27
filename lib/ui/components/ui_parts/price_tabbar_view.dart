import 'package:flutter/material.dart';
import 'package:subsuke/models/subsc.dart';

class PriceInfoTabView extends StatelessWidget {
  final List<SubscriptionItem> items;

  PriceInfoTabView(this.items);

  List<Widget> priceInfoBuilder(List<SubscriptionItem> items) {
    int daily = 0;
    int weekly = 0;
    int monthly = 0;
    int yearly = 0;

    items.forEach((item) {
      switch (item.interval) {
        case PaymentInterval.Daily:
          final y = item.price * 365;
          daily += item.price;
          weekly += item.price * 7;
          monthly += y ~/ 12;
          yearly += y;
          break;
        case PaymentInterval.Weekly:
          final y = item.price ~/ 7 * 365;
          daily += item.price ~/ 7;
          weekly += item.price;
          monthly += y ~/ 12;
          yearly += y;
          break;
        case PaymentInterval.Fortnightly:
          final y = item.price ~/ 14 * 365;
          daily += item.price ~/ 14;
          weekly += item.price ~/ 2;
          monthly += y ~/ 12;
          yearly += y;
          break;
        case PaymentInterval.Monthly:
          final d = item.price * 12 ~/ 365;
          daily += d;
          weekly += d * 7;
          monthly += item.price;
          yearly += item.price * 12;
          break;
        case PaymentInterval.Yearly:
          final d = item.price ~/ 365;
          daily += d;
          weekly += d * 7;
          monthly += item.price ~/ 12;
          yearly += item.price;
          break;
      }
    });

    return [
      Center(
        child: Text('$daily円 / 日', style: TextStyle(fontSize: 32)),
      ),
      Center(
        child: Text('$weekly円 / 週', style: TextStyle(fontSize: 32)),
      ),
      Center(
        child: Text('$monthly円 / 月', style: TextStyle(fontSize: 32)),
      ),
      Center(
        child: Text('$yearly円 / 年', style: TextStyle(fontSize: 32)),
      ),
    ];
  }

  @override
  Widget build(BuildContext ctx) {
    return DefaultTabController(
      length: 4,
      child: Builder(
        builder: (BuildContext context) => Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: TabBarView(
                  children: priceInfoBuilder(items),
                ),
              ),
              Expanded(
                flex: 1,
                child: TabPageSelector(
                    selectedColor: Theme.of(context).primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
