import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:subsuke/blocs/notifications_bloc.dart';
import 'package:subsuke/blocs/pagination_bloc.dart';
import 'package:subsuke/blocs/edit_screen_bloc.dart';
import 'package:subsuke/blocs/subscription_item_bloc.dart';
import 'package:subsuke/ui/components/pages/list.dart';
import 'package:subsuke/ui/components/pages/config.dart';
import 'package:subsuke/ui/components/pages/add.dart';
import 'package:subsuke/ui/components/pages/notifications.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pagination = Provider.of<PaginationBloc>(context);
    final item = Provider.of<SubscriptionItemBloc>(context);
    final resolvedTheme = Theme.of(context);
    return StreamBuilder(
      stream: pagination.currentPage,
      initialData: 0,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) => Scaffold(
          appBar: AppBar(
            title: Text(
              'Subsuke',
              style: TextStyle(
                color: resolvedTheme.appBarTheme.foregroundColor,
              ),
            ),
            backgroundColor: resolvedTheme.appBarTheme.backgroundColor,
            elevation: 0,
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                  icon: Icon(Icons.notifications_none, size: 28),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          Provider<NotificationsBloc>(
                        create: (BuildContext ctx) => NotificationsBloc(),
                        dispose: (BuildContext ctx, NotificationsBloc bloc) =>
                            bloc.dispose(),
                        child: NotificationsList(),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              size: 32,
              color: resolvedTheme.primaryColor,
            ),
            backgroundColor: resolvedTheme.backgroundColor,
            hoverColor: resolvedTheme.hoverColor,
            hoverElevation: 1.5,
            /* shape: StadiumBorder( */
            /*   side: BorderSide( */
            /*     color: resolvedTheme.primaryColor, */
            /*     width: 2, */
            /*   ), */
            /* ), */
            elevation: 12,
            onPressed: () {
              showCupertinoModalBottomSheet(
                context: context,
                builder: (BuildContext context) => Provider<EditScreenBloc>(
                  create: (context) => EditScreenBloc(),
                  dispose: (context, bloc) => bloc.dispose(),
                  child: AddPage(() => item.getItems()),
                ),
              );
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterDocked,
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
              BottomNavigationBarItem(
                label: 'リスト',
                tooltip: 'リスト',
                icon: Icon(
                  Icons.list,
                  size: 36,
                  color: resolvedTheme.iconTheme.color,
                ),
                activeIcon: Icon(
                  Icons.list,
                  size: 36,
                  color: resolvedTheme.primaryColor,
                ),
              ),
              BottomNavigationBarItem(
                label: '設定',
                icon: Icon(
                  Icons.settings,
                  size: 36,
                  color: resolvedTheme.iconTheme.color,
                ),
                activeIcon: Icon(
                  Icons.settings,
                  size: 36,
                  color: resolvedTheme.primaryColor,
                ),
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
