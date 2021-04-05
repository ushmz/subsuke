import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  static const prices = <Widget>[
    Center(
      child: Text('56.61円 / 日', style: TextStyle(fontSize: 32)),
    ),
    Center(
      child: Text('424.56円 / 週', style: TextStyle(fontSize: 32)),
    ),
    Center(
      child: Text('1698.25円 / 月', style: TextStyle(fontSize: 32)),
    ),
    Center(
      child: Text('20,379円 / 年', style: TextStyle(fontSize: 32)),
    ),
  ];

  static var subscs = [
    {'title': 'Youtube Premium', 'nextPayment': '2021-04-11', 'price': 680},
    {'title': 'Inkdrop', 'nextPayment': '2022-04-01', 'price': 6219},
    {'title': 'Niconico ch.', 'nextPayment': '2021-05-01', 'price': 500}
  ];

  @override
  Widget build(BuildContext context) {
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
                        Expanded(flex: 5, child: TabBarView(children: prices)),
                        Expanded(flex: 1, child: TabPageSelector()),
                      ],
                    ),
                  ),
                )),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
                itemCount: subscs.length,
                itemBuilder: (BuildContext context, int index) {
                  final subsc = subscs[index];
                  return DefaultTextStyle(
                    style: Theme.of(context).textTheme.bodyText1,
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                              flex: 5,
                              child: Column(
                                children: [
                                  Text(subsc['title']),
                                  Text("次回お支払日 ${subsc['nextPayment']}")
                                ],
                              )),
                          Expanded(
                            flex: 1,
                            child: Text("${subsc['price']}円"),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    ));
  }
}
