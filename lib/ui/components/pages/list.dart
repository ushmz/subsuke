import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/edit_screen_bloc.dart';
import 'package:subsuke/blocs/subscriptions_bloc.dart';
import 'package:subsuke/models/subsucription.dart';
import 'package:subsuke/ui/components/pages/edit.dart';
import 'package:subsuke/ui/components/ui_parts/price_tabbar_view.dart';
import 'package:subsuke/ui/components/ui_parts/subscription_list_item.dart';

class ListPage extends StatelessWidget {
  List<Widget> priceInfoBuilder(Subscriptions items) {
    return [
      Center(
        child: Text('${items.daily}円 / 日', style: TextStyle(fontSize: 32)),
      ),
      Center(
        child: Text('${items.weekly}円 / 週', style: TextStyle(fontSize: 32)),
      ),
      Center(
        child: Text('${items.monthly}円 / 月', style: TextStyle(fontSize: 32)),
      ),
      Center(
        child: Text('${items.yearly}円 / 年', style: TextStyle(fontSize: 32)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SubscriptionsBloc>(context);
    bloc.fetchRequest();
    return StreamBuilder(
      stream: bloc.onChangeSubscriptions,
      builder:
          (BuildContext context, AsyncSnapshot<List<Subscription>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            final s = Subscriptions(snapshot.data!);
            return Container(
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.bodyText1!,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: PriceInfoTabView(priceInfoBuilder(s)),
                    ),
                    Expanded(
                      flex: 2,
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 20, top: 20),
                        itemCount: snapshot.data?.length,
                        itemBuilder: (BuildContext context, int index) {
                          final subsc = snapshot.data![index];
                          return InkWell(
                            onTap: () {
                              showCupertinoModalBottomSheet(
                                context: context,
                                builder: (BuildContext ctx) =>
                                    Provider<EditScreenBloc>(
                                  create: (ctx) => EditScreenBloc(),
                                  dispose: (ctx, bloc) => bloc.dispose(),
                                  child: EditPage(bloc, subsc),
                                ),
                              );
                            },
                            child: SubscriptionListItem(subsc),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }
}
