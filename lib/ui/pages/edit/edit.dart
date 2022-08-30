import 'dart:io';

import 'package:flutter/material.dart';
import 'package:subsuke/models/subsc.dart';
import 'package:subsuke/ui/pages/edit/edit.ios.dart';

class EditPage extends StatelessWidget {
  final SubscriptionItem item;
  final Function() refreshListItems;
  EditPage(this.item, this.refreshListItems);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return EditPageIOS(item);
    } else {
      return Center();
    }
  }
}
