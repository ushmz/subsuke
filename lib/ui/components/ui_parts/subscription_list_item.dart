import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:subsuke/models/subsc.dart';

class SubscriptionListItem extends StatelessWidget {
  final SubscriptionItem item;
  SubscriptionListItem(this.item);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyText1!,
      child: SizedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height*0.075,
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "次回お支払日 ${DateFormat('yyyy-MM-dd').format(item.next)}",
                            style: Theme.of(context).textTheme.labelLarge,
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
                      "${item.price}円",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
