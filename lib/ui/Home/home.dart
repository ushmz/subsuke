import 'package:flutter/material.dart';
import 'package:subsuke/blocs/pagination_bloc.dart';
import 'package:subsuke/blocs/edit_screen_bloc.dart';
import 'package:subsuke/blocs/subscriptions_bloc.dart';
import 'package:subsuke/ui/Home/Internal/list.dart';
import 'package:subsuke/ui/Home/Internal/config.dart';
import 'package:subsuke/ui/Home/Internal/add.dart';
import 'package:provider/provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pagination = Provider.of<PaginationBloc>(context);
    final subscription = Provider.of<SubscriptionsBloc>(context);
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
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       fullscreenDialog: true,
              //       builder: (BuildContext context) => Provider<EditScreenBloc>(
              //             create: (context) => EditScreenBloc(),
              //             dispose: (context, bloc) => bloc.dispose(),
              //             child: AddPage(),
              //           )),
              // );
              showBarModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) => Provider<EditScreenBloc>(
                        create: (context) => EditScreenBloc(),
                        dispose: (context, bloc) => bloc.dispose(),
                        child: AddPage(subscription),
                      ));
            },
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
