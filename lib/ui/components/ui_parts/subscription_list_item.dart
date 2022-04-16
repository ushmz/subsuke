import 'package:flutter/material.dart';
import 'package:subsuke/models/subsucription.dart';

class SubscriptionListItem extends StatelessWidget {
  final Subscription subscription;
  SubscriptionListItem(this.subscription);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyText1!,
      child: SizedBox(
        height: 56,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(subscription.name),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "次回お支払日 ${subscription.billingAt}",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${subscription.price}円",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
