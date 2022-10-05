import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/subscription_item_bloc.dart';
import 'package:subsuke/models/subsc.dart';
import 'package:subsuke/ui/components/templates/add_modal_button.dart';
import 'package:subsuke/ui/components/templates/price_carousel.dart';
import 'package:subsuke/ui/pages/list/list_item.dart';
import 'package:subsuke/ui/pages/list/sort_icon_button.dart';

class ListPageIOS extends StatelessWidget {
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
            return CupertinoPageScaffold(
              child: CustomScrollView(
                slivers: [
                  CupertinoSliverNavigationBar(
                    border: null,
                    brightness: Theme.of(context).brightness,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    leading: SortIconButtonIOS(
                      stream: bloc.sortConditionStream,
                      onPressed: (cond) => bloc.setSortCondition(cond),
                    ),
                    largeTitle: Text(
                      "subsuke",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.titleLarge!.color),
                    ),
                    trailing: GestureDetector(
                      onTap: () {},
                      child: AddModelButton(),
                    ),
                  ),
                  SliverGrid.count(
                    childAspectRatio: 1.6,
                    crossAxisCount: 1,
                    children: [PriceCarousel(items: ss.data ?? [])],
                  ),
                  SliverFixedExtentList(
                    itemExtent: 180,
                    delegate: SliverChildListDelegate(
                      [
                        Column(
                          children: ss.data!.map((item) {
                            return ListItem(
                              item: item,
                              onSlidableActionPressed: (BuildContext c) {
                                bloc.delete(item.id);
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
