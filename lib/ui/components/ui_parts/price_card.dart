import 'package:flutter/material.dart';
import 'package:subsuke/models/subsc.dart';

class PriceCard extends StatelessWidget {
  final int price;
  final PaymentInterval interval;

  PriceCard(this.price, this.interval);

  @override
  Widget build(BuildContext context) {
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
              /* mainAxisAlignment: MainAxisAlignment.spaceBetween, */
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("合計金額", style: resolvedTheme.textTheme.bodyMedium)
                  ],
                ),
                Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${interval.intervalText}あたり',
                      style: resolvedTheme.textTheme.bodyMedium,
                    ),
                    Center(),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "$price",
                            style: resolvedTheme.textTheme.bodyLarge,
                          ),
                          TextSpan(
                            text: " ",
                            style: resolvedTheme.textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text: "円",
                            style: resolvedTheme.textTheme.bodyMedium,
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
