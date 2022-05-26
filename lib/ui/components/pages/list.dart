import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/edit_screen_bloc.dart';
import 'package:subsuke/blocs/subscription_item_bloc.dart';
import 'package:subsuke/db/db_provider.dart';
import 'package:subsuke/models/subsc.dart';
import 'package:subsuke/ui/components/pages/edit.dart';
import 'package:subsuke/ui/components/templates/price_tabbar_view.dart';
import 'package:subsuke/ui/components/ui_parts/subscription_list_item.dart';

class ListPage extends StatelessWidget {
  Future<void> onPressDelete(int id) async {
    await DBProvider.instance.deleteSubscriptionItem(id);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SubscriptionItemBloc>(context);
    return StreamBuilder(
      stream: bloc.onChangeSubscriptionItems,
      builder: (BuildContext context,
          AsyncSnapshot<List<SubscriptionItem>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            return Container(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: PriceInfoTabView(snapshot.data!),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  "登録中のサービス一覧",
                                  style: TextStyle(fontSize: 18),
                                )),
                            Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: IconButton(
                                  constraints: BoxConstraints(
                                      minWidth: 20, minHeight: 20),
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
                                        builder: (context) {
                                          return Container(
                                            height: 250,
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  child: InkWell(
                                                    onTap: () {
                                                      print("price lower");
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "お支払い金額が小さい順",
                                                          textAlign:
                                                              TextAlign.justify,
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 50,
                                                  child: InkWell(
                                                    onTap: () {
                                                      print("price lower");
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "お支払い金額が大きい順",
                                                          textAlign:
                                                              TextAlign.justify,
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 50,
                                                  child: InkWell(
                                                    onTap: () {
                                                      print("price lower");
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "お支払日が近い順",
                                                          textAlign:
                                                              TextAlign.justify,
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 50,
                                                  child: InkWell(
                                                    onTap: () {
                                                      print("price lower");
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "お支払日が遠い順",
                                                          textAlign:
                                                              TextAlign.justify,
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  }),
                                ))
                          ],
                        ),
                        StreamBuilder(
                          stream: bloc.selectedIntervalsStream,
                          builder: (BuildContext ctx,
                              AsyncSnapshot<List<int>> snapshot) {
                            return MultiSelectChipDisplay(
                              colorator: (p0) {
                                final d = snapshot.data;
                                if (d == null || d.isEmpty) {
                                  return p0 == 0
                                      ? Theme.of(ctx).primaryColor
                                      : Colors.transparent;
                                }

                                return d.contains(p0)
                                    ? Theme.of(context).primaryColor
                                    : Colors.transparent;
                              },
                              chipColor: Theme.of(ctx).primaryColor,
                              onTap: (value) {
                                if (value == null) {
                                  return;
                                }
                                final val = value as int;
                                bloc.toggleSelectedIntervals(val);
                              },
                              textStyle:
                                  TextStyle(fontSize: 14, color: Colors.white),
                              items: [
                                MultiSelectItem(0, "すべて"),
                                MultiSelectItem(
                                    PaymentInterval.Daily.intervalID, "日払い"),
                                MultiSelectItem(
                                    PaymentInterval.Weekly.intervalID, "週払い"),
                                MultiSelectItem(
                                    PaymentInterval.Monthly.intervalID, "月払い"),
                                MultiSelectItem(
                                    PaymentInterval.Yearly.intervalID, "年払い"),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Theme.of(context).hintColor),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 20, top: 20),
                      itemCount: snapshot.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = snapshot.data![index];
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
                                builder: (BuildContext ctx) =>
                                    Provider<EditScreenBloc>(
                                  create: (ctx) => EditScreenBloc(),
                                  dispose: (ctx, bloc) => bloc.dispose(),
                                  child: EditPage(item, () => bloc.getItems()),
                                ),
                              );
                            },
                            child: SubscriptionListItem(item),
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
