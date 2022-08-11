import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/notifications_bloc.dart';
import 'package:subsuke/models/notification.dart';
import 'package:subsuke/ui/components/ui_parts/notification_message.dart';

class NotificationsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<NotificationsBLoC>(context);
    final resolvedTheme = Theme.of(context);

    /* Widget readAllConfirmationDialogBuilder(BuildContext context) { */
    /*     return */
    /* } */

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'お知らせ',
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
              icon: Icon(Icons.done_all, size: 28),
              onPressed: () async {
                if (bloc.messagesCount == 0) {
                  return null;
                }
                if (Platform.isIOS) {
                  showCupertinoDialog(
                      context: context,
                      builder: (BuildContext ctx) {
                        return Container(
                          /* color: Theme.of(ctx).scaffoldBackgroundColor, */
                          height: MediaQuery.of(ctx).size.height / 3,
                          child: CupertinoTheme(
                              data: CupertinoThemeData(
                                  brightness: Theme.of(ctx).brightness),
                              child: CupertinoAlertDialog(
                                title: Text("すべてを削除しますか？"),
                                /* content: Text("すべてを削除しますか？"), */
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("いいえ")),
                                  TextButton(
                                      onPressed: () {
                                        bloc.deleteAll();
                                        Navigator.pop(context);
                                      },
                                      child: Text("はい")),
                                ],
                              )),
                        );
                      });
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext ctx) {
                        return AlertDialog(
                          title: Text("すべてを削除しますか？"),
                          /* content: Text("すべてを削除しますか？"), */
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("いいえ")),
                            TextButton(
                                onPressed: () {
                                  bloc.deleteAll();
                                  Navigator.pop(context);
                                },
                                child: Text("はい")),
                          ],
                        );
                      });
                }
                await bloc.updateAll();
              },
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: bloc.messageStream,
        builder:
            (BuildContext ctx, AsyncSnapshot<List<NotificationMessage>> ss) {
          switch (ss.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
            case ConnectionState.done:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            default:
              if (bloc.messagesCount == 0) {
                return Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /* Spacer(flex: 5), */
                        /* SvgPicture.asset( */
                        /*   "assets/image.svg", */
                        /*   width: MediaQuery.of(ctx).size.width * 0.8, */
                        /* ), */
                        /* Spacer(flex: 1), */
                        Text("現在お知らせはありません。", style: TextStyle(fontSize: 20)),
                        /* Spacer(flex: 5), */
                      ],
                    ),
                  ),
                );
              }
              final messages = ss.data!;
              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (BuildContext c, int i) {
                  return InkWell(
                    onTap: () {},
                    child: Slidable(
                      key: ValueKey(messages[i].id),
                      endActionPane: ActionPane(
                        extentRatio: 0.2,
                        motion: BehindMotion(),
                        children: [
                          SlidableAction(
                            flex: 1,
                            onPressed: (BuildContext context) {},
                            backgroundColor: Theme.of(ctx).primaryColor,
                            icon: Icons.delete,
                            label: "削除",
                          )
                        ],
                      ),
                      child: NotificationMessageItem(messages[i]),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
