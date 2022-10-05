import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/edit_screen_bloc.dart';
import 'package:subsuke/blocs/payment_methods_bloc.dart';
import 'package:subsuke/models/subsc.dart';
import 'package:subsuke/ui/pages/edit/edit.ios.dart';

class ListItem extends StatelessWidget {
  final SubscriptionItem item;
  final Function(BuildContext) onSlidableActionPressed;
  ListItem({
    required this.item,
    required this.onSlidableActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(item.id),
      endActionPane: ActionPane(
        extentRatio: 0.2,
        motion: BehindMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: onSlidableActionPressed,
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icons.delete,
            label: "削除",
          )
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (BuildContext ctx) {
                  return MultiProvider(
                    providers: [
                      Provider<EditScreenBLoC>(
                        create: (ctx) => EditScreenBLoC(),
                        dispose: (ctx, bloc) => bloc.dispose(),
                      ),
                      Provider<PaymentMethodBLoC>(
                        create: (ctx) => PaymentMethodBLoC(),
                        dispose: (ctx, bloc) => bloc.dispose(),
                      ),
                    ],
                    child: EditPageIOS(item),
                  );
                },
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: ListItemContents(item),
          ),
        ),
      ),
    );
  }
}

class ListItemContents extends StatelessWidget {
  final SubscriptionItem item;
  ListItemContents(this.item);

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
            height: MediaQuery.of(context).size.height * 0.075,
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
