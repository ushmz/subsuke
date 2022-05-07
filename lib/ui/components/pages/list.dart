import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
    await DBProvider.instance?.deleteSubscriptionItem(id);
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
