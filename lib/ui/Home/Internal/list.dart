import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/subscriptions_bloc.dart';
import 'package:subsuke/models/subsucription.dart';

class ListPage extends StatelessWidget {
  static const prices = <Widget>[
    Center(
      // child: Text('56.61円 / 日', style: TextStyle(fontSize: 32)),
      child: Text('57円 / 日', style: TextStyle(fontSize: 32)),
    ),
    Center(
      // child: Text('424.56円 / 週', style: TextStyle(fontSize: 32)),
      child: Text('425円 / 週', style: TextStyle(fontSize: 32)),
    ),
    Center(
      // child: Text('1698.25円 / 月', style: TextStyle(fontSize: 32)),
      child: Text('1,698円 / 月', style: TextStyle(fontSize: 32)),
    ),
    Center(
      child: Text('20,379円 / 年', style: TextStyle(fontSize: 32)),
    ),
  ];

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
              return Container(
                  child: DefaultTextStyle(
                style: Theme.of(context).textTheme.bodyText1,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: DefaultTabController(
                          length: prices.length,
                          child: Builder(
                            builder: (BuildContext context) => Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Expanded(
                                      flex: 5,
                                      child: TabBarView(children: prices)),
                                  Expanded(flex: 1, child: TabPageSelector()),
                                ],
                              ),
                            ),
                          )),
                    ),
                    Expanded(
                      flex: 2,
                      child: ListView.builder(
                          padding: EdgeInsets.only(bottom: 20, top: 20),
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final subsc = snapshot.data[index];
                            return InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, '/edit',
                                      arguments: subsc);
                                },
                                child: DefaultTextStyle(
                                  style: Theme.of(context).textTheme.bodyText1,
                                  child: SizedBox(
                                    height: 56,
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 5,
                                              child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Column(
                                                    children: [
                                                      Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child:
                                                              Text(subsc.name)),
                                                      Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                              "次回お支払日 ${subsc.billingAt}",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText2))
                                                    ],
                                                  )),
                                            ),
                                            Expanded(
                                                flex: 1,
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text(
                                                        "${subsc.price}円",
                                                        style: TextStyle(
                                                            fontSize: 16))))
                                          ],
                                        )),
                                  ),
                                ));
                          }),
                    ),
                  ],
                ),
              ));
          }
        });
  }
}
