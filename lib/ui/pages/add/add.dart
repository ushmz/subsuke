import 'dart:io';

import 'package:flutter/material.dart';

import 'add.ios.dart';
import 'add.android.dart';

class AddPage extends StatelessWidget {
  final Function updateItems;
  AddPage(this.updateItems);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return AddPageIOS();
    } else {
      return AddPageAndroid(updateItems);
    }
  }
}
