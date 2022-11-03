import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/settings_bloc.dart';
import 'package:subsuke/blocs/subscription_item_bloc.dart';
import 'package:subsuke/models/prorated_price.dart';
import 'package:subsuke/models/subscription_item.dart';
import 'package:subsuke/notifications/notifications.dart';
import 'package:subsuke/ui/components/templates/price_carousel.dart';
import 'package:subsuke/ui/components/templates/add_modal_button.dart';
import 'package:subsuke/ui/pages/list/list_item.dart';
import 'package:subsuke/ui/pages/list/sort_icon_button.dart';

class ListPageIOS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SubscriptionItemBLoC>(context);
    final pref = Provider.of<SettingsBLoC>(context);
    final nf = Provider.of<NotificationRepository>(context);

    final resolvedColor = Theme.of(context).textTheme.titleLarge!.color;

    return FutureBuilder(
      future: bloc.getItems(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return StreamBuilder(
          stream: bloc.itemStream,
          builder:
              (BuildContext ctx, AsyncSnapshot<List<SubscriptionItem>> ss) {
            switch (ss.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (ss.data == null) {
                  return Center(child: Text("サブスクリプションを追加"));
                }
                return CupertinoPageScaffold(
                  child: CustomScrollView(
                    slivers: [
                      CupertinoSliverNavigationBar(
                        border: null,
                        brightness: Theme.of(context).brightness,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        leading: SortIconButton(
                          stream: bloc.sortConditionStream,
                          onChange: (cond) {
                            bloc.setSortCondition(cond);
                            bloc.getItems();
                          },
                        ),
                        largeTitle: Text(
                          "subsuke",
                          style: TextStyle(color: resolvedColor),
                        ),
                        trailing: GestureDetector(
                          child: AddModalButton(
                            onItemAdd: (item) {
                              bloc.create(item);
                              nf.scheduleNotification(item);
                            },
                          ),
                        ),
                      ),
                      SliverGrid.count(
                        childAspectRatio: 1.6,
                        crossAxisCount: 1,
                        children: [
                          StreamBuilder<ProratedPrice>(
                            stream: bloc.proratedPriceStream,
                            builder: (ctx, ss) {
                              return PriceCarousel(
                                prices: ss.data!,
                                defaultTab: pref.getDefaultCarousel(),
                              );
                            },
                          )
                        ],
                      ),
                      SliverFixedExtentList(
                        itemExtent: MediaQuery.of(context).size.height * 0.075,
                        delegate: SliverChildListDelegate(
                          ss.data!.map((item) {
                            return ListItem(
                              item: item,
                              onSlidableActionPressed: (BuildContext c) {
                                bloc.delete(item.id);
                              },
                              onItemUpdated: (int id, SubscriptionItem i) {
                                bloc.update(id, i);
                                nf.scheduleNotification(i);
                              },
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                );
            }
          },
        );
      },
    );
  }
}
