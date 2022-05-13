import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:subsuke/models/notification.dart';

class NotificationMessageItem extends StatelessWidget {
  final NotificationMessage msg;
  NotificationMessageItem(this.msg);

  @override
  Widget build(BuildContext context) {
    final msgTitleStyle = msg.isUnread
        ? TextStyle(fontWeight: FontWeight.bold)
        : TextStyle(color: Theme.of(context).hintColor);
    final msgbodyStyle = msg.isUnread
        ? TextStyle(fontSize: 20)
        : TextStyle(color: Theme.of(context).hintColor, fontSize: 20);

    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(msg.title, style: msgTitleStyle),
                Text(
                  DateFormat('yyyy-MM-dd').format(msg.receivedAt),
                  style: msgbodyStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
