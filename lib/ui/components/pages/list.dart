import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/edit_screen_bloc.dart';
import 'package:subsuke/blocs/subscription_item_bloc.dart';
import 'package:subsuke/models/subsc.dart';
import 'package:subsuke/ui/components/pages/edit.dart';
import 'package:subsuke/ui/components/ui_parts/price_tabbar_view.dart';
import 'package:subsuke/ui/components/ui_parts/subscription_list_item.dart';

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SubscriptionItemBloc>(context);
    bloc.getItems();
    return StreamBuilder(
      stream: bloc.onChangeSubscriptionItems,
      builder: (BuildContext context,
          AsyncSnapshot<List<SubscriptionItem>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            return Container(
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.bodyText1!,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: PriceInfoTabView(snapshot.data!),
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
                                  child: EditPage(subsc, () => bloc.getItems()),
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
