import 'dart:io';

import 'package:flutter/material.dart';
import 'package:subsuke/models/subsc.dart';
import 'package:subsuke/ui/pages/add/add.android.dart';
import 'package:subsuke/ui/pages/add/add.ios.dart';

class AddPage extends StatelessWidget {
  final Function(SubscriptionItem) onAdd;
  AddPage({
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return AddPageIOS(onAdd: onAdd);
    } else {
      return AddPageAndroid();
    }
  }
}
