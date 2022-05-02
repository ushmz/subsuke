import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final resolvedTheme = Theme.of(context);
    if (Platform.isIOS) {
      return CupertinoNavigationBar(
        middle: Text("Subsuke"),
        brightness: Theme.of(context).brightness,
      );
    } else {
      return AppBar(
        title: Text(
          'Subsuke',
          style: TextStyle(
            color: resolvedTheme.appBarTheme.foregroundColor,
          ),
        ),
        backgroundColor: resolvedTheme.appBarTheme.backgroundColor,
      );
    }
  }
}
