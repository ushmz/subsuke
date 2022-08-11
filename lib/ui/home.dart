import 'dart:io';

import 'package:flutter/material.dart';
import 'package:subsuke/ui/home.android.dart';
import 'package:subsuke/ui/home.ios.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return HomeScreenIOS();
    } else {
      return HomeScreenAndroid();
    }
  }
}
