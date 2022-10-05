import 'dart:io';

import 'package:flutter/material.dart';
import 'package:subsuke/ui/pages/add/add.android.dart';
import 'package:subsuke/ui/pages/add/add.ios.dart';

class AddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return AddPageIOS();
    } else {
      return AddPageAndroid();
    }
  }
}
