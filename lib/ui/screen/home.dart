import 'package:flutter/material.dart';
import 'package:subsuke/blocs/pagination_bloc.dart';
import 'package:subsuke/ui/pages/list.dart';
import 'package:subsuke/ui/pages/config.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pagination = Provider.of<PaginationBloc>(context);
    return StreamBuilder(
      stream: pagination.currentPage,
      initialData: 0,
      builder: (context, snapshot) => Scaffold(
          appBar: AppBar(
            title: Text('subsuke'),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add, size: 32),
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: [
            ListPage(),
            // LinkPage(),
            ConfigPage(),
          ][snapshot.data],
          bottomNavigationBar: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                  label: 'リスト',
                  icon: Icon(
                    Icons.list,
                    size: 36,
                  ),
                  activeIcon: Icon(
                    Icons.list,
                    size: 36,
                    color: Theme.of(context).primaryColor,
                  )),
              BottomNavigationBarItem(
                  label: '設定',
                  icon: Icon(Icons.settings, size: 36),
                  activeIcon: Icon(
                    Icons.list,
                    size: 36,
                    color: Theme.of(context).primaryColor,
                  ))
            ],
            currentIndex: snapshot.data,
            onTap: (int index) {
              if (index == snapshot.data) return;
              switch (index) {
                case 0:
                  pagination.go(index);
                  break;
                case 1:
                  pagination.go(index);
                  break;
                default:
                  break;
              }
            },
          )),
    );
  }
}
