import 'dart:io';

import 'package:flutter/material.dart';
import 'package:subsuke/ui/pages/list/list.android.dart';
import 'package:subsuke/ui/pages/list/list.ios.dart';

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return ListPageIOS();
    } else {
      return ListPageAndroid();
    }
  }
}
