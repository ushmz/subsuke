import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:subsuke/models/payment_interval.dart';

class PriceCard extends StatelessWidget {
  final int price;
  final PaymentInterval interval;

  PriceCard(this.price, this.interval);

  @override
  Widget build(BuildContext context) {
    /* final locale = Localizations.localeOf(context); */
    final ccy = new NumberFormat("#,###");
    final resolvedTheme = Theme.of(context);
    return Card(
      color: resolvedTheme.cardTheme.color,
      shape: resolvedTheme.cardTheme.shape,
      shadowColor: resolvedTheme.cardTheme.shadowColor,
      clipBehavior: resolvedTheme.cardTheme.clipBehavior,
      child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${interval.getText}あたり',
                        style: resolvedTheme.textTheme.headlineMedium)
                  ],
                ),
                Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '合計金額',
                      style: resolvedTheme.textTheme.headlineSmall,
                    ),
                    Center(),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: ccy.format(price),
                            style: resolvedTheme.textTheme.headlineMedium,
                          ),
                          TextSpan(
                            text: " 円",
                            style: resolvedTheme.textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
