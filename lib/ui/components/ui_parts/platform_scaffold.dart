import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformScaffold extends StatelessWidget {
  final Widget child;

  PlatformScaffold(this.child);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(child: child);
    } else {
      return Scaffold(body: child);
    }
  }
}
