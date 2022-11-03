import 'package:flutter/material.dart';
import 'package:subsuke/models/payment_interval.dart';
import 'package:subsuke/models/prorated_price.dart';
import 'package:subsuke/ui/components/ui_parts/price_card.dart';

class CarouselContent extends StatelessWidget {
  final List<Widget> children;
  CarouselContent({required this.children});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: children
          .map(
            (c) => Padding(
              padding: EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).cardTheme.shadowColor!,
                      spreadRadius: 0.1,
                      blurRadius: 7.0,
                      offset: Offset(0, 5.0),
                    )
                  ],
                ),
                child: c,
              ),
            ),
          )
          .toList(),
    );
  }
}

class PriceCarousel extends StatelessWidget {
  final ProratedPrice prices;
  final int defaultTab;

  PriceCarousel({required this.prices, this.defaultTab = 0});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: defaultTab,
      length: 4,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: CarouselContent(children: [
                PriceCard(prices.daily, PaymentInterval.Daily),
                PriceCard(prices.weekly, PaymentInterval.Weekly),
                PriceCard(prices.monthly, PaymentInterval.Monthly),
                PriceCard(prices.yearly, PaymentInterval.Yearly),
              ]),
            ),
            Expanded(
              flex: 1,
              child: TabPageSelector(
                selectedColor: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
