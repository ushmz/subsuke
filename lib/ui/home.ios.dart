import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/* import 'package:subsuke/ui/pages/analytics.dart'; */
import 'package:subsuke/ui/pages/config/config.dart';
import 'package:subsuke/ui/pages/list/list.dart';

class HomeScreenIOS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> _list = [
      ListPage(),
      /* AnalyticsPage(), */
      ConfigPage(),
    ];

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: Theme.of(context).primaryColor,
        height: 55,
        items: [
          BottomNavigationBarItem(label: "リスト", icon: Icon(Icons.list)),
          /* BottomNavigationBarItem(label: "分析", icon: Icon(Icons.analytics)), */
          BottomNavigationBarItem(label: "設定", icon: Icon(Icons.settings)),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoPageScaffold(child: _list[index]);
      },
    );
  }
}
