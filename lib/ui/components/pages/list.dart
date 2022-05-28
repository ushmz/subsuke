import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/edit_screen_bloc.dart';
import 'package:subsuke/blocs/subscription_item_bloc.dart';
import 'package:subsuke/models/subsc.dart';
import 'package:subsuke/ui/components/pages/edit.dart';
import 'package:subsuke/ui/components/templates/price_tabbar_view.dart';
import 'package:subsuke/ui/components/ui_parts/subscription_list_item.dart';

class SortConditionOption extends StatelessWidget {
  final String option;
  final Function() onTap;
  final bool? selected;

  SortConditionOption({
    required this.option,
    required this.onTap,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  option,
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 18),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(
                    Icons.check,
                    color: selected != null && selected!
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SortConditionBottomSheet extends StatelessWidget {
  final List<SortConditionOption> children;
  final Function() onPressClear;
  SortConditionBottomSheet(
      {required this.children, required this.onPressClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("並び替え順序", style: TextStyle(fontSize: 16)),
                  InkWell(
                    onTap: onPressClear,
                    child: Text("クリア", style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Theme.of(context).hintColor,
            height: 1,
          ),
          ...children
        ],
      ),
    );
  }
}

class SortIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SubscriptionItemBloc>(context);
    final sortCondition = bloc.getSortCondition();
    bloc.sortConditionStream.listen((cond) => bloc.getItems());
    return IconButton(
      constraints: BoxConstraints(minWidth: 20, minHeight: 20),
      splashRadius: 24,
      icon: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Icon(Icons.sort),
          Icon(Icons.south, size: 12),
          /* Container( */
          /*     margin: EdgeInsets.only(left: 13, top: 10), */
          /*     child: Icon(Icons.south, size: 12)) */
        ],
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

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SubscriptionItemBloc>(context);
    return StreamBuilder(
      stream: bloc.itemStream,
      builder: (BuildContext ctx, AsyncSnapshot<List<SubscriptionItem>> ss) {
        switch (ss.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            return Container(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(ctx).size.height * 0.25,
                    child: PriceInfoTabView(ss.data!),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "登録中のサービス一覧",
                                  style: TextStyle(fontSize: 18),
                                ),
                                SortIconButton()
                              ],
                            )),
                        StreamBuilder(
                          stream: bloc.selectedIntervalsStream,
                          builder:
                              (BuildContext c, AsyncSnapshot<List<int>> s) {
                            return MultiSelectChipDisplay(
                              colorator: (p0) {
                                final d = s.data;
                                if (d == null || d.isEmpty) {
                                  return p0 == 0
                                      ? Theme.of(c).primaryColor
                                      : Color(0xFFDCCFEC);
                                }
                                return d.contains(p0)
                                    ? Theme.of(c).primaryColor
                                    : Color(0xFFDCCFEC);
                              },
                              chipColor: Theme.of(c).primaryColor,
                              onTap: (value) {
                                if (value == null) {
                                  return;
                                }
                                final val = value as int;
                                bloc.toggleSelectedIntervals(val);
                              },
                              textStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              items: [
                                MultiSelectItem(
                                  0,
                                  "すべて",
                                ),
                                MultiSelectItem(
                                  PaymentInterval.Daily.intervalID,
                                  "日払い",
                                ),
                                MultiSelectItem(
                                  PaymentInterval.Weekly.intervalID,
                                  "週払い",
                                ),
                                MultiSelectItem(
                                  PaymentInterval.Monthly.intervalID,
                                  "月払い",
                                ),
                                MultiSelectItem(
                                  PaymentInterval.Yearly.intervalID,
                                  "年払い",
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Theme.of(ctx).hintColor, height: 1),
                  Expanded(
                    child: ListView.builder(
                      itemCount: ss.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = ss.data![index];
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
                                backgroundColor: Theme.of(context).primaryColor,
                                icon: Icons.delete,
                                label: "削除",
                              )
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              showCupertinoModalBottomSheet(
                                context: context,
                                builder: (BuildContext ctx) {
                                  return Provider<EditScreenBloc>(
                                    create: (ctx) => EditScreenBloc(),
                                    dispose: (ctx, bloc) => bloc.dispose(),
                                    child:
                                        EditPage(item, () => bloc.getItems()),
                                  );
                                },
                              );
                            },
                            child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 2),
                                child: SubscriptionListItem(item)),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
        }
      },
    );
  }
}
