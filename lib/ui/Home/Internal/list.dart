import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/subscriptions_bloc.dart';
import 'package:subsuke/models/subsc.dart';
import 'package:subsuke/models/subsucription.dart';

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SubscriptionsBloc>(context);
    bloc.fetchRequest();
    return StreamBuilder(
        stream: bloc.onChangeSubscriptions,
        builder: (BuildContext context,
            AsyncSnapshot<List<SubscriptionItem>> snapshot) {
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
                          length: 4,
                          child: Builder(
                            builder: (BuildContext context) => Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Expanded(
                                      flex: 5,
                                      child: TabBarView(children: <Widget>[
                                        Center(
                                          child: Text("円/日",
                                              style: TextStyle(fontSize: 32)),
                                        ),
                                        Center(
                                          child: Text("円/週",
                                              style: TextStyle(fontSize: 32)),
                                        ),
                                        Center(
                                          child: Text("円/月",
                                              style: TextStyle(fontSize: 32)),
                                        ),
                                        Center(
                                          child: Text("円/年",
                                              style: TextStyle(fontSize: 32)),
                                        ),
                                      ])),
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
                          itemCount: 0,
                          itemBuilder: (BuildContext context, int index) {
                            return Slidable(
                                key: new ValueKey(index),
                                endActionPane: ActionPane(
                                  motion: ScrollMotion(),
                                  children: <Widget>[
                                    SlidableAction(
                                      onPressed: (BuildContext context) {
                                        print(context);
                                      },
                                      backgroundColor: Color(0xFF7BC043),
                                      foregroundColor: Colors.white,
                                      icon: Icons.archive,
                                      label: 'Archive',
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/edit',
                                          arguments: "");
                                    },
                                    child: DefaultTextStyle(
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
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
                                                              child: Text(
                                                                  "サービス名")),
                                                          Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                  "次回お支払日",
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
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text("円",
                                                            style: TextStyle(
                                                                fontSize: 16))))
                                              ],
                                            )),
                                      ),
                                    )));
                          }),
                    ),
                  ],
                ),
              ));
          }
        });
  }
}
