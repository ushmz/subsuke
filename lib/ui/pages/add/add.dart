import 'package:flutter/material.dart';

import 'add.ios.dart';

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
