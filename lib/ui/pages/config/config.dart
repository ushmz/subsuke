import 'dart:io';

import 'package:flutter/material.dart';
import 'package:subsuke/ui/pages/config/config.ios.dart';
import 'package:subsuke/ui/pages/config/config.android.dart';

class ConfigPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return ConfigPageIOS();
    } else {
      return ConfigPageAndroid();
    }
  }
}
