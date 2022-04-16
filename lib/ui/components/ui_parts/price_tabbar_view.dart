import 'package:flutter/material.dart';

import 'package:subsuke/models/subsucription.dart';

class PriceInfoTabView extends StatelessWidget {
  final List<Widget> children;

  PriceInfoTabView(this.children);

  List<Widget> priceInfoBuilder(Subscriptions items) {
    return [
      Center(
        child: Text('${items.daily}円 / 日', style: TextStyle(fontSize: 32)),
      ),
      Center(
        child: Text('${items.weekly}円 / 週', style: TextStyle(fontSize: 32)),
      ),
      Center(
        child: Text('${items.monthly}円 / 月', style: TextStyle(fontSize: 32)),
      ),
      Center(
        child: Text('${items.yearly}円 / 年', style: TextStyle(fontSize: 32)),
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
                  children: this.children,
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
