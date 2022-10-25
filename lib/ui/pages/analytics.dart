import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:subsuke/blocs/subscription_item_bloc.dart';
import 'package:subsuke/ui/components/templates/price_carousel.dart';

import 'package:subsuke/models/subsc.dart';

@deprecated
class AnalyticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SubscriptionItemBLoC>(context);
    return Container(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: StreamBuilder(
              stream: bloc.itemStream,
              builder:
                  (BuildContext ctx, AsyncSnapshot<List<SubscriptionItem>> ss) {
                switch (ss.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    return PriceCarousel(prices: bloc.proratedPrice);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
