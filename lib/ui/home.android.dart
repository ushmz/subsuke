import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/pagination_bloc.dart';
import 'package:subsuke/ui/pages/config/config.dart';
import 'package:subsuke/ui/pages/list/list.dart';

class HomeScreenAndroid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pagination = Provider.of<PaginationBLoC>(context);
    final resolvedTheme = Theme.of(context);

    return StreamBuilder(
      stream: pagination.currentPage,
      initialData: 0,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        return Scaffold(
            body: [
              ListPage(),
              ConfigPage(),
            ][snapshot.data!],
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: resolvedTheme.primaryColor,
              unselectedItemColor: resolvedTheme.hintColor,
              selectedFontSize: 12,
              backgroundColor: Theme.of(context).bottomAppBarColor,
              items: [
                BottomNavigationBarItem(label: 'リスト', icon: Icon(Icons.list)),
                BottomNavigationBarItem(label: '設定', icon: Icon(Icons.settings))
              ],
              currentIndex: snapshot.data!,
              onTap: (int index) {
                if (index == snapshot.data) return;
                switch (index) {
                  case 0:
                  case 1:
                    pagination.go(index);
                    break;
                  default:
                    break;
                }
              },
            ));
      },
    );
  }
}
