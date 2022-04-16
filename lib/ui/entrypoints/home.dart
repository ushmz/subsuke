import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:subsuke/blocs/pagination_bloc.dart';
import 'package:subsuke/blocs/edit_screen_bloc.dart';
import 'package:subsuke/blocs/subscriptions_bloc.dart';
import 'package:subsuke/ui/components/pages/list.dart';
import 'package:subsuke/ui/components/pages/config.dart';
import 'package:subsuke/ui/components/pages/add.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pagination = Provider.of<PaginationBloc>(context);
    final subscription = Provider.of<SubscriptionsBloc>(context);
    return StreamBuilder(
      stream: pagination.currentPage,
      initialData: 0,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) => Scaffold(
          appBar: AppBar(
            title: Text('subsuke'),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add,
                size: 32, color: Theme.of(context).primaryColor),
            backgroundColor: Colors.white,
            onPressed: () {
              showCupertinoModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) => Provider<EditScreenBloc>(
                        create: (context) => EditScreenBloc(),
                        dispose: (context, bloc) => bloc.dispose(),
                        child: AddPage(subscription),
                      ));
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterDocked,
          body: [
            ListPage(),
            ConfigPage(),
          ][snapshot.data!],
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white54,
            selectedFontSize: 12,
            backgroundColor: Theme.of(context).bottomAppBarColor,
            items: [
              BottomNavigationBarItem(
                label: 'リスト',
                tooltip: 'リスト',
                icon: Icon(Icons.list, size: 36),
                activeIcon: Icon(Icons.list, size: 36),
              ),
              BottomNavigationBarItem(
                label: '設定',
                icon: Icon(Icons.settings, size: 36),
                activeIcon: Icon(Icons.settings, size: 36),
              )
            ],
            currentIndex: snapshot.data!,
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
