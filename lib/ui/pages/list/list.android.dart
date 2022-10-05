import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/edit_screen_bloc.dart';
import 'package:subsuke/blocs/subscription_item_bloc.dart';
import 'package:subsuke/models/subsc.dart';
import 'package:subsuke/ui/components/ui_parts/subscription_list_item.dart';
import 'package:subsuke/ui/pages/edit.dart';

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
            return Container(
              child: Column(
                children: [
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
                                // SortIconButton()
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
                                  return Provider<EditScreenBLoC>(
                                    create: (ctx) => EditScreenBLoC(),
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
