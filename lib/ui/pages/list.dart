import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  static const prices = <Widget>[
    Center(
      child: Text('日毎'),
    ),
    Center(
      child: Text('週毎'),
    ),
    Center(
      child: Text('月毎'),
    ),
    Center(
      child: Text('年毎'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: ListView(
              children: [
                ListTile(
                  title: Text('サブスク名'),
                  subtitle: Text('月額とか'),
                ),
                ListTile(
                  title: Text('サブスク名'),
                  subtitle: Text('月額とか'),
                ),
                ListTile(
                  title: Text('サブスク名'),
                  subtitle: Text('月額とか'),
                ),
                ListTile(
                  title: Text('サブスク名'),
                  subtitle: Text('月額とか'),
                ),
                ListTile(
                  title: Text('サブスク名'),
                  subtitle: Text('月額とか'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
