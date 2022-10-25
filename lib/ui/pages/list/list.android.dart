import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/subscription_item_bloc.dart';
import 'package:subsuke/models/subsc.dart';
import 'package:subsuke/ui/components/templates/add_modal_button.dart';
import 'package:subsuke/ui/pages/list/list_item.dart';
import 'package:subsuke/ui/pages/list/sort_icon_button.dart';
import 'package:subsuke/ui/components/templates/price_carousel.dart';

class ListPageAndroid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SubscriptionItemBLoC>(context);

    return StreamBuilder(
      stream: bloc.itemStream,
      builder: (BuildContext ctx, AsyncSnapshot<List<SubscriptionItem>> ss) {
        switch (ss.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (ss.data == null) {
              return Center(child: Text("サブスクリプションを追加"));
            }
            return Scaffold(
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    leading: SortIconButton(
                      stream: bloc.sortConditionStream,
                      onChange: (cond) {
                        bloc.setSortCondition(cond);
                        bloc.getItems();
                      },
                    ),
                    actions: [AddModalButton(onItemAdd: (item) {})],
                    expandedHeight: 100,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        "subsuke",
                        style: TextStyle(
                            color: Theme.of(ctx).textTheme.titleLarge!.color),
                      ),
                      titlePadding:
                          EdgeInsetsDirectional.only(start: 18, bottom: 16),
                    ),
                  ),
                  SliverGrid.count(
                    childAspectRatio: 1.6,
                    crossAxisCount: 1,
                    children: [PriceCarousel(prices: bloc.proratedPrice)],
                  ),
                  SliverFixedExtentList(
                    itemExtent: 180,
                    delegate: SliverChildListDelegate(
                      [
                        Column(
                          children: ss.data!.map((item) {
                            return ListItem(
                              item: item,
                              onSlidableActionPressed: (c) {
                                bloc.delete(item.id);
                              },
                              onItemUpdated: (id, i) {
                                bloc.update(id, i);
                              },
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
        }
      },
    );
  }
}
