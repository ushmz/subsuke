import 'package:flutter/material.dart';

class NotificationsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final resolvedTheme = Theme.of(context);
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
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: IconButton(
                icon: Icon(Icons.notifications_none, size: 28),
                onPressed: () {},
              ))
        ],
      ),
      body: ListView(
        children: [
          Center(),
        ],
      ),
    );
  }
}
