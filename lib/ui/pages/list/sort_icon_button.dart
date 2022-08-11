import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/subscription_item_bloc.dart';
import 'package:subsuke/models/subsc.dart';
import 'package:subsuke/ui/pages/list/sort_condition_option.dart';
import 'package:subsuke/ui/pages/list/sort_condition_bottom_sheet.dart';

class SortIconButtonIOS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SubscriptionItemBLoC>(context);
    bloc.sortConditionStream.listen((cond) => bloc.getItems());

    return StreamBuilder(
      stream: bloc.sortConditionStream,
      builder: (BuildContext ctx, AsyncSnapshot<ItemSortCondition> ss) {
        return CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            CupertinoIcons.sort_down,
            size: 28,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: (() {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext ctx) {
                return SortConditionBottomSheet(
                  onPressClear: () {
                    bloc.setSortCondition(ItemSortCondition.None);
                    Navigator.pop(ctx);
                  },
                  children: [
                    SortConditionOption(
                      selected: ss.data == ItemSortCondition.PriceASC,
                      option: ItemSortCondition.PriceASC.sortConditionName,
                      onTap: () {
                        bloc.setSortCondition(ItemSortCondition.PriceASC);
                        Navigator.pop(ctx);
                      },
                    ),
                    SortConditionOption(
                      selected: ss.data == ItemSortCondition.PriceDESC,
                      option: ItemSortCondition.PriceDESC.sortConditionName,
                      onTap: () {
                        bloc.setSortCondition(ItemSortCondition.PriceDESC);
                        Navigator.pop(ctx);
                      },
                    ),
                    SortConditionOption(
                      selected: ss.data == ItemSortCondition.NextASC,
                      option: ItemSortCondition.NextASC.sortConditionName,
                      onTap: () {
                        bloc.setSortCondition(ItemSortCondition.NextASC);
                        Navigator.pop(ctx);
                      },
                    ),
                    SortConditionOption(
                      selected: ss.data == ItemSortCondition.NextDESC,
                      option: ItemSortCondition.NextDESC.sortConditionName,
                      onTap: () {
                        bloc.setSortCondition(ItemSortCondition.NextDESC);
                        Navigator.pop(ctx);
                      },
                    ),
                  ],
                );
              },
            );
          }),
        );
      },
    );
  }
}

class SortIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SubscriptionItemBLoC>(context);
    final sortCondition = bloc.getSortCondition();
    bloc.sortConditionStream.listen((cond) => bloc.getItems());

    return IconButton(
      constraints: BoxConstraints(minWidth: 20, minHeight: 20),
      splashRadius: 20,
      /* icon: Stack( */
      /*   alignment: Alignment.bottomRight, */
      /*   children: [ */
      /*     Icon(Icons.sort), */
      /*     Icon(Icons.south, size: 12), */
      /*   ], */
      /* ), */
      icon: Icon(CupertinoIcons.sort_down),
      onPressed: (() {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext ctx) {
            return SortConditionBottomSheet(
              onPressClear: () {
                bloc.setSortCondition(ItemSortCondition.None);
                Navigator.pop(ctx);
              },
              children: [
                SortConditionOption(
                  selected: sortCondition == ItemSortCondition.PriceASC,
                  option: ItemSortCondition.PriceASC.sortConditionName,
                  onTap: () {
                    bloc.setSortCondition(ItemSortCondition.PriceASC);
                    Navigator.pop(ctx);
                  },
                ),
                SortConditionOption(
                  selected: sortCondition == ItemSortCondition.PriceDESC,
                  option: ItemSortCondition.PriceDESC.sortConditionName,
                  onTap: () {
                    bloc.setSortCondition(ItemSortCondition.PriceDESC);
                    Navigator.pop(ctx);
                  },
                ),
                SortConditionOption(
                  selected: sortCondition == ItemSortCondition.NextASC,
                  option: ItemSortCondition.NextASC.sortConditionName,
                  onTap: () {
                    bloc.setSortCondition(ItemSortCondition.NextASC);
                    Navigator.pop(ctx);
                  },
                ),
                SortConditionOption(
                  selected: sortCondition == ItemSortCondition.NextDESC,
                  option: ItemSortCondition.NextDESC.sortConditionName,
                  onTap: () {
                    bloc.setSortCondition(ItemSortCondition.NextDESC);
                    Navigator.pop(ctx);
                  },
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
