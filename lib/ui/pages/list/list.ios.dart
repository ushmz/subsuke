import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/edit_screen_bloc.dart';
import 'package:subsuke/blocs/payment_methods_bloc.dart';
import 'package:subsuke/blocs/subscription_item_bloc.dart';
import 'package:subsuke/models/subsc.dart';
import 'package:subsuke/ui/components/ui_parts/subscription_list_item.dart';
import 'package:subsuke/ui/components/templates/add_modal_button.dart';
import 'package:subsuke/ui/pages/edit/edit.dart';
import 'package:subsuke/ui/pages/list/sort_icon_button.dart';
import 'package:subsuke/ui/components/templates/price_carousel.dart';

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
            return CupertinoPageScaffold(
              child: CustomScrollView(
                slivers: [
                  CupertinoSliverNavigationBar(
                    border: null,
                    brightness: Theme.of(context).brightness,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    leading: Material(
                      type: MaterialType.transparency,
                      child: SortIconButtonIOS(),
                    ),
                    largeTitle: Text(
                      "subsuke",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.titleLarge!.color),
                    ),
                    trailing: Material(
                      type: MaterialType.transparency,
                      child: AddModelButtonIOS(),
                    ),
                  ),
                  SliverGrid.count(
                    childAspectRatio: 1.6,
                    crossAxisCount: 1,
                    children: [PriceCarousel(ss.data ?? [])],
                  ),
                  SliverFixedExtentList(
                    itemExtent: 180,
                    delegate: SliverChildListDelegate(
                      [
                        Column(
                          children: ss.data!.map((item) {
                            return Slidable(
                              key: ValueKey(item.id),
                              endActionPane: ActionPane(
                                extentRatio: 0.2,
                                motion: BehindMotion(),
                                children: [
                                  SlidableAction(
                                    flex: 1,
                                    onPressed: (BuildContext c) =>
                                        bloc.delete(item.id),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    icon: Icons.delete,
                                    label: "削除",
                                  )
                                ],
                              ),
                              child: Material(
                                type: MaterialType.transparency,
                                child: InkWell(
                                  onTap: () {
                                    showCupertinoModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext ctx) {
                                        return MultiProvider(
                                          providers: [
                                            Provider<EditScreenBLoC>(
                                              create: (ctx) => EditScreenBLoC(),
                                              dispose: (ctx, bloc) =>
                                                  bloc.dispose(),
                                            ),
                                            Provider<PaymentMethodBLoC>(
                                              create: (context) =>
                                                  PaymentMethodBLoC(),
                                              dispose: (context, bloc) =>
                                                  bloc.dispose(),
                                            ),
                                          ],
                                          child: EditPage(
                                              item, () => bloc.getItems()),
                                        );
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2),
                                    child: SubscriptionListItem(item),
                                  ),
                                ),
                              ),
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
